import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_utils.dart';

/// Utility class for handling image picking with permission management
class ImagePickerUtils {
  static final ImagePicker _picker = ImagePicker();



  /// Returns the picked image file path, or null if cancelled/error
  static Future<String?> pickImage({
    required ImageSource source,
    required BuildContext context,
    int maxWidth = 512,
    int maxHeight = 512,
    int imageQuality = 85,
  }) async {
    debugPrint('ImagePickerUtils: Picking image from: $source');

    // Request permission based on source
    Permission permission;
    String permissionMessage;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
      permissionMessage = 'Camera permission is required to take photos';
    } else {
      // For gallery, use photos permission (works for both iOS and Android 13+)
      permission = Permission.photos;
      permissionMessage = 'Photo library permission is required to select images';
    }

    // Check current permission status
    PermissionStatus status = await permission.status;
    debugPrint('ImagePickerUtils: Permission status: $status');

    // Request permission if not granted
    if (!status.isGranted) {
      status = await permission.request();
      debugPrint('ImagePickerUtils: Permission request result: $status');

      if (!status.isGranted) {
        // Permission denied
        if (status.isPermanentlyDenied) {
          // Show dialog to open app settings
          _showPermissionDeniedDialog(context, permissionMessage);
        } else {
          AppUtils.showToast(context, message: permissionMessage);
        }
        return null;
      }
    }

    // Permission granted, proceed with image picking
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (image != null) {
        debugPrint('ImagePickerUtils: Image selected: ${image.path}');
        return image.path;
      }
      return null;
    } catch (e) {
      debugPrint('ImagePickerUtils: Error picking image: $e');
      AppUtils.showToast(context, message: 'Failed to pick image');
      return null;
    }
  }

  /// Show permission denied dialog with option to open app settings
  static void _showPermissionDeniedDialog(
    BuildContext context,
    String message,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text('$message. Please enable it in app settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Show bottom sheet for selecting image source (Camera or Gallery)
  /// 
  /// [context] - BuildContext for showing the bottom sheet
  /// [onCameraSelected] - Callback when camera is selected
  /// [onGallerySelected] - Callback when gallery is selected
  static void showImageSourceBottomSheet({
    required BuildContext context,
    required VoidCallback onCameraSelected,
    required VoidCallback onGallerySelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onCameraSelected();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onGallerySelected();
              },
            ),
          ],
        ),
      ),
    );
  }
}

