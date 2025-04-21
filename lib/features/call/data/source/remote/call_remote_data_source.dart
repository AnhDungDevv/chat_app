import 'package:chat_application/features/call/domain/entities/call_entity.dart';

abstract class CallRemoteDataSource {
  Future<void> makeCall(CallEntity call);
  Future<void> endCall(CallEntity call);
  Future<void> updateCallHistoryStatus(CallEntity call);

  Future<void> saveCallHistory(CallEntity call);
  Stream<List<CallEntity>> getUserCalling(String id);
  Stream<List<CallEntity>> getMyCallHistory(String id);
  Future<String> getCallChannelId(String id);
}
