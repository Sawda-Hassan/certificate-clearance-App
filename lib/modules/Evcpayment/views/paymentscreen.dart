import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart'; // ✅ Make sure this is correct

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final PaymentController _paymentController = Get.put(PaymentController());
  final AuthController _authController = Get.find<AuthController>();

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "Payment Successful 🎉",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "You have successfully paid the payment.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Get.offAllNamed(AppRoutes.financeClearance); // Navigate to finance status
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text("Back to Finance Status"),
            )
          ],
        ),
      ),
    );
  }

  void _handlePayment() async {
    if (!_formKey.currentState!.validate()) return;

    String phoneText = _phoneController.text.trim();
    final amountText = _amountController.text.trim();
    final studentId = _authController.studentId;

    if (phoneText.startsWith('61') && phoneText.length == 9) {
      phoneText = '252$phoneText';
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) return;

    try {
      await _paymentController.pay(
        studentId: studentId,
        phone: phoneText,
        amount: amount,
      );

      if (_paymentController.isPaymentSuccessful.value) {
        _phoneController.clear();
        _amountController.clear();
        showSuccessDialog();
      }
    } catch (e) {
      _paymentController.errorMessage.value = "Payment failed. Please try again.";
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF002B5B);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkBlue),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() => Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/evcplus_logo.png',
                    height: 130,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Make EVC pluss payment',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: darkBlue,
                    ),
                  ),
                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Enter EVC Plus Number:",
                        style: TextStyle(color: darkBlue)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Phone number is required';
                      }
                      final cleaned = value.trim();
                      if (!(cleaned.startsWith('61') && cleaned.length == 9) &&
                          !(cleaned.startsWith('25261') && cleaned.length == 12)) {
                        return 'Phone must start with 61 or 25261 and be valid';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "e.g. 618XXXXXX or 252618XXXXXX",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Enter Amount (USD):",
                        style: TextStyle(color: darkBlue)),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Amount is required';
                      }
                      final parsed = double.tryParse(value);
                      if (parsed == null || parsed <= 0) {
                        return 'Enter a valid amount greater than 0';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "e.g. 3.00",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  _paymentController.isLoading.value
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _handlePayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text("PAY",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),

                  const SizedBox(height: 20),

                  if (_paymentController.errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _paymentController.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}
