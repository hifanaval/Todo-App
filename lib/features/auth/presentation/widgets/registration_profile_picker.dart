import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';

class RegistrationProfilePicker extends StatelessWidget {
  final File? profilePicture;
  final VoidCallback onTap;

  const RegistrationProfilePicker({
    super.key,
    required this.profilePicture,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = isDark ? ColorClass.darkPrimary : ColorClass.kPrimaryColor;

    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor.withOpacity(0.1),
              backgroundImage: profilePicture != null
                  ? FileImage(profilePicture!)
                  : null,
              child: profilePicture == null
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: primaryColor,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: primaryColor,
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

