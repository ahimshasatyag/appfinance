import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_colors.dart';

class SplitBillDetailSkeleton extends StatelessWidget {
  const SplitBillDetailSkeleton({super.key});

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
          // 1. Bill Overview Hero Card Skeleton
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _shimmerBox(
                      width: 170,
                      height: 20,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 6,
                    ),
                    _shimmerBox(
                      width: 65,
                      height: 22,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      radius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _shimmerBox(
                  width: 130,
                  height: 12,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 4,
                ),
                const SizedBox(height: 20),
                _shimmerBox(
                  width: 80,
                  height: 12,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 4,
                ),
                const SizedBox(height: 6),
                _shimmerBox(
                  width: 160,
                  height: 28,
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  radius: 8,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: 85,
                            height: 11,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 4,
                          ),
                          const SizedBox(height: 6),
                          _shimmerBox(
                            width: 100,
                            height: 16,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 24,
                      width: 1,
                      color: isDark ? Colors.white24 : Colors.grey.shade400,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _shimmerBox(
                            width: 90,
                            height: 11,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 4,
                          ),
                          const SizedBox(height: 6),
                          _shimmerBox(
                            width: 100,
                            height: 16,
                            baseColor: baseColor,
                            highlightColor: highlightColor,
                            radius: 6,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // 2. Who Pays What Section Header
          _shimmerBox(
            width: 180,
            height: 20,
            baseColor: baseColor,
            highlightColor: highlightColor,
            radius: 6,
          ),
          const SizedBox(height: 14),

          // Member Share Cards Skeleton
          ...List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  _shimmerBox(
                    width: 40,
                    height: 40,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerBox(
                          width: index == 0 ? 80 : 120,
                          height: 16,
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          radius: 4,
                        ),
                        const SizedBox(height: 6),
                        _shimmerBox(
                          width: 70,
                          height: 12,
                          baseColor: baseColor,
                          highlightColor: highlightColor,
                          radius: 4,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _shimmerBox(
                        width: 90,
                        height: 16,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 4,
                      ),
                      const SizedBox(height: 6),
                      _shimmerBox(
                        width: 45,
                        height: 10,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                        radius: 4,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 16),

          // 3. Summary Card Skeleton
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
                      width: 130,
                      height: 18,
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
                const SizedBox(height: 12),
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

          // 4. Bottom Main Action Button Skeleton
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
