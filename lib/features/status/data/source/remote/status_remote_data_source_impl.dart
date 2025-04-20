import 'dart:async';

import 'package:chat_application/features/status/data/models/status_model.dart';
import 'package:chat_application/features/status/data/source/remote/status_remote_data_source.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
  final SupabaseClient supabase;

  StatusRemoteDataSourceImpl({required this.supabase});

  @override
  Future<void> createStatus(StatusEntity status) async {
    final newStatus = StatusModel(
      imageUrl: status.imageUrl,
      profileUrl: status.profileUrl,
      userId: status.userId,
      createdAt: DateTime.now(),
      phoneNumber: status.phoneNumber,
      username: status.username,
      caption: status.caption,
      stories: status.stories,
    );

    try {
      await supabase.from('status').insert(newStatus.toJson());
    } catch (e) {
      print("Some error occurred while creating status: $e");
    }
  }

  @override
  Future<void> deleteStatus(StatusEntity status) async {
    try {
      await supabase
          .from('status')
          .delete()
          .eq('status_id', status.statusId as String);
    } catch (e) {
      print("Error deleting status: $e");
    }
  }

  @override
  Stream<List<StatusEntity>> getMyStatus(String userId) {
    final controller = StreamController<List<StatusEntity>>();
    final List<StatusEntity> statuses = [];

    final twentyFourHoursAgo =
        DateTime.now().subtract(Duration(hours: 24)).toIso8601String();

    supabase
        .from('status')
        .select()
        .eq('user_id', userId)
        .gte('created_at', twentyFourHoursAgo)
        .order('created_at', ascending: false)
        .then((response) {
          final initialStatuses =
              (response as List)
                  .map((e) => StatusModel.fromJson(e).toEntity())
                  .toList();

          statuses.addAll(initialStatuses);
          controller.add(List.from(statuses));
        });

    final channel =
        supabase.channel('public:status')
          ..onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'status',
            filter: PostgresChangeFilter(
              column: 'user_id',
              value: userId,
              type: PostgresChangeFilterType.eq,
            ),
            callback: (payload) {
              final newData = payload.newRecord;

              final createdAt = DateTime.parse(newData['created_at']);
              final isRecent = createdAt.isAfter(
                DateTime.now().subtract(const Duration(hours: 24)),
              );
              if (!isRecent) return;

              final newStatus = StatusModel.fromJson(newData).toEntity();
              final index = statuses.indexWhere(
                (s) => s.statusId == newStatus.statusId,
              );

              if (index != -1) {
                statuses[index] = newStatus;
              } else {
                statuses.add(newStatus);
              }

              statuses.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              controller.add(List.from(statuses));
            },
          )
          ..subscribe();

    controller.onCancel = () {
      supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  @override
  Future<List<StatusEntity>> getMyStatusFuture(String userId) async {
    final twentyFourHoursAgo = DateTime.now().subtract(Duration(hours: 24));

    final response = await supabase
        .from('status')
        .select()
        .eq('user_id', userId)
        .gte('created_at', twentyFourHoursAgo.toIso8601String());

    return (response as List)
        .map((e) => StatusModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity status) {
    final controller = StreamController<List<StatusEntity>>();
    final List<StatusEntity> statuses = [];

    final twentyFourHoursAgo =
        DateTime.now().subtract(Duration(hours: 24)).toIso8601String();

    supabase
        .from('status')
        .select()
        .gte('created_at', twentyFourHoursAgo)
        .order('created_at', ascending: false)
        .then((response) {
          final initialStatuses =
              (response as List)
                  .map((e) => StatusModel.fromJson(e).toEntity())
                  .toList();

          statuses.addAll(initialStatuses);
          controller.add(List.from(statuses));
        });

    final channel =
        supabase.channel('public:status')
          ..onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'status',
            callback: (payload) {
              final newData = payload.newRecord;

              final createdAt = DateTime.parse(newData['created_at']);
              final isRecent = createdAt.isAfter(
                DateTime.now().subtract(const Duration(hours: 24)),
              );
              if (!isRecent) return;

              final newStatus = StatusModel.fromJson(newData).toEntity();
              final index = statuses.indexWhere(
                (s) => s.statusId == newStatus.statusId,
              );

              if (index != -1) {
                statuses[index] = newStatus;
              } else {
                statuses.add(newStatus);
              }

              statuses.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
              controller.add(List.from(statuses));
            },
          )
          ..subscribe();

    controller.onCancel = () {
      supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  @override
  Future<void> seenStatusUpdate(
    String statusId,
    int imageIndex,
    String userId,
  ) async {
    try {
      final response =
          await supabase
              .from('status')
              .select()
              .eq('status_id', statusId)
              .single();

      final List<dynamic> stories = response['stories'];
      final viewers = List<String>.from(stories[imageIndex]['viewers'] ?? []);

      if (!viewers.contains(userId)) {
        viewers.add(userId);
        stories[imageIndex]['viewers'] = viewers;

        await supabase
            .from('status')
            .update({'stories': stories})
            .eq('status_id', statusId);
      }
    } catch (e) {
      print("Error updating viewers: $e");
    }
  }

  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async {
    try {
      final response =
          await supabase
              .from('status')
              .select()
              .eq('status_id', status.statusId as String)
              .single();

      final createdAt = DateTime.parse(response['created_at']);
      final stories = List<Map<String, dynamic>>.from(response['stories']);
      final newStories = status.stories!.map((e) => e.toJson()).toList();

      if (createdAt.isAfter(DateTime.now().subtract(Duration(hours: 24)))) {
        stories.addAll(newStories);

        await supabase
            .from('status')
            .update({'stories': stories, 'image_url': stories.first['url']})
            .eq('status_id', status.statusId as String);
      }
    } catch (e) {
      print("Error updating only image status: $e");
    }
  }

  @override
  Future<void> updateStatus(StatusEntity status) async {
    Map<String, dynamic> updates = {};

    if (status.imageUrl?.isNotEmpty ?? false) {
      updates['image_url'] = status.imageUrl;
    }

    if (status.stories != null) {
      updates['stories'] = status.stories!.map((e) => e.toJson()).toList();
    }

    try {
      await supabase
          .from('status')
          .update(updates)
          .eq('status_id', status.statusId as String);
    } catch (e) {
      print("Error updating status: $e");
    }
  }
}
