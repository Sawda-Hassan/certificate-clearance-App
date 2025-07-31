import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class Paymentscreen extends StatefulWidget {
  const Paymentscreen({super.key});

  @override
  State<Paymentscreen> createState() => _PaymentscreenState();
}

class _PaymentscreenState extends State<Paymentscreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _phoneController = TextEditingController();
  final _paymentController = Get.put(PaymentController());
  final _authController = Get.find<AuthController>();

  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text(
              "Thank you for your payment. You can now proceed.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 25),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Back to Finance"),
              onPressed: () {
                Navigator.of(context).pop();
                Get.offAllNamed(AppRoutes.financeClearance);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
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

      /// ✅ FIX: Defer dialog so it doesn't run during Obx render
      Future.microtask(() {
        showSuccessDialog();
      });
    }
  } catch (_) {
    _paymentController.errorMessage.value =
        "Payment failed. Please check your network or credentials.";
  }
}

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF0A2647);
    const fieldColor = Color(0xFFF4F6F8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: primaryColor),
        centerTitle: true,
        title: const Text(
          "EVC Plus Payment",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Obx(
          () => Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('assets/images/evcplus_logo.png', height: 130),
                const SizedBox(height: 20),

                // Phone Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Phone Number", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
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
                      return 'Must be 61xxxxxxx or 25261xxxxxxx';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "61XXXXXXX or 25261XXXXXXX",
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.phone),
                  ),
                ),

                const SizedBox(height: 20),

                // Amount Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Amount (USD)", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500)),
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
                      return 'Enter amount greater than 0';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "e.g. 5.00",
                    filled: true,
                    fillColor: fieldColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),

                const SizedBox(height: 30),

                // Pay Button
                _paymentController.isLoading.value
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _handlePayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text("Pay Now",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ),

                // Error Text
                if (_paymentController.errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _paymentController.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
