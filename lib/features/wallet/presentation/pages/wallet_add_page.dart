import 'package:flutter/material.dart';
import '../../../../shared/widgets/widgets.dart';

import '../widgets/wallet_add_skeleton.dart';

class WalletAddPage extends StatefulWidget {
  const WalletAddPage({super.key});

  @override
  State<WalletAddPage> createState() => _WalletAddPageState();
}

class _WalletAddPageState extends State<WalletAddPage> {
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

  void _saveWallet() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      CustomDialog.showSuccess(
        context,
        title: 'Success',
        message: 'Wallet has been added successfully',
        onConfirm: () {
          Navigator.pop(context);
        },
      );
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
        title: Text('Add Wallet', style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold)),
      ),
      body: _isInitializing
          ? const WalletAddSkeleton()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Wallet Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildTextField(label: 'Wallet Name', hint: 'e.g. Main Bank Account'),
            const SizedBox(height: 20),
            _buildDropdown(
              label: 'Wallet Type', 
              items: ['Bank Account', 'E-Wallet', 'Cash', 'Credit Card', 'Investment'],
              onChanged: (val) {
                setState(() {
                  _selectedType = val;
                });
              }
            ),
            const SizedBox(height: 20),
            
            if (_selectedType == 'Credit Card' || _selectedType == 'Bank Account') ...[
              if (_selectedType == 'Bank Account') ...[
                _buildTextField(label: 'Account Number', hint: 'e.g. 1234567890', keyboardType: TextInputType.number),
                const SizedBox(height: 20),
              ],
              _buildTextField(label: 'Card Number', hint: '0000 0000 0000 0000', keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _buildTextField(label: 'Valid Thru', hint: 'MM/YY', keyboardType: TextInputType.datetime)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField(label: 'CVV', hint: '123', keyboardType: TextInputType.number, obscureText: true)),
                ],
              ),
            ] else ...[
              _buildTextField(label: 'Account Number', hint: 'e.g. 1234567890', keyboardType: TextInputType.number),
            ],

            const SizedBox(height: 40),
            CustomButton(
              text: 'Save Wallet',
              isLoading: _isLoading,
              onPressed: _saveWallet,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, TextInputType keyboardType = TextInputType.text, bool obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({required String label, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedType,
          decoration: InputDecoration(
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.blue)),
          ),
          hint: const Text('Select Type', style: TextStyle(color: Colors.grey)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
