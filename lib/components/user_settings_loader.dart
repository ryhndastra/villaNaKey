import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UserSettingsSkeleton extends StatelessWidget {
  const UserSettingsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                shimmerBox(width: 25, height: 25),
                const SizedBox(width: 12),
                shimmerBox(width: 100, height: 16),
              ],
            ),
            const SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerBox(width: 200, height: 16),
                  const SizedBox(height: 13),
                  shimmerBox(width: 220, height: 16),
                  const SizedBox(height: 13),
                  shimmerBox(width: 180, height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Divider(thickness: 1, color: Colors.grey.shade400),
            const SizedBox(height: 24),

            Row(
              children: [
                shimmerBox(width: 25, height: 25),
                const SizedBox(width: 12),
                shimmerBox(width: 220, height: 16),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 50),
              child: shimmerBox(width: 160, height: 16),
            ),

            const SizedBox(height: 40),
            // Logout button
            shimmerBox(width: double.infinity, height: 50),
          ],
        ),
      ),
    );
  }

  Widget shimmerBox({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
