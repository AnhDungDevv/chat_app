import 'dart:io';
import 'dart:typed_data';

import 'package:mime/mime.dart';

class FileData {
  final Uint8List data;
  final String? mimeType;

  FileData({required this.data, required this.mimeType});
}

Future<FileData> readBytesAndMime(String path) async {
  final file = File(path);
  final bytes = await file.readAsBytes();
  final mimeType = lookupMimeType(path);
  return FileData(data: Uint8List.fromList(bytes), mimeType: mimeType);
}
