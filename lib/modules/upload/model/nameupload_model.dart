import 'dart:typed_data';

class NameUploadModel {
  final String studentId;
  final String requestedName;
  final String documentName;
  final Uint8List fileBytes;

  NameUploadModel({
    required this.studentId,
    required this.requestedName,
    required this.documentName,
    required this.fileBytes,
  });
}
