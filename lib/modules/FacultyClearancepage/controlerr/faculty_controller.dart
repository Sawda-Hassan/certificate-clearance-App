import 'package:get/get.dart';
import '../service/faculty_service.dart';
import '../model/faculty_models.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../socket_service.dart';

class FacultyController extends GetxController {
  final _svc = FacultyService();

  final isLoading = false.obs;
  final status = ''.obs;
  final rejectionReason = ''.obs;
  final steps = <ClearanceStep>[].obs;
  final message = ''.obs;

  String? groupId;

  @override
  void onInit() {
    super.onInit();

    final auth = Get.find<AuthController>();
    groupId = auth.loggedInStudent.value?.groupId;

    print('📥 Student groupId: $groupId');

    if (groupId != null) {
      SocketService().waitUntilConnectedAndListen(
        'facultyStatusChanged',
        _handleFacultyStatusChanged,
      );
    } else {
      print('❌ groupId is null — cannot listen for facultyStatusChanged');
    }

    loadStatus(); // Load current faculty status from backend
  }

  @override
  void onClose() {
    SocketService().off('facultyStatusChanged', _handleFacultyStatusChanged);
    super.onClose();
  }

  void _handleFacultyStatusChanged(dynamic data) {
    print('📡 facultyStatusChanged received: $data');

    if (data is Map) {
      final remoteGroupId = data['groupId']?.toString();
      print('🔍 Remote groupId from socket: $remoteGroupId');

      if (remoteGroupId == groupId) {
        print('✅ Matched groupId! Updating UI...');
        status.value = data['status'] ?? '';
        rejectionReason.value = data['rejectionReason'] ?? '';
        steps.assignAll(buildSteps(status.value));
      } else {
        print('❌ Ignored: groupId mismatch');
      }
    } else {
      print('❌ Invalid socket payload — not a Map');
    }
  }

  List<ClearanceStep> buildSteps(String stat) {
    return [
      ClearanceStep(
        'Faculty',
        (stat == 'Approved')
            ? StepState.approved
            : (stat == 'Rejected' || stat == 'Incomplete')
                ? StepState.rejected
                : StepState.pending,
      ),
      ClearanceStep('Library', StepState.pending),
      ClearanceStep('Lab', StepState.pending),
      ClearanceStep('Finance', StepState.pending),
      ClearanceStep('Examination', StepState.pending),
    ];
  }

  int get approvedCount => steps.where((s) => s.state == StepState.approved).length;
  double get percent => steps.isEmpty ? 0 : approvedCount / steps.length;
  bool get allApproved => percent == 1.0;

  Future<void> loadStatus() async {
    try {
      isLoading.value = true;
      final result = await _svc.fetchFacultyStatus();

      print('📊 Fetched status: ${result['status']}, reason: ${result['rejectionReason']}');

      status.value = result['status'] ?? '';
      rejectionReason.value = result['rejectionReason'] ?? '';
      steps.assignAll(buildSteps(status.value));

      message.value = status.value.isEmpty || status.value == 'NotStarted'
          ? 'No faculty clearance started yet'
          : status.value == 'Error'
              ? 'Failed to fetch faculty clearance status'
              : '';
    } catch (e) {
      print('❌ Error loading status: $e');
      status.value = '';
      rejectionReason.value = '';
      message.value = 'Failed to fetch status';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startClearance() async {
    try {
      isLoading.value = true;
      await _svc.startClearance();
      await loadStatus();
    } catch (e) {
      print('❌ Error starting clearance: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getMyGroupFaculty() async {
    try {
      final result = await _svc.getMyGroupFaculty();
      print('📘 getMyGroupFaculty result: $result');
      return result;
    } catch (e) {
      print('❌ Error in getMyGroupFaculty controller: $e');
      return {'ok': false, 'message': 'Unable to fetch faculty group'};
    }
  }
}
