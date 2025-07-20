import 'package:get/get.dart';
import '../model/group_clearance_model.dart';
import '../service/group_clearance_service.dart';

class GroupClearanceController extends GetxController {
  final GroupClearanceService _service = GroupClearanceService();

  var isLoading = true.obs;
  var clearanceStatus = Rxn<GroupClearanceStatus>();

  Future<void> loadClearanceStatus(String studentId) async {
    try {
      isLoading.value = true;
      final status = await _service.getClearanceStatus(studentId);
      clearanceStatus.value = status;
    } finally {
      isLoading.value = false;
    }
  }
}
