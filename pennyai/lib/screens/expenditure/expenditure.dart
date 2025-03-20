import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenditureScreen extends StatefulWidget {
  const ExpenditureScreen({super.key});

  @override
  State<ExpenditureScreen> createState() => _ExpenditureScreenState();
}

class _ExpenditureScreenState extends State<ExpenditureScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '\$45.00');
  final _descriptionController = TextEditingController(text: 'Restaurant dinner');

  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food & Dining';
  String _selectedPaymentMethod = 'Credit Card';

  final List<String> _categories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Utilities',
    'Health',
    'Travel',
    'Education',
    'Others'
  ];

  final List<String> _paymentMethods = [
    'Credit Card',
    'Debit Card',
    'Cash',
    'Bank Transfer',
    'Mobile Payment',
    'Check'
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Add Expense'),
        backgroundColor: const Color(0xFF5E72E4),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormLabel('Amount'),
                _buildAmountField(),
                const SizedBox(height: 20),
                _buildFormLabel('Category'),
                _buildCategoryDropdown(),
                const SizedBox(height: 20),
                _buildFormLabel('Date'),
                _buildDatePicker(),
                const SizedBox(height: 20),
                _buildFormLabel('Description'),
                _buildDescriptionField(),
                const SizedBox(height: 20),
                _buildFormLabel('Payment Method'),
                _buildPaymentMethodDropdown(),
                const SizedBox(height: 20),
                _buildReceiptUpload(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter an amount';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedCategory,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF5E72E4),
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedCategory = newValue;
            });
          }
        },
        items: _categories.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM d, yyyy').format(_selectedDate),
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(
              Icons.calendar_today,
              color: Color(0xFF5E72E4),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5E72E4),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildDescriptionField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: _descriptionController,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedPaymentMethod,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF5E72E4),
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedPaymentMethod = newValue;
            });
          }
        },
        items: _paymentMethods.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReceiptUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add photo of receipt (optional)',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade500,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FE),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.camera_alt,
              color: Colors.grey,
              size: 30,
            ),
            onPressed: () {
              // Camera functionality would go here
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Save expense logic would go here
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E72E4),
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Save Expense',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}