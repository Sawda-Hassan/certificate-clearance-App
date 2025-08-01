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

  /// Build the 5 clearance steps UI based on faculty status
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

    loadStatus();
  }

  @override
  void onClose() {
    SocketService().off('facultyStatusChanged', _handleFacultyStatusChanged as void Function(dynamic));
    super.onClose();
  }

  void _handleFacultyStatusChanged(dynamic data) {
    print('📡 facultyStatusChanged received: $data');

    if (data is Map && data['groupId'] == groupId) {
      print('✅ Matched groupId: Updating UI');
      status.value = data['status'] ?? '';
      rejectionReason.value = data['rejectionReason'] ?? '';
      steps.assignAll(buildSteps(status.value));
    } else {
      print('❌ Ignored: groupId mismatch or invalid payload');
    }
  }

  /// Loads faculty status and updates observable values
  Future<void> loadStatus() async {
    try {
      isLoading.value = true;
      print('📨 Fetching faculty status...');
      final result = await _svc.fetchFacultyStatus();

      status.value = result['status'] ?? '';
      rejectionReason.value = result['rejectionReason'] ?? '';
      steps.assignAll(buildSteps(status.value));

      message.value = status.value.isEmpty || status.value == 'NotStarted'
          ? 'No faculty clearance started yet'
          : status.value == 'Error'
              ? 'Failed to fetch faculty clearance status'
              : '';
              
      print('📊 Fetched status: ${status.value}, reason: ${rejectionReason.value}');
    } catch (e) {
      print('❌ Error loading faculty status: $e');
      status.value = '';
      rejectionReason.value = '';
      message.value = 'Failed to fetch faculty status';
    } finally {
      isLoading.value = false;
      print('✅ Faculty status load complete');
    }
  }

  /// Safely starts the faculty clearance process
  Future<void> startClearance() async {
    try {
      isLoading.value = true;
      print('🚀 Starting faculty clearance...');

      await _svc.startClearance(); // e.g., POST /faculty/start
      print('✅ Faculty clearance triggered. Now reloading status...');

      await loadStatus();
    } catch (e) {
      print('❌ Error during startClearance(): $e');
    } finally {
      isLoading.value = false;
      print('✅ startClearance done');
    }
  }

  /// Used for loading full group-level faculty record (if needed)
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
