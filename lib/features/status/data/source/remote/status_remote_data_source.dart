

import 'package:chat_application/features/status/domain/entities/status_enity.dart';

abstract class StatusRemoteDataSource {

  Future<void> createStatus(StatusEntity status);
  Future<void> updateStatus(StatusEntity status);
  Future<void> updateOnlyImageStatus(StatusEntity status);
  Future<void> seenStatusUpdate(String statusId, int imageIndex, String userId);
  Future<void> deleteStatus(StatusEntity status);
  Stream<List<StatusEntity>> getStatuses(StatusEntity status);
  Stream<List<StatusEntity>> getMyStatus(String userId);
  Future<List<StatusEntity>> getMyStatusFuture(String userId);
}