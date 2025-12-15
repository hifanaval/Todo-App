import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'skeleton_item.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        itemCount: 5,
        itemBuilder: (context, index) {
          return const SkeletonItem();
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
      ),
    );
  }
}

