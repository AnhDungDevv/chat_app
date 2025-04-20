import 'package:chat_application/features/status/data/source/remote/status_remote_data_source.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/repository/status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusRemoteDataSource remoteDataSource;

  StatusRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createStatus(StatusEntity status) async =>
      remoteDataSource.createStatus(status);

  @override
  Future<void> deleteStatus(StatusEntity status) async =>
      remoteDataSource.deleteStatus(status);

  @override
  Stream<List<StatusEntity>> getMyStatus(String userId) =>
      remoteDataSource.getMyStatus(userId);

  @override
  Future<List<StatusEntity>> getMyStatusFuture(String userId) async =>
      remoteDataSource.getMyStatusFuture(userId);

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) =>
      remoteDataSource.getStatuses(status);

  @override
  Future<void> seenStatusUpdate(
    String statusId,
    int imageIndex,
    String userId,
  ) async => remoteDataSource.seenStatusUpdate(statusId, imageIndex, userId);

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async =>
      remoteDataSource.updateOnlyImageStatus(status);

  @override
  Future<void> updateStatus(StatusEntity status) async =>
      remoteDataSource.updateStatus(status);
}
