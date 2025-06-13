import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../services/evs_plus_services.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var paymentStatus = ''.obs;
  var errorMessage = ''.obs;
  var isPaymentSuccessful = false.obs;

  Future<void> pay({
    required String phone,
    required double amount,
    required String merchantUid,
    required String apiUserId,
    required String apiKey,
    String description = 'Test',
    String invoiceId = '000',
    String referenceId = '00',
    String currency = 'USD',
  }) async {
    try {
      isLoading.value = true;
      paymentStatus.value = '';
      errorMessage.value = '';
      isPaymentSuccessful.value = false;
      final result = await EvsPlusServices().payByWaafiPay(
          phone: phone,
          amount: amount,
          merchantUid: merchantUid,
          apiUserId: apiUserId,
          apiKey: apiKey);
      if (result['status']) {
        paymentStatus.value = result['message'];
        isPaymentSuccessful.value = true;
        print(result['message']);
      } else {
        errorMessage.value = result['error'];
        isPaymentSuccessful.value = false;
        print(result['message']);
        print(result['error']);
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
      isPaymentSuccessful.value = false;
    } finally {
      isLoading.value = false;
    }
  }

 
}
