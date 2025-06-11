import 'package:get/get.dart';
import '../service/LibraryService.dart';
import '../../../socket_service.dart';
import '../model/library_model.dart';

class LibraryController extends GetxController {
  final _svc = LibraryService();

  final isLoading = false.obs;
  final status = ''.obs;
  final remarks = ''.obs;

  LibraryModel? library;

  @override
  void onInit() {
    super.onInit();
    loadStatus();

    SocketService().on('libraryStatusChanged', _handleLibraryStatusChanged);
  }

  void _handleLibraryStatusChanged(dynamic data) {
    print('[SOCKET] Received libraryStatusChanged: $data');
    status.value = data['status'] ?? '';
    remarks.value = data['remarks'] ?? '';
  }

  @override
  void onClose() {
    SocketService().off('libraryStatusChanged', _handleLibraryStatusChanged);
    super.onClose();
  }

  Future<void> loadStatus() async {
    isLoading.value = true;
    print('[API] Loading library status...');
    final res = await _svc.fetchLibraryStatus();
    print('[API] Received: $res');
    if (res['status'] == 'Approved') {
      library = LibraryModel.fromJson(res);
    }
    status.value = res['status'] ?? '';
    remarks.value = res['remarks'] ?? '';
    isLoading.value = false;
  }
}
