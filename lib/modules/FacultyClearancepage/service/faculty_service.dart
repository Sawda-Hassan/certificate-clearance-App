// lib/FacultyClearancepage/service/faculty_service.dart
// -----------------------------------------------------
import '../../auth/services/api_client.dart';
import '../model/faculty_models.dart';

class FacultyService {
  final _api = ApiClient();

  /* 1️⃣ First group member calls this */
  Future<Map<String, dynamic>> startClearance() async =>
      _api.post('/faculty/start-clearance');

  /* 2️⃣ Everyone calls this to read the timeline */
  Future<List<ClearanceStep>> fetchStudentSteps() async {
    Map<String, dynamic> doc = {};

    /* Try the preferred endpoint first */
    try {
      final dynamic resMy = await _api.get('/faculty/my-group');

      if (resMy is Map<String, dynamic>) {
        doc = resMy;
      } else if (resMy is List &&
          resMy.isNotEmpty &&
          resMy.first is Map<String, dynamic>) {
        // Some back-ends wrap the single record in a list
        doc = Map<String, dynamic>.from(resMy.first);
      }
    } catch (_) {
      /* Network / 404 — fall back to the shared “approved” endpoint */
    }

    /* If still empty, hit /faculty/approved (could be List OR Map) */
    if (doc.isEmpty) {
      final dynamic res = await _api.get('/faculty/approved');

      if (res is List && res.isNotEmpty && res.first is Map<String, dynamic>) {
        doc = Map<String, dynamic>.from(res.first);
      } else if (res is Map<String, dynamic>) {
        doc = res;
      }
    }

    /* Build UI list */
    return _mapDocToSteps(doc);
  }

  /* Convert one backend document → timeline list */
  List<ClearanceStep> _mapDocToSteps(Map<String, dynamic> doc) {
    if (doc.isEmpty) return [];

    StepState _toState(dynamic flag, String? overall) {
      if (overall == 'Rejected') return StepState.rejected;
      return flag == true ? StepState.approved : StepState.pending;
    }

    return [
      ClearanceStep('Printed & soft copy submitted',
          _toState(doc['printedThesisSubmitted'], doc['status'])),
      ClearanceStep('Signed submission form',
          _toState(doc['signedFormSubmitted'], doc['status'])),
      ClearanceStep('Soft-copy uploaded',
          _toState(doc['softCopyReceived'], doc['status'])),
      ClearanceStep('Panel comments corrected',
          _toState(doc['supervisorCommentsWereCorrected'], doc['status'])),
    ];
  }

  /* Give controller access to the mapper (used on 400 response) */
  List<ClearanceStep> mapDocToSteps(Map<String, dynamic> doc) =>
      _mapDocToSteps(doc);
}
