import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          shimmerBox(width: double.infinity, height: 200),
          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: shimmerBox(height: 100)),
                const SizedBox(width: 12),
                shimmerBox(width: 150, height: 150),
              ],
            ),
          ),

          const SizedBox(height: 20),
          shimmerBox(width: double.infinity, height: 200),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(width: 180, height: 20),
                const SizedBox(height: 8),
                shimmerBox(width: 140, height: 16),
                const SizedBox(height: 8),
                shimmerBox(width: 220, height: 14),
                const SizedBox(height: 6),
                shimmerBox(width: 160, height: 14),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(5, (_) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: shimmerBox(width: 90, height: 36),
                );
              }),
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(width: 120, height: 20),
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: 4,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: shimmerBox(width: 220, height: 120),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: shimmerBox(width: 200, height: 40),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(width: 100, height: 20),
          ),

          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: shimmerBox(width: double.infinity, height: 175),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget shimmerBox({double width = double.infinity, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
