import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletDetailSkeleton extends StatelessWidget {
  const WalletDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Physical Card Skeleton
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 200,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
          ),
        ),
        const SizedBox(height: 24),
        
        // Summary Skeleton
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 120,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 24),
        
        // Chart Skeleton
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            height: 300,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 32),
        
        // Transaction History Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 24, width: 150, color: Colors.white),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 24, width: 60, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Transaction Summary Chips
        Row(
          children: List.generate(3, (index) => Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(height: 32, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
            ),
          )),
        ),
        const SizedBox(height: 16),

        // Transaction List items
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(height: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16))),
          ),
        )),
      ],
    );
  }
}
