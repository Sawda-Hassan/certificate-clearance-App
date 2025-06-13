import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_controller.dart';

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Paymentscreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final PaymentController _paymentController = Get.put(PaymentController());

  void _handlePayment() {
    final amountText = _amountController.text.trim();
    final phoneText = _phoneController.text.trim();

    if (phoneText.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter phone and amount')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid amount')),
      );
      return;
    }

    _paymentController.pay(
      phone: phoneText,
      amount: amount,
      merchantUid: 'M0910291',
      apiUserId: '1000416',
      apiKey: 'API-675418888AHX',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EVC_PLUS Payment Test'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Enter details to pay with EVC_PLUS',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // Phone input
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),

              // Amount input
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 30),

              // Pay button or loader
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _paymentController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handlePayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Pay',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // Success message
              if (_paymentController.paymentStatus.isNotEmpty)
              
                Text(
                  _paymentController.paymentStatus.value,
                  style: const TextStyle(color: Colors.green),
                ),

              // Error message
              if (_paymentController.errorMessage.isNotEmpty)
                Text(
                  _paymentController.errorMessage.value,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 40),
              const Text(
                'This is a test screen for EVC_PLUS payments.\n with real transactions are processed.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          );
        }),
      ),
    );
  }
}
