import '../../auth/services/api_client.dart';

class LibraryService {
  final ApiClient _api = ApiClient();

  Future<Map<String, dynamic>> fetchLibraryStatus() async {
    try {
      print('[SERVICE] Calling /library/my-group ...');
      final raw = await _api.get('/library/my-group');
      print('[SERVICE] API raw response: $raw');
      final data = raw['data'];
      if (data != null && data['ok'] == true) {
        return {
          'status': data['status'],
          'remarks': data['remarks'] ?? '',
        };
      } else {
        return {
          'status': 'NotStarted',
          'remarks': '',
        };
      }
    } catch (e) {
      print('[SERVICE] Error: $e');
      return {
        'status': 'Error',
        'remarks': '',
      };
    }
  }
}
