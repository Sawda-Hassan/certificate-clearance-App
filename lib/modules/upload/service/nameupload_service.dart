import 'package:http/http.dart' as http;
import '../model/nameupload_model.dart';

class NameUploadService {
  final String baseUrl = 'http://10.0.2.2:5000'; // or your local IP if real device

  Future<bool> upload(NameUploadModel model) async {
    final uri = Uri.parse('$baseUrl/api/students/upload-correction-doc');
    final request = http.MultipartRequest('POST', uri);

    print('📤 Preparing upload request...');
    print('🧾 studentId: ${model.studentId}');
    print('📝 requestedName: ${model.requestedName}');
    print('📎 documentName: ${model.documentName}');
    print('📦 fileBytes length: ${model.fileBytes.length}');

    request.fields['studentId'] = model.studentId;
    request.fields['requestedName'] = model.requestedName;

    request.files.add(
      http.MultipartFile.fromBytes(
        'document',
        model.fileBytes,
        filename: model.documentName,
      ),
    );

    try {
      final response = await request.send();
      print('📬 Server responded with status: ${response.statusCode}');

      // Read body if status failed
      if (response.statusCode != 200) {
        final responseBody = await response.stream.bytesToString();
        print('❌ Server error body: $responseBody');
      }

      return response.statusCode == 200;
    } catch (e) {
      print('❌ Upload exception: $e');
      return false;
    }
  }
}
