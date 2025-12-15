import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';

class ProfilePicturePicker extends StatelessWidget {
  final String? profilePicturePath;
  final VoidCallback onPickImage;

  const ProfilePicturePicker({
    super.key,
    required this.profilePicturePath,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;
    final cardColor = isDark ? ColorClass.darkCard : ColorClass.kCardColor;
    final backgroundColor = isDark ? ColorClass.darkMuted : ColorClass.neutral200;
    final iconColor = isDark ? ColorClass.darkMutedForeground : ColorClass.kTextSecondary;

    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor,
                width: 3,
              ),
              color: backgroundColor,
            ),
            child: profilePicturePath != null && File(profilePicturePath!).existsSync()
                ? ClipOval(
                    child: Image.file(
                      File(profilePicturePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 60,
                    color: iconColor,
                  ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: cardColor,
                  width: 2,
                ),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: onPickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

