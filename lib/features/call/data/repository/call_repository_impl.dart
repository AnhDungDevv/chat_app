import 'package:chat_application/features/call/data/source/remote/call_remote_data_source.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:chat_application/features/call/domain/repository/call_repository.dart';

class CallRepositoryImpl implements CallRepository {
  final CallRemoteDataSource remoteDataSource;

  CallRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> endCall(CallEntity call) async => remoteDataSource.endCall(call);

  @override
  Future<String> getCallChannelId(String id) async =>
      remoteDataSource.getCallChannelId(id);

  @override
  Stream<List<CallEntity>> getMyCallHistory(String id) =>
      remoteDataSource.getMyCallHistory(id);

  @override
  Stream<List<CallEntity>> getUserCalling(String id) =>
      remoteDataSource.getUserCalling(id);

  @override
  Future<void> makeCall(CallEntity call) async =>
      remoteDataSource.makeCall(call);

  @override
  Future<void> saveCallHistory(CallEntity call) async =>
      remoteDataSource.saveCallHistory(call);

  @override
  Future<void> updateCallHistoryStatus(CallEntity call) async =>
      remoteDataSource.updateCallHistoryStatus(call);
}
