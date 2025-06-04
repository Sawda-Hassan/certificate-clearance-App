import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ClearanceProgress.dart'; // Make sure the path is correct

class GroupService {
  Future<GroupClearance?> fetchGroupClearance(String groupId) async {
    final url = Uri.parse('http://your-server-ip:port/api/groups/$groupId'); // replace with real IP & port
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Full group response: $data');

      try {
        return GroupClearance.fromJson(data); // Pass entire object
      } catch (e) {
        print('❌ Error parsing GroupClearance: $e');
        return null;
      }
    } else {
      print('❌ Failed to fetch group: ${response.statusCode}');
      return null;
    }
  }
}
