import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        title: Text(context.l10n.addUpcomingBill, style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
      ),
      body: _isInitializing ? const AnalyticsFormSkeleton() : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.billDetails, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildTextField(
              label: context.l10n.description, 
              hint: context.l10n.descriptionHint, 
              controller: _descriptionController
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.date, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate == null 
                              ? context.l10n.selectDate 
                              : DateFormat('dd MMM yyyy').format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 16,
                          ),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextField(
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
