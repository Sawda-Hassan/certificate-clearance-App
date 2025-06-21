import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../service/finance_service.dart';

class FinanceController extends GetxController {
  final FinanceService _svc = FinanceService();

  final isLoading = false.obs;
  final status = ''.obs;
  final unpaidAmount = 0.0.obs;
  final canGraduate = false.obs;

  IO.Socket? socket;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    final sid = box.read('studentId');
    if (sid != null && sid.toString().isNotEmpty) {
      loadStatus(sid.toString());
      connectSocket(sid.toString()); // ✅ connect when you have studentId
    } else {
      print('❌ No studentId in storage');
    }
  }

  void connectSocket(String studentId) {
    socket?.disconnect(); // clean up any old connection
    socket = IO.io('http://10.0.2.2:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket!.onConnect((_) {
      print('[SOCKET] Connected for Finance');
    });

    socket!.on('financeStatusChanged', (data) {
      if (data is Map && data['studentId'] == studentId) {
        print("📥 Received financeStatusChanged for me");
        loadStatus(studentId); // 🔁 reload status
      }
    });

    socket!.onDisconnect((_) => print('[SOCKET] Disconnected from Finance'));
  }

  Future<void> loadStatus(String studentId) async {
    try {
      isLoading.value = true;
      final res = await _svc.fetchFinanceSummary(studentId);
      unpaidAmount.value = double.tryParse(res['unpaidAmount'].toString()) ?? 0.0;
      canGraduate.value = res['canGraduate'] ?? false;
      status.value = unpaidAmount.value <= 0.001 ? 'Cleared' : 'Pending';

      print('✅ Finance status updated: $status, unpaid: ${unpaidAmount.value}');
    } catch (e) {
      print('❌ Failed to load finance summary: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    socket?.disconnect();
    super.onClose();
  }
}
