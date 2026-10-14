import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';

class SplitBillHistorySkeleton extends StatelessWidget {
  const SplitBillHistorySkeleton({super.key});

  Widget _shimmerBox({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    double radius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips Skeleton
          Row(
            children: [
              _shimmerBox(
                width: 72,
                height: 36,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 20,
              ),
              const SizedBox(width: 8),
              _shimmerBox(
                width: 120,
                height: 36,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 20,
              ),
              const SizedBox(width: 8),
              _shimmerBox(
                width: 90,
                height: 36,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bill Cards Skeleton
          ...List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Status Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _shimmerBox(
                        width: index % 2 == 0 ? 160 : 200,
                        height: 18,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 6,
                      ),
                      _shimmerBox(
                        width: 64,
                        height: 22,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date and info
                  _shimmerBox(
                    width: 220,
                    height: 12,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    radius: 4,
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                  ),
                  const SizedBox(height: 12),

                  // Grand total & Paid count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: 60,
                            height: 10,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 4,
                          ),
                          const SizedBox(height: 6),
                          _shimmerBox(
                            width: 110,
                            height: 16,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 6,
                          ),
                        ],
                      ),
                      _shimmerBox(
                        width: 85,
                        height: 20,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 12,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
