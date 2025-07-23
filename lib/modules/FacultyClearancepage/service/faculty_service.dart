import '../../auth/services/api_client.dart';

class FacultyService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> fetchFacultyStatus() async {
    try {
      final raw = await _api.get('/faculty/my-group');
      final data = raw['data'];
      if (data != null && data['ok'] == true) {
        return {
          'status': data['status'],
          'rejectionReason': data['rejectionReason'] ?? '',
        };
      } else {
        return {'status': 'NotStarted', 'rejectionReason': ''};
      }
    } catch (_) {
      return {'status': 'Error', 'rejectionReason': ''};
    }
  }

  Future<Map<String, dynamic>> startClearance() async {
    try {
      final result = await _api.post('/faculty/start-clearance');
      return result;
    } catch (e) {
      return {'ok': false, 'data': {'message': e.toString()}};
    }
  }

  // ✅ New: Fetch full faculty group info
  Future<Map<String, dynamic>> getMyGroupFaculty() async {
    try {
      final raw = await _api.get('/faculty/my-group');
      return raw['data'] ?? {'ok': false, 'message': 'No response data'};
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }
}
