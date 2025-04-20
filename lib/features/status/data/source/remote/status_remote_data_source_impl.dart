import 'dart:async';
import 'dart:developer';

import 'package:chat_application/features/status/data/models/status_model.dart';
import 'package:chat_application/features/status/data/source/remote/status_remote_data_source.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
  final SupabaseClient supabase;

  StatusRemoteDataSourceImpl({required this.supabase});

  /// Create a new status and its stories
  @override
  Future<void> createStatus(StatusEntity status) async {
    try {
      final newStatus = StatusModel(
        imageUrl: status.imageUrl,
        profileUrl: status.profileUrl,
        userId: status.userId,
        createdAt: DateTime.now(),
        phoneNumber: status.phoneNumber,
        username: status.username,
        caption: status.caption,
      );

      final response =
          await supabase
              .from('status')
              .insert(newStatus.toJson())
              .select()
              .single();

      final insertedStatusId = response['status_id'] as String;

      if (status.stories?.isNotEmpty == true) {
        final storiesJson =
            status.stories!
                .map(
                  (story) => {...story.toJson(), 'status_id': insertedStatusId},
                )
                .toList();

        await supabase.from('status_image').insert(storiesJson);
      }
    } catch (e, stack) {
      log("Error creating status", error: e, stackTrace: stack);
    }
  }

  /// Delete status and associated stories
  @override
  Future<void> deleteStatus(StatusEntity status) async {
    try {
      await supabase
          .from('status_image')
          .delete()
          .eq('status_id', status.statusId as String);

      await supabase
          .from('status')
          .delete()
          .eq('status_id', status.statusId as String);
    } catch (e, stack) {
      log("Error deleting status", error: e, stackTrace: stack);
    }
  }

  /// Stream user's own status (real-time)
  @override
  Stream<List<StatusEntity>> getMyStatus(String userId) {
    final controller = StreamController<List<StatusEntity>>();
    final statuses = <StatusEntity>[];

    final twentyFourHoursAgo = DateTime.now().subtract(Duration(hours: 24));

    Future<void> _loadInitial() async {
      try {
        final response = await supabase
            .from('status')
            .select('*, status_image(*)')
            .eq('user_id', userId)
            .gte('created_at', twentyFourHoursAgo.toIso8601String())
            .order('created_at', ascending: false);

        log("res ---- $response");
        final data =
            (response as List).map((statusMap) {
              final images =
                  (statusMap['status_image'] as List<dynamic>? ?? [])
                      .map((e) => StatusImageEntity.fromJson(e))
                      .toList();

              return StatusModel.fromJson({
                ...statusMap,
                'stories': images.map((e) => e.toJson()).toList(),
              }).toEntity();
            }).toList();
        log("data-----$data");
        statuses.addAll(data);
        controller.add(List.from(statuses));
      } catch (e, stack) {
        log("Error loading initial status", error: e, stackTrace: stack);
      }
    }

    controller.add([]);
    _loadInitial();

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
            callback: (payload) async {
              final newData = payload.newRecord;
              final createdAt = DateTime.tryParse(newData['created_at'] ?? '');
              if (createdAt == null || createdAt.isBefore(twentyFourHoursAgo))
                return;

              final response =
                  await supabase
                      .from('status')
                      .select('*, status_image(*)')
                      .eq('status_id', newData['status_id'])
                      .single();

              final images =
                  (response['status_image'] as List<dynamic>? ?? [])
                      .map((e) => StatusImageEntity.fromJson(e))
                      .toList();

              final status =
                  StatusModel.fromJson({
                    ...response,
                    'stories': images.map((e) => e.toJson()).toList(),
                  }).toEntity();

              final index = statuses.indexWhere(
                (s) => s.statusId == status.statusId,
              );
              if (index != -1) {
                statuses[index] = status;
              } else {
                statuses.add(status);
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
    try {
      final response = await supabase
          .from('status')
          .select('*, status_image(*)')
          .eq('user_id', userId)
          .gte(
            'created_at',
            DateTime.now()
                .subtract(const Duration(hours: 24))
                .toIso8601String(),
          )
          .order('created_at', ascending: false);

      final data =
          (response as List).map((statusMap) {
            final images =
                (statusMap['status_image'] as List<dynamic>? ?? [])
                    .map((e) => StatusImageEntity.fromJson(e))
                    .toList();

            return StatusModel.fromJson({
              ...statusMap,
              'stories': images.map((e) => e.toJson()).toList(),
            }).toEntity();
          }).toList();

      return data;
    } catch (e, stack) {
      log("Error getting status future", error: e, stackTrace: stack);
      return [];
    }
  }

  /// Get all statuses (including my own), with status images
  @override
  Stream<List<StatusEntity>> getStatuses(StatusEntity currentUserStatus) {
    final controller = StreamController<List<StatusEntity>>();
    final statuses = <StatusEntity>[];

    final limitTime = DateTime.now().subtract(Duration(hours: 24));

    Future<void> _loadInitial() async {
      try {
        final response = await supabase
            .from('status')
            .select('*, status_image(*)')
            .gte('created_at', limitTime.toIso8601String())
            .order('created_at', ascending: false);

        final data =
            (response as List).map((statusMap) {
              final images =
                  (statusMap['status_image'] as List<dynamic>? ?? [])
                      .map((e) => StatusImageEntity.fromJson(e))
                      .toList();

              return StatusModel.fromJson({
                ...statusMap,
                'stories': images.map((e) => e.toJson()).toList(),
              }).toEntity();
            }).toList();

        statuses.clear();
        statuses.addAll(data);
        controller.add(List.from(statuses));
      } catch (e, stack) {
        log("Error loading initial statuses", error: e, stackTrace: stack);
      }
    }

    void addOrUpdateStatus(StatusEntity status) {
      final index = statuses.indexWhere((s) => s.statusId == status.statusId);
      if (index != -1) {
        statuses[index] = status;
      } else {
        statuses.add(status);
      }
      statuses.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      controller.add(List.from(statuses));
    }

    controller.add([]);
    _loadInitial();

    final channel =
        supabase.channel('public:status')
          ..onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'status',
            callback: (payload) async {
              final newData = payload.newRecord;
              final createdAt = DateTime.tryParse(newData['created_at'] ?? '');

              if (createdAt == null || createdAt.isBefore(limitTime)) return;

              try {
                final response =
                    await supabase
                        .from('status')
                        .select('*, status_image(*)')
                        .eq('status_id', newData['status_id'])
                        .maybeSingle();

                if (response != null) {
                  final images =
                      (response['status_image'] as List<dynamic>? ?? [])
                          .map((e) => StatusImageEntity.fromJson(e))
                          .toList();

                  final status =
                      StatusModel.fromJson({
                        ...response,
                        'stories': images.map((e) => e.toJson()).toList(),
                      }).toEntity();

                  addOrUpdateStatus(status);
                }
              } catch (e, stack) {
                log(
                  "Error handling real-time update",
                  error: e,
                  stackTrace: stack,
                );
              }
            },
          )
          ..subscribe();

    controller.onCancel = () {
      supabase.removeChannel(channel);
    };

    return controller.stream;
  }

  /// Update viewers of a story
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

      final stories = List<Map<String, dynamic>>.from(response['stories']);
      final viewers = List<String>.from(stories[imageIndex]['viewers'] ?? []);

      if (!viewers.contains(userId)) {
        viewers.add(userId);
        stories[imageIndex]['viewers'] = viewers;

        await supabase
            .from('status')
            .update({'stories': stories})
            .eq('status_id', statusId);
      }
    } catch (e, stack) {
      log("Error updating viewers", error: e, stackTrace: stack);
    }
  }

  /// Update only image status (repost or update)
  @override
  Future<void> updateOnlyImageStatus(StatusEntity status) async {
    try {
      final existing =
          await supabase
              .from('status')
              .select()
              .eq('status_id', status.statusId as String)
              .single();

      if (existing != null) {
        final createdAt = DateTime.parse(existing['created_at']);
        final isRecent = createdAt.isAfter(
          DateTime.now().subtract(Duration(hours: 24)),
        );

        if (isRecent) {
          final newStories = status.stories ?? [];
          final storiesJson =
              newStories.map((e) {
                final json = e.toJson();
                json['status_id'] = status.statusId;
                return json;
              }).toList();

          if (storiesJson.isNotEmpty) {
            await supabase.from('status_image').insert(storiesJson);
            await supabase
                .from('status')
                .update({'image_url': newStories.first.url})
                .eq('status_id', status.statusId as String);
          }
        } else {
          // Create new status
          final newStatus = StatusModel(
            userId: status.userId,
            profileUrl: status.profileUrl,
            imageUrl: status.stories!.first.url,
            createdAt: DateTime.now(),
            phoneNumber: status.phoneNumber,
            username: status.username,
            caption: status.caption,
          );

          final inserted =
              await supabase
                  .from('status')
                  .insert(newStatus.toJson())
                  .select()
                  .single();

          final newStatusId = inserted['status_id'] as String;
          final storiesJson =
              status.stories!.map((e) {
                final json = e.toJson();
                json['status_id'] = newStatusId;
                return json;
              }).toList();

          await supabase.from('status_image').insert(storiesJson);
        }
      }
    } catch (e, stack) {
      log("Error updating only image status", error: e, stackTrace: stack);
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
      log("Error updating status: $e");
    }
  }
}
