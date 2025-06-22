import 'package:get/get.dart';
import '../model/clearanceletter_model.dart';
import '../service/clearanceletter_service.dart';

class ClearanceLetterController extends GetxController {
  final _clearanceData = Rxn<ClearanceLetterModel>();
  final isLoading = false.obs;

  ClearanceLetterModel? get clearanceData => _clearanceData.value;

  @override
  void onInit() {
    super.onInit();
    fetchClearanceLetterData();
  }

  Future<void> fetchClearanceLetterData() async {
    isLoading.value = true;
    try {
      // Replace with the actual logged-in student ID
      const String studentId = 'C121315';

      final data = await ClearanceLetterService.fetchClearanceLetter(studentId);
      _clearanceData.value = data;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch clearance letter data");
    } finally {
      isLoading.value = false;
    }
  }
}
