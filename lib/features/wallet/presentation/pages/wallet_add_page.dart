import 'package:flutter/material.dart';
import '../../../../app/config/l10n.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/widgets.dart';

import '../widgets/wallet_add_skeleton.dart';

class WalletAddPage extends StatefulWidget {
  const WalletAddPage({super.key});

  @override
  State<WalletAddPage> createState() => _WalletAddPageState();
}

class _WalletAddPageState extends State<WalletAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _validThruController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String? _selectedType;
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

  @override
  void dispose() {
    _nameController.dispose();
    _accountNumberController.dispose();
    _cardNumberController.dispose();
    _validThruController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _saveWallet() async {
    if (_nameController.text.trim().isEmpty || _selectedType == null) {
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
        message: context.l10n.walletAddedSuccess,
        onConfirm: () {
          Navigator.pop(context);
        },
      );
    }
  }

  String _getTypeDisplayName(String type) {
    switch (type) {
      case 'Bank Account':
        return context.l10n.bankAccount;
      case 'E-Wallet':
        return context.l10n.eWallet;
      case 'Cash':
        return context.l10n.cash;
      case 'Credit Card':
        return context.l10n.creditCard;
      case 'Investment':
        return context.l10n.investment;
      default:
        return type;
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
          context.l10n.addWallet,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _isInitializing
          ? const WalletAddSkeleton()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.walletInformation,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: context.l10n.walletName,
                    hint: context.l10n.walletNameHint,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdown(
                    label: context.l10n.walletType,
                    items: const [
                      'Bank Account',
                      'E-Wallet',
                      'Cash',
                      'Credit Card',
                      'Investment',
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedType = val;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  if (_selectedType == 'Credit Card' || _selectedType == 'Bank Account') ...[
                    if (_selectedType == 'Bank Account') ...[
                      _buildTextField(
                        label: context.l10n.accountNumber,
                        hint: 'e.g. 1234567890',
                        keyboardType: TextInputType.number,
                        controller: _accountNumberController,
                      ),
                      const SizedBox(height: 20),
                    ],
                    _buildTextField(
                      label: context.l10n.cardNumber,
                      hint: '0000 0000 0000 0000',
                      keyboardType: TextInputType.number,
                      controller: _cardNumberController,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            label: context.l10n.validThru,
                            hint: 'MM/YY',
                            keyboardType: TextInputType.datetime,
                            controller: _validThruController,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            label: context.l10n.cvv,
                            hint: '123',
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            controller: _cvvController,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    _buildTextField(
                      label: context.l10n.accountNumber,
                      hint: 'e.g. 1234567890',
                      keyboardType: TextInputType.number,
                      controller: _accountNumberController,
                    ),
                  ],
                  const SizedBox(height: 40),
                  CustomButton(
                    text: context.l10n.saveWallet,
                    isLoading: _isLoading,
                    onPressed: _saveWallet,
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
    bool obscureText = false,
    TextEditingController? controller,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
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

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DropdownButtonFormField<String>(
      initialValue: _selectedType,
      dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
      ),
      decoration: InputDecoration(
        labelText: label,
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
      ),
      hint: Text(
        context.l10n.selectType,
        style: TextStyle(
          color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                _getTypeDisplayName(e),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
