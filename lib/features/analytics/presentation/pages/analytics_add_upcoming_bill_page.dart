import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../app/config/l10n.dart';
import '../widgets/analytics_form_skeleton.dart';

class AnalyticsAddUpcomingBillPage extends StatefulWidget {
  const AnalyticsAddUpcomingBillPage({super.key});

  @override
  State<AnalyticsAddUpcomingBillPage> createState() => _AnalyticsAddUpcomingBillPageState();
}

class _AnalyticsAddUpcomingBillPageState extends State<AnalyticsAddUpcomingBillPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  DateTime? _selectedDate;
  bool _isLoading = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();

    // Simulate initial loading to show skeleton
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    });
  }

  void _saveBill() async {
    if (_descriptionController.text.trim().isEmpty || _priceController.text.trim().isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.pleaseFillRequiredFields)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call for adding
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      CustomDialog.showSuccess(
        context,
        title: context.l10n.success,
        message: context.l10n.billAddedSuccess,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
          context.l10n.addUpcomingBill,
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
                    context.l10n.billDetails,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    context: context,
                    label: context.l10n.description,
                    hint: context.l10n.descriptionHint,
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: 20),
                  // Date Picker formatted with the same floating label design
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: context.l10n.date,
                        labelStyle: TextStyle(
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          fontSize: 14,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        fillColor: isDark ? AppColors.darkSurface : Colors.white,
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
                        suffixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                          size: 20,
                        ),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? context.l10n.selectDate
                            : DateFormat('dd MMM yyyy').format(_selectedDate!),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _selectedDate == null ? FontWeight.normal : FontWeight.w600,
                          color: _selectedDate == null
                              ? (isDark ? Colors.grey.shade500 : Colors.grey.shade400)
                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    context: context,
                    label: context.l10n.price,
                    hint: context.l10n.priceHint,
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    inputFormatters: [_CurrencyInputFormatter()],
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: context.l10n.saveBill,
                    isLoading: _isLoading,
                    onPressed: _saveBill,
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
