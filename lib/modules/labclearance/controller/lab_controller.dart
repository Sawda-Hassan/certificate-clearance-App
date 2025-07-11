import 'package:get/get.dart';
import '../service/LabService.dart';
import '../../../socket_service.dart';
import '../model/lab_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LabController extends GetxController {
  final _svc = LabService();

  final isLoading = false.obs;
  final status = ''.obs;
  final issues = ''.obs;
  final expectedItems = <String>[].obs;
  final returnedItems = <String>[].obs;

  LabModel? lab;
  IO.Socket? socket;
  String? groupId;

  @override
  void onInit() {
    super.onInit();
    loadStatus();

    // Legacy listener (if using SocketService)
    SocketService().on('labStatusChanged', _handleLabStatusChanged);
  }

  void connectSocket(String groupIdParam) {
    groupId = groupIdParam;
    socket?.disconnect();

    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    // Optionally join group room
    // socket!.emit('joinGroup', groupId);

    socket!.on('labStatusChanged', (data) {
      if (data is Map && data['groupId'] == groupId) {
        status.value = data['status'] ?? '';
        issues.value = data['issues'] ?? '';
        expectedItems.value = List<String>.from(data['expectedItems'] ?? []);
        returnedItems.value = List<String>.from(data['returnedItems'] ?? []);
        //print('[SOCKET][labStatusChanged] Updated status: ${status.value}');
      }
    });
  }

  void _handleLabStatusChanged(dynamic data) {
   // print('[SOCKET] Received labStatusChanged: $data');
    status.value = data['status'] ?? '';
    issues.value = data['issues'] ?? '';
  }

  @override
  void onClose() {
    socket?.disconnect();
    SocketService().off('labStatusChanged', _handleLabStatusChanged);
    super.onClose();
  }

  Future<void> loadStatus() async {
    isLoading.value = true;
    //print('[API] Loading lab status...');
    final res = await _svc.fetchLabStatus();
    //print('[API] Received: $res');
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
