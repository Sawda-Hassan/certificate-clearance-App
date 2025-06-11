import 'package:get/get.dart';
import '../service/LabService.dart';
import '../../../socket_service.dart';
import '../model/lab_model.dart';

class LabController extends GetxController {
  final _svc = LabService();

  final isLoading = false.obs;
  final status = ''.obs;
  final issues = ''.obs;
  final expectedItems = <String>[].obs;
  final returnedItems = <String>[].obs;

  LabModel? lab;

  @override
  void onInit() {
    super.onInit();
    loadStatus();

    SocketService().on('labStatusChanged', _handleLabStatusChanged);
  }

  void _handleLabStatusChanged(dynamic data) {
    print('[SOCKET] Received labStatusChanged: $data');
    status.value = data['status'] ?? '';
    issues.value = data['issues'] ?? '';
    // Optionally update expected/returnedItems if included in socket data
  }

  @override
  void onClose() {
    SocketService().off('labStatusChanged', _handleLabStatusChanged);
    super.onClose();
  }

  Future<void> loadStatus() async {
    isLoading.value = true;
    print('[API] Loading lab status...');
    final res = await _svc.fetchLabStatus();
    print('[API] Received: $res');
    if (res['status'] == 'Approved' || res['status'] == 'Pending' || res['status'] == 'Rejected') {
      lab = LabModel.fromJson(res);
      expectedItems.value = lab?.expectedItems ?? [];
      returnedItems.value = lab?.returnedItems ?? [];
    }
    status.value = res['status'] ?? '';
    issues.value = res['issues'] ?? '';
    isLoading.value = false;
  }
}
