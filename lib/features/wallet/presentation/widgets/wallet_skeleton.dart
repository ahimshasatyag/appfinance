import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../shared/theme/app_theme.dart';

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlightColor = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Header (matches WalletHeader)
        _buildHeaderSkeleton(baseColor, highlightColor),
        const SizedBox(height: 24),

        // 2. Total Balance Card (matches WalletTotalBalance)
        _buildTotalBalanceSkeleton(context, isDark),
        const SizedBox(height: 16),

        // 3. Summary (matches WalletSummary - 3 cards)
        _buildSummarySkeleton(context, isDark, baseColor, highlightColor),
        const SizedBox(height: 24),

        // 4. Distribution Chart (matches WalletDistributionChart)
        _buildDistributionChartSkeleton(context, isDark, baseColor, highlightColor),
        const SizedBox(height: 24),

        // 5. Wallet List (matches WalletList & WalletCards)
        _buildWalletListSkeleton(context, isDark, baseColor, highlightColor),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    required Color baseColor,
    required Color highlightColor,
    double radius = 4,
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

  // 1. Header Skeleton
  Widget _buildHeaderSkeleton(Color baseColor, Color highlightColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBox(
          width: 150,
          height: 26,
          radius: 6,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
        const SizedBox(height: 8),
        _shimmerBox(
          width: 220,
          height: 14,
          radius: 4,
          baseColor: baseColor,
          highlightColor: highlightColor,
        ),
      ],
    );
  }

  // 2. Total Balance Card Skeleton
  Widget _buildTotalBalanceSkeleton(BuildContext context, bool isDark) {
    final cardBaseColor = Colors.white.withValues(alpha: 0.25);
    final cardHighlightColor = Colors.white.withValues(alpha: 0.55);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(
                width: 85,
                height: 14,
                radius: 4,
                baseColor: cardBaseColor,
                highlightColor: cardHighlightColor,
              ),
              _shimmerBox(
                width: 22,
                height: 22,
                radius: 11,
                baseColor: cardBaseColor,
                highlightColor: cardHighlightColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          _shimmerBox(
            width: 190,
            height: 32,
            radius: 6,
            baseColor: cardBaseColor,
            highlightColor: cardHighlightColor,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: 100,
                      height: 16,
                      radius: 4,
                      baseColor: cardBaseColor,
                      highlightColor: cardHighlightColor,
                    ),
                    const SizedBox(height: 6),
                    _shimmerBox(
                      width: 80,
                      height: 12,
                      radius: 4,
                      baseColor: cardBaseColor,
                      highlightColor: cardHighlightColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: 100,
                      height: 16,
                      radius: 4,
                      baseColor: cardBaseColor,
                      highlightColor: cardHighlightColor,
                    ),
                    const SizedBox(height: 6),
                    _shimmerBox(
                      width: 80,
                      height: 12,
                      radius: 4,
                      baseColor: cardBaseColor,
                      highlightColor: cardHighlightColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _shimmerBox(
            width: 130,
            height: 24,
            radius: 20,
            baseColor: cardBaseColor,
            highlightColor: cardHighlightColor,
          ),
        ],
      ),
    );
  }

  // 3. Summary Skeleton (3 Cards)
  Widget _buildSummarySkeleton(
    BuildContext context,
    bool isDark,
    Color baseColor,
    Color highlightColor,
  ) {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard(context, isDark, baseColor, highlightColor)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(context, isDark, baseColor, highlightColor)),
        const SizedBox(width: 12),
        Expanded(child: _buildSummaryCard(context, isDark, baseColor, highlightColor)),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    bool isDark,
    Color baseColor,
    Color highlightColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: 50,
            height: 12,
            radius: 4,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
          const SizedBox(height: 8),
          _shimmerBox(
            width: 75,
            height: 16,
            radius: 4,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
        ],
      ),
    );
  }

  // 4. Distribution Chart Skeleton
  Widget _buildDistributionChartSkeleton(
    BuildContext context,
    bool isDark,
    Color baseColor,
    Color highlightColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _shimmerBox(
            width: 140,
            height: 18,
            radius: 4,
            baseColor: baseColor,
            highlightColor: highlightColor,
          ),
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Shimmer.fromColors(
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 22,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _shimmerBox(
                        width: 80,
                        height: 14,
                        radius: 4,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                      const SizedBox(height: 6),
                      _shimmerBox(
                        width: 50,
                        height: 10,
                        radius: 4,
                        baseColor: baseColor,
                        highlightColor: highlightColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 10,
            children: List.generate(
              3,
              (index) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _shimmerBox(
                    width: 10,
                    height: 10,
                    radius: 5,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(width: 6),
                  _shimmerBox(
                    width: 70,
                    height: 12,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 5. Wallet List Skeleton
  Widget _buildWalletListSkeleton(
    BuildContext context,
    bool isDark,
    Color baseColor,
    Color highlightColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shimmerBox(
              width: 120,
              height: 18,
              radius: 4,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            _shimmerBox(
              width: 65,
              height: 14,
              radius: 4,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _shimmerBox(
              width: 90,
              height: 14,
              radius: 4,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
            _shimmerBox(
              width: 110,
              height: 12,
              radius: 4,
              baseColor: baseColor,
              highlightColor: highlightColor,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(
          3,
          (index) => _buildWalletCardSkeleton(
            context,
            isDark,
            baseColor,
            highlightColor,
            hasLastActivity: index == 0,
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCardSkeleton(
    BuildContext context,
    bool isDark,
    Color baseColor,
    Color highlightColor, {
    bool hasLastActivity = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _shimmerBox(
                width: 48,
                height: 48,
                radius: 12,
                baseColor: baseColor,
                highlightColor: highlightColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _shimmerBox(
                      width: 120,
                      height: 16,
                      radius: 4,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                    const SizedBox(height: 6),
                    _shimmerBox(
                      width: 75,
                      height: 12,
                      radius: 4,
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _shimmerBox(
                    width: 95,
                    height: 16,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  const SizedBox(height: 6),
                  _shimmerBox(
                    width: 55,
                    height: 12,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ],
              ),
            ],
          ),
          if (hasLastActivity) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _shimmerBox(
                    width: 80,
                    height: 12,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                  _shimmerBox(
                    width: 100,
                    height: 12,
                    radius: 4,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
