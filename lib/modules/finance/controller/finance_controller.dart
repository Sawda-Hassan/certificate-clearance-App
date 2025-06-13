import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../service/finance_service.dart';

class FinanceController extends GetxController {
  final FinanceService _svc = FinanceService();

  final isLoading = false.obs;
  final status = ''.obs;
  final unpaidAmount = 0.0.obs;
  final canGraduate = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();

    // ✅ Try to read studentId from GetStorage
    final sid = box.read('studentId');
    if (sid != null && sid.toString().isNotEmpty) {
      print('📦 Found studentId in storage: $sid');
      loadStatus(sid.toString());
    } else {
      print('❌ No studentId found in storage');

      // ✅ OPTIONAL: fallback for manual testing
      const fallbackId = '123456'; // Replace with a test student ID
      print('⚠️ Using fallback studentId: $fallbackId');
      loadStatus(fallbackId);
    }
  }
Future<void> loadStatus(String studentId) async {
  isLoading.value = true;
  try {
    final res = await _svc.fetchFinanceSummary(studentId);

    // ✅ Fix: properly parse string or number
    final rawAmount = res['unpaidAmount'];
    unpaidAmount.value = double.tryParse(rawAmount.toString()) ?? 0.0;

    canGraduate.value = res['canGraduate'] ?? false;

    status.value = unpaidAmount.value <= 0.001 ? 'Cleared' : 'Pending';

    print('✅ Loaded finance status');
    print('   ➤ Student ID: $studentId');
    print('   ➤ Unpaid Amount (parsed): \$${unpaidAmount.value}');
    print('   ➤ Clearance Status: ${status.value}');
  } catch (e) {
    print('❌ Error loading finance status: $e');
  } finally {
    isLoading.value = false;
  }
}
}