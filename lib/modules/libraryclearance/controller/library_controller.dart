import 'package:flutter/material.dart' hide StepState;
import 'package:get/get.dart';
import '../service/LibraryService.dart';
import '../../../socket_service.dart';
import '../model/library_model.dart';

class LibraryController extends GetxController {
  final _svc = LibraryService();

  final isLoading = false.obs;
  final status = ''.obs;
  final remarks = ''.obs;
  final message = ''.obs;

  LibraryModel? library;

  // Clearance flags (optional usage)
  final facultyCleared = false.obs;
  final libraryCleared = false.obs;
  final labCleared = false.obs;
  final financeCleared = false.obs;
  final examinationCleared = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadStatus();

    // Subscribe to library socket events globally
    SocketService().on('libraryStatusChanged', _handleLibraryStatusChanged);
  }

  // Handler for socket event
  void _handleLibraryStatusChanged(dynamic data) {
    print('Socket event received: $data');
    status.value = data['status'] ?? '';
    remarks.value = data['remarks'] ?? '';
    // Optionally, for full sync, you can call:
    // loadStatus();
  }

  @override
  void onClose() {
    // Unsubscribe from the event to prevent memory leaks
    SocketService().on('libraryStatusChanged', _handleLibraryStatusChanged);
    super.onClose();
  }

  Future<void> loadStatus() async {
    isLoading.value = true;
    final res = await _svc.fetchLibraryStatus();
    if (res['status'] == 'Approved') {
      library = LibraryModel.fromJson(res);
      // You now have .status and .remarks as typed fields!
    }
    status.value = res['status'] ?? '';
    remarks.value = res['remarks'] ?? '';
    isLoading.value = false;
  }

  Future<void> startClearance() async {
    try {
      isLoading.value = true;
      final res = await _svc.startClearance();
      if (res['alreadyExists'] == true) {
        Get.snackbar('Info', res['message'] ?? 'Clearance already started');
        await loadStatus();
        return;
      }
      if (res['data'] != null && res['data']['_id'] != null) {
        Get.snackbar('Success', res['message'] ?? 'Clearance created');
        await loadStatus();
        return;
      }
      final errMsg = res['message'] ?? res['data']?['message'] ?? 'Server did not return expected data';
      Get.snackbar('Error', errMsg);
    } catch (error) {
      Get.snackbar('Network / Server error', error.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
