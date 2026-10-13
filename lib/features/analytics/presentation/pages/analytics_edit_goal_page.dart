import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../app/config/l10n.dart';
import '../widgets/analytics_form_skeleton.dart';

class AnalyticsEditGoalPage extends StatefulWidget {
  final FinancialGoal goal;

  const AnalyticsEditGoalPage({super.key, required this.goal});

  @override
  State<AnalyticsEditGoalPage> createState() => _AnalyticsEditGoalPageState();
}

class _AnalyticsEditGoalPageState extends State<AnalyticsEditGoalPage> {
  late TextEditingController _nameController;
  late TextEditingController _currentAmountController;
  late TextEditingController _targetAmountController;
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal.name);
    _currentAmountController = TextEditingController(
      text: Formatters.formatNumber(widget.goal.currentAmount),
    );
    _targetAmountController = TextEditingController(
      text: Formatters.formatNumber(widget.goal.targetAmount),
    );

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
    if (_nameController.text.trim().isEmpty || _targetAmountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseFillRequiredFields)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call for editing
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      CustomDialog.showSuccess(
        context,
        title: context.l10n.success,
        message: context.l10n.goalUpdatedSuccess,
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
        title: Text(
          context.l10n.editFinancialGoal,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isInitializing
          ? const AnalyticsFormSkeleton()
          : SingleChildScrollView(
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
                    text: context.l10n.updateGoal,
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

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
          fontSize: 14,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade200,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    
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
