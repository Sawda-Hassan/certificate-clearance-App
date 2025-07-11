// 📁 lib/controller/payment_controller.dart
import 'package:get/get.dart';
import '../services/evs_plus_services.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var paymentStatus = ''.obs;
  var errorMessage = ''.obs;
  var isPaymentSuccessful = false.obs;
Future<void> pay({
  required String studentId,
  required String phone,
  required double amount,
}) async {
  try {
    isLoading.value = true;
    errorMessage.value = '';
    paymentStatus.value = '';
    isPaymentSuccessful.value = false;

    final result = await EvsPlusServices().payByWaafiPay(
      studentId: studentId,
      phone: phone,
      amount: amount,
    );

    final msg = result['message'] ?? '';
    final detail = result['detail'];
    final code = detail?['responseMsg'] ?? '';
    final description = detail?['params']?['description'] ?? '';

    // ✅ Case 1: Success
    if (msg.toString().contains('✅')) {
      paymentStatus.value = msg;
      isPaymentSuccessful.value = true;
    } 
    // ✅ Case 2: User Rejected
    else if (code == 'RCS_USER_REJECTED' || description.toLowerCase().contains('rejected')) {
      errorMessage.value = 'You cancelled the payment.';
    } 
    // ✅ Case 3: Invalid or other known issues
    else if (description.toLowerCase().contains('invalid')) {
      errorMessage.value = 'Invalid phone number. Please check and try again.';
    } 
    // ✅ Case 4: All other unknowns
    else {
      errorMessage.value = 'Payment failed. Please try again.';
    }
  } catch (e) {
    //print('❌ Payment exception: $e');
    errorMessage.value = 'Payment failed. Please try again.';
  } finally {
    isLoading.value = false;
  }
}
}