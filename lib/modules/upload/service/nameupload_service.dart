import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../model/nameupload_model.dart';

class NameUploadService {
  final String baseUrl = 'http://10.0.2.2:5000'; // ✅ Replace this

  Future<bool> upload(NameUploadModel model) async {
    final uri = Uri.parse('$baseUrl/api/students/upload-correction-doc');
    final request = http.MultipartRequest('POST', uri);

    request.fields['studentId'] = model.studentId;
    request.fields['requestedName'] = model.requestedName;

    request.files.add(
      http.MultipartFile.fromBytes(
        'document',
        model.fileBytes,
        filename: model.documentName,
      ),
    );

    final response = await request.send();
    return response.statusCode == 200;
  }
}
