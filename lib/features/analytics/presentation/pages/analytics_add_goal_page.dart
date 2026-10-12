import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/utils/formatters.dart';
import '../widgets/analytics_form_skeleton.dart';
class AnalyticsAddGoalPage extends StatefulWidget {
  const AnalyticsAddGoalPage({super.key});

  @override
  State<AnalyticsAddGoalPage> createState() => _AnalyticsAddGoalPageState();
}

class _AnalyticsAddGoalPageState extends State<AnalyticsAddGoalPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentAmountController =
      TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Simulate initial loading to show skeleton
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    });
  }

  void _saveGoal() async {
    if (_nameController.text.trim().isEmpty ||
        _targetAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseFillRequiredFields)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      CustomDialog.showSuccess(
        context,
        title: context.l10n.success,
        message: context.l10n.goalAddedSuccess,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentAmountController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : const Color(0xFF1E293B)),
        title: Text(
          context.l10n.addFinancialGoal,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isInitializing ? const AnalyticsFormSkeleton() : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.goalDetails,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField(
              context: context,
              label: context.l10n.goalName,
              hint: context.l10n.goalNameHint,
              controller: _nameController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context: context,
              label: context.l10n.currentAmountOptional,
              hint: context.l10n.currentAmountHint,
              keyboardType: TextInputType.number,
              controller: _currentAmountController,
              inputFormatters: [_CurrencyInputFormatter()],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              context: context,
              label: context.l10n.targetAmount,
              hint: context.l10n.targetAmountHint,
              keyboardType: TextInputType.number,
              controller: _targetAmountController,
              inputFormatters: [_CurrencyInputFormatter()],
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: context.l10n.saveGoal,
              isLoading: _isLoading,
              onPressed: _saveGoal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey.shade400 : Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.grey.shade500 : Colors.grey,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF1E293B) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanText.isEmpty) return newValue.copyWith(text: '');

    double value = double.parse(cleanText);
    String formattedText = Formatters.formatNumber(value);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
