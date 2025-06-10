import 'package:get/get.dart';
import '../service/faculty_service.dart';
import '../model/faculty_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FacultyController extends GetxController {
  final _svc = FacultyService();

  final isLoading = false.obs;
  final status = ''.obs;
  final rejectionReason = ''.obs;
  final steps = <ClearanceStep>[].obs;
  final message = ''.obs;

  // Socket.IO instance
  IO.Socket? socket;
  String? groupId; // <-- set this when known (e.g., from login/group state)

  // Always use 5 steps (one for each department)
  List<ClearanceStep> buildSteps(String stat) {
    if (stat == 'Approved') {
      return [
        ClearanceStep('Faculty', StepState.approved),
        ClearanceStep('Library', StepState.pending),
        ClearanceStep('Lab', StepState.pending),
        ClearanceStep('Finance', StepState.pending),
        ClearanceStep('Examination', StepState.pending),
      ];
    } else if (stat == 'Rejected') {
      return [
        ClearanceStep('Faculty', StepState.rejected),
        ClearanceStep('Library', StepState.pending),
        ClearanceStep('Lab', StepState.pending),
        ClearanceStep('Finance', StepState.pending),
        ClearanceStep('Examination', StepState.pending),
      ];
    } else if (stat == 'Pending') {
      return [
        ClearanceStep('Faculty', StepState.pending),
        ClearanceStep('Library', StepState.pending),
        ClearanceStep('Lab', StepState.pending),
        ClearanceStep('Finance', StepState.pending),
        ClearanceStep('Examination', StepState.pending),
      ];
    } else {
      return [];
    }
  }

  int get approvedCount => steps.where((s) => s.state == StepState.approved).length;

  double get percent {
    if (steps.isEmpty) return 0;
    final approved = approvedCount;
    return approved / steps.length;
  }

  bool get allApproved => steps.isNotEmpty && percent == 1.0;

  @override
  void onInit() {
    super.onInit();
    loadStatus();
    // If you have groupId ready on start, call connectSocket(groupId);
    // Otherwise, call connectSocket when you know groupId (from login/session)
  }

  // --- REAL-TIME SOCKET.IO SUPPORT ---
  void connectSocket(String groupIdParam) {
    groupId = groupIdParam;
    socket?.disconnect(); // cleanup any existing
    socket = IO.io('http://localhost:5000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();

    // (Optional) If backend supports rooms, join your group room
    // socket!.emit('joinGroup', groupId);

    socket!.on('facultyStatusChanged', (data) {
      if (data is Map && data['groupId'] == groupId) {
        // Only update if for this group
        status.value = data['status'] ?? '';
        rejectionReason.value = data['rejectionReason'] ?? '';
        steps.assignAll(buildSteps(status.value));
      }
    });
  }

  @override
  void onClose() {
    socket?.disconnect();
    super.onClose();
  }

  /// Loads the real faculty clearance status and rejection reason
  Future<void> loadStatus() async {
    try {
      isLoading.value = true;
      final result = await _svc.fetchFacultyStatus();
      // The backend must return a Map: {'status': ..., 'rejectionReason': ...}
      status.value = result['status'] ?? '';
      rejectionReason.value = result['rejectionReason'] ?? '';
      steps.assignAll(buildSteps(status.value));
      if (status.value.isEmpty || status.value == 'NotStarted') {
        message.value = 'No faculty clearance started yet';
      } else if (status.value == 'Error') {
        message.value = 'Failed to fetch faculty clearance status';
      } else {
        message.value = '';
      }
    } catch (e) {
      status.value = '';
      message.value = 'Failed to fetch status';
      rejectionReason.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  /// Starts faculty clearance for the group
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

  // The rest can be used for department-based UI as needed
  final facultyCleared = false.obs;
  final libraryCleared = false.obs;
  final labCleared = false.obs;
  final financeCleared = false.obs;
  final examinationCleared = false.obs;
}
