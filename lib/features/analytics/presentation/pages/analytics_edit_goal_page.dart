import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/analytics_entity.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/utils/formatters.dart';
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
      text: Formatters.formatNumber(widget.goal.currentAmount)
    );
    _targetAmountController = TextEditingController(
      text: Formatters.formatNumber(widget.goal.targetAmount)
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
        const SnackBar(content: Text('Please fill all required fields')),
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
        title: 'Success',
        message: 'Financial Goal has been updated successfully',
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        title: Text('Edit Financial Goal', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
      ),
      body: _isInitializing ? const AnalyticsFormSkeleton() : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Goal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildTextField(
              label: 'Goal Name', 
              hint: 'e.g. New Car, Vacation', 
              controller: _nameController
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Current Amount (Optional)', 
              hint: 'e.g. 1.000.000', 
              keyboardType: TextInputType.number, 
              controller: _currentAmountController,
              inputFormatters: [_CurrencyInputFormatter()],
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Target Amount', 
              hint: 'e.g. 50.000.000', 
              keyboardType: TextInputType.number, 
              controller: _targetAmountController,
              inputFormatters: [_CurrencyInputFormatter()],
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Update Goal',
              isLoading: _isLoading,
              onPressed: _saveGoal,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required String hint, 
    TextInputType keyboardType = TextInputType.text, 
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primaryColor)),
          ),
        ),
      ],
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
