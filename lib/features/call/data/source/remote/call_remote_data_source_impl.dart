import 'package:chat_application/features/app/constants/supabase_table_const.dart';
import 'package:chat_application/features/call/data/models/call_model.dart';
import 'package:chat_application/features/call/data/source/remote/call_remote_data_source.dart';
import 'package:chat_application/features/call/domain/entities/call_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final SupabaseClient supabase;

  CallRemoteDataSourceImpl({required this.supabase});

  @override
  Future<void> makeCall(CallEntity call) async {
    final now = DateTime.now();

    final callerData =
        CallModel(
          callerId: call.callerId,
          callerName: call.callerName,
          callerProfileUrl: call.callerProfileUrl,
          isCallDialed: true,
          isMissed: false,
          receiverId: call.receiverId,
          receiverName: call.receiverName,
          receiverProfileUrl: call.receiverProfileUrl,
          createdAt: now,
        ).toJson();

    final receiverData =
        CallModel(
          callerId: call.receiverId,
          callerName: call.receiverName,
          callerProfileUrl: call.receiverProfileUrl,
          isCallDialed: false,
          isMissed: false,
          receiverId: call.callerId,
          receiverName: call.callerName,
          receiverProfileUrl: call.callerProfileUrl,
          createdAt: now,
        ).toJson();

    await supabase.from(SupabaseTableConst.call).insert([
      callerData,
      receiverData,
    ]);
  }

  @override
  Future<void> endCall(CallEntity call) async {
    await supabase
        .from(SupabaseTableConst.call)
        .delete()
        .eq('caller_id', call.callerId as String);
    await supabase
        .from(SupabaseTableConst.call)
        .delete()
        .eq('caller_id', call.receiverId as String);
  }

  @override
  Future<void> saveCallHistory(CallEntity call) async {
    final now = DateTime.now();
    final data =
        CallModel(
          callerId: call.callerId,
          callerName: call.callerName,
          callerProfileUrl: call.callerProfileUrl,
          callId: call.callId,
          isCallDialed: call.isCallDialed,
          isMissed: call.isMissed,
          receiverId: call.receiverId,
          receiverName: call.receiverName,
          receiverProfileUrl: call.receiverProfileUrl,
          createdAt: now,
        ).toJson();

    await supabase.from(SupabaseTableConst.callHistory).upsert(data);
  }

  @override
  Future<void> updateCallHistoryStatus(CallEntity call) async {
    final updates = <String, dynamic>{};

    if (call.isCallDialed != null) {
      updates['is_call_dialed'] = call.isCallDialed;
    }
    if (call.isMissed != null) updates['is_missed'] = call.isMissed;

    await supabase
        .from(SupabaseTableConst.callHistory)
        .update(updates)
        .eq('call_id', call.callId as String);
  }

  @override
  Future<String> getCallChannelId(String id) async {
    final res =
        await supabase
            .from(SupabaseTableConst.call)
            .select('call_id')
            .eq('caller_id', id)
            .maybeSingle();

    return res != null ? res['call_id'] as String : '';
  }

  @override
  Stream<List<CallEntity>> getMyCallHistory(String id) {
    final stream = supabase
        .from(SupabaseTableConst.callHistory)
        .stream(primaryKey: ['call_id'])
        .eq('caller_id', id)
        .order('created_at', ascending: false);

    return stream.map(
      (data) => data.map((e) => CallModel.fromJson(e)).toList(),
    );
  }

  @override
  Stream<List<CallEntity>> getUserCalling(String id) {
    final stream = supabase
        .from(SupabaseTableConst.call)
        .stream(primaryKey: ['call_id'])
        .eq('caller_id', id)
        .limit(1);

    return stream.map(
      (data) => data.map((e) => CallModel.fromJson(e)).toList(),
    );
  }
}
