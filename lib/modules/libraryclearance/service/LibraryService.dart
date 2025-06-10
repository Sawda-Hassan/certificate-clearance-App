import '../../auth/services/api_client.dart';

class LibraryService {
  final ApiClient _api = ApiClient();
Future<Map<String, dynamic>> fetchLibraryStatus() async {
  try {
    final raw = await _api.get('/library/my-group');
    print(' raw response: $raw'); // ADD THIS LINE!
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
    return {
      'status': 'Error',
      'remarks': '',
    };
  }
}



  Future<Map<String, dynamic>> startClearance() async {
    try {
      final result = await _api.post('/library/start-clearance');
      return result;
    } catch (e) {
      return {
        'ok': false,
        'data': {'message': e.toString()}
      };
    }
  }
}
