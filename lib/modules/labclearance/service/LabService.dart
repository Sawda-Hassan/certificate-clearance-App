import '../../auth/services/api_client.dart';

class LabService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> fetchLabStatus() async {
    try {
      print('[SERVICE] Calling /lab/my-group ...');
      final raw = await _api.get('/lab/my-group');
      print('[SERVICE] API raw response: $raw');
      final data = raw['data'];
      if (data != null) {
        return data;
      } else {
        return {
          'status': 'NotStarted',
          'issues': '',
          'expectedItems': [],
          'returnedItems': [],
        };
      }
    } catch (e) {
      print('[SERVICE] Error: $e');
      return {
        'status': 'Error',
        'issues': '',
        'expectedItems': [],
        'returnedItems': [],
      };
    }
  }
}
