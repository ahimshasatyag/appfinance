import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomLoading extends StatelessWidget {
  final double size;
  final Color? color;

  const CustomLoading({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppTheme.primaryColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
