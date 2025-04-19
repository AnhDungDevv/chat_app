import 'dart:io';
import 'package:chat_application/features/app/helpers/file_uploader.dart';
import 'package:flutter/foundation.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageProviderRemoteDataSource {
  static final SupabaseClient _client = Supabase.instance.client;

  static String get _uid => _client.auth.currentUser?.id ?? 'unknown';

  static Future<String> uploadProfileImage({
    required File file,
    Function(bool isUploading)? onComplete,
  }) async {
    onComplete?.call(true);
    final fileName =
        "$_uid/profile_${DateTime.now().millisecondsSinceEpoch}.png";
    final fileBytes = await file.readAsBytes();

    await _client.storage
        .from('chat-files')
        .uploadBinary(
          fileName,
          fileBytes,
          fileOptions: FileOptions(
            contentType: lookupMimeType(file.path),
            upsert: true,
          ),
        );

    final publicUrl = _client.storage.from('chat-files').getPublicUrl(fileName);
    onComplete?.call(false);
    return publicUrl;
  }

  static Future<String> uploadStatus({
    required File file,
    Function(bool isUploading)? onComplete,
  }) async {
    onComplete?.call(true);

    final fileName =
        "$_uid/status_${DateTime.now().millisecondsSinceEpoch}.png";
    final fileBytes = await file.readAsBytes();

    await _client.storage
        .from('chat-files')
        .uploadBinary(
          fileName,
          fileBytes,
          fileOptions: FileOptions(
            contentType: lookupMimeType(file.path),
            upsert: true,
          ),
        );

    final publicUrl = _client.storage.from('chat-files').getPublicUrl(fileName);
    onComplete?.call(false);
    return publicUrl;
  }

  static Future<List<String>> uploadStatuses({
    required List<File> files,
    Function(bool isUploading)? onComplete,
  }) async {
    onComplete?.call(true);
    List<String> imageUrls = [];

    for (var i = 0; i < files.length; i++) {
      final fileName =
          "$_uid/status_${DateTime.now().millisecondsSinceEpoch}_$i.png";
      final fileBytes = await files[i].readAsBytes();

      await _client.storage
          .from('chat-files')
          .uploadBinary(
            fileName,
            fileBytes,
            fileOptions: FileOptions(
              contentType: lookupMimeType(files[i].path),
              upsert: true,
            ),
          );

      final publicUrl = _client.storage
          .from('chat-files')
          .getPublicUrl(fileName);
      imageUrls.add(publicUrl);
    }

    onComplete?.call(false);
    return imageUrls;
  }

  static Future<String> uploadMessageFile({
    required File file,
    Function(bool isUploading)? onComplete,
    String? otherUid,
    String? type,
  }) async {
    onComplete?.call(true);

    final fileName =
        "$_uid/messages/$type/${otherUid ?? 'unknown'}/${DateTime.now().millisecondsSinceEpoch}.png";
    final bytes = await compute(readBytesAndMime, file.path);
    await _client.storage
        .from('chat-files')
        .uploadBinary(
          fileName,
          bytes.data,
          fileOptions: FileOptions(contentType: bytes.mimeType, upsert: true),
        );

    final publicUrl = _client.storage.from('chat-files').getPublicUrl(fileName);
    onComplete?.call(false);
    return publicUrl;
  }
}
