import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletSkeleton extends StatelessWidget {
  const WalletSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300, highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade100, child: Container(width: 100, height: 28, color: Colors.white)),
            Shimmer.fromColors(baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300, highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade100, child: Container(width: 60, height: 28, color: Colors.white)),
          ],
        ),
        const SizedBox(height: 24),
        Shimmer.fromColors(
          baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
          highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade100,
          child: Container(
            height: 180,
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24)),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(3, (index) => Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index < 2 ? 12.0 : 0),
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
                highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade100,
                child: Container(height: 70, decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16))),
              ),
            ),
          )),
        ),
        const SizedBox(height: 24),
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade300,
            highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade100,
            child: Container(height: 120, decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16))),
          ),
        )),
      ],
    );
  }
}
