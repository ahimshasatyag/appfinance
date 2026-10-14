import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';

class CreateSplitBillSkeleton extends StatelessWidget {
  const CreateSplitBillSkeleton({super.key});

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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Bill Title Input Skeleton
          _shimmerBox(
            width: double.infinity,
            height: 56,
            baseColor: baseColor,
            highlightColor: highlightColor,
            radius: 12,
          ),
          const SizedBox(height: 24),

          // 2. Members Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(
                width: 140,
                height: 20,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 6,
              ),
              _shimmerBox(
                width: 65,
                height: 20,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 6,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Member horizontal chips
          SizedBox(
            height: 82,
            child: Row(
              children: [
                _shimmerBox(
                  width: 72,
                  height: 82,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 16,
                ),
                const SizedBox(width: 12),
                _shimmerBox(
                  width: 72,
                  height: 82,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 16,
                ),
                const SizedBox(width: 12),
                _shimmerBox(
                  width: 72,
                  height: 82,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 16,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 3. Items Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(
                width: 130,
                height: 20,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 6,
              ),
              _shimmerBox(
                width: 100,
                height: 32,
                baseColor: baseColor,
                highlightColor: highlightColor,
                radius: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Item Cards Skeleton
          ...List.generate(2, (index) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: 130,
                            height: 16,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 6,
                          ),
                          const SizedBox(height: 6),
                          _shimmerBox(
                            width: 90,
                            height: 12,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 4,
                          ),
                        ],
                      ),
                      _shimmerBox(
                        width: 80,
                        height: 18,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 6,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(
                    height: 1,
                    color: isDark ? Colors.white10 : Colors.grey.shade100,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _shimmerBox(
                        width: 120,
                        height: 12,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 4,
                      ),
                      _shimmerBox(
                        width: 60,
                        height: 12,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _shimmerBox(
                        width: 60,
                        height: 28,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 16,
                      ),
                      const SizedBox(width: 8),
                      _shimmerBox(
                        width: 70,
                        height: 28,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 16,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),

          // 4. Summary Card Skeleton
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.grey.shade200,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(
                      width: 140,
                      height: 18,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 6,
                    ),
                    _shimmerBox(
                      width: 75,
                      height: 16,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 6,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(
                      width: 110,
                      height: 14,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 4,
                    ),
                    _shimmerBox(
                      width: 70,
                      height: 14,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(
                      width: 90,
                      height: 14,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 4,
                    ),
                    _shimmerBox(
                      width: 60,
                      height: 14,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 4,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Divider(
                  height: 1,
                  color: isDark ? Colors.white10 : Colors.grey.shade100,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(
                      width: 100,
                      height: 18,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 6,
                    ),
                    _shimmerBox(
                      width: 110,
                      height: 20,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 6,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // 5. Submit Button Skeleton
          _shimmerBox(
            width: double.infinity,
            height: 52,
            baseColor: baseColor,
            highlightColor: highlightColor,
            radius: 16,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
