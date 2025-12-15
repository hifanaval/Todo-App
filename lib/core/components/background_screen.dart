import 'package:flutter/material.dart';
import 'package:to_do_app/core/constants/color_class.dart';

class BackgroundPattern extends StatelessWidget {
  final Widget child;
  
  const BackgroundPattern({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorClass.kBackgroundColor,
                ColorClass.kBackgroundLight,
              ],
            ),
          ),
        ),
        // Subtle organic shapes
        Positioned(
          top: -50,
          right: -30,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeGreen.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          left: -20,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeBeige.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: -50,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeGreen.withOpacity(0.2),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: ColorClass.kDecorativeBeige.withOpacity(0.3),
              borderRadius: BorderRadius.circular(90),
            ),
          ),
        ),
        // Content
        child,
      ],
    );
  }
}

