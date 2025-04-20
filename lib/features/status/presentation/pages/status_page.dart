import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_story_view/flutter_story_view.dart';
import 'package:flutter_story_view/models/story_item.dart';
import 'package:path/path.dart' as path;
import 'dart:developer';

import 'package:chat_application/features/app/constants/page_const.dart';
import 'package:chat_application/features/app/global/date/date_format.dart';
import 'package:chat_application/features/app/global/widgets/prodile_widget.dart';
import 'package:chat_application/features/app/global/widgets/show_image_and_video_widget.dart';
import 'package:chat_application/features/app/home/home_page.dart';
import 'package:chat_application/features/app/storage/storage_provider.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/status/domain/entities/status_enity.dart';
import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';
import 'package:chat_application/features/status/domain/usecases/get_my_status_future_usecase.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/get_my_status/get_my_status_state.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:chat_application/features/status/presentation/cubit/status/status_state.dart';
import 'package:chat_application/features/status/presentation/widgets/status_dotted_borders_widget.dart';
import 'package:chat_application/features/user/domain/entities/user_entity.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_cubit.dart';
import 'package:chat_application/features/user/presentation/cubit/get_single/get_single_user_state.dart';
import 'package:chat_application/main_injection.dart' as dependence;

class StatusPage extends StatefulWidget {
  final String userId;
  const StatusPage({super.key, required this.userId});

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  List<StatusImageEntity> _stories = [];
  List<StoryItem> myStories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = widget.userId;

      context.read<StatusCubit>().getStatuses(status: StatusEntity());
      context.read<GetSingleUserCubit>().getSingleUser(userId: userId);
      context.read<GetMyStatusCubit>().getMyStatus(userId: userId);

      dependence.sl<GetMyStatusFutureUseCase>()(userId).then((value) {
        if (value.isNotEmpty && value.first.stories != null) {
          log("value.... $value");
          _fillterMyStories(value.first);
        }
      });
    });
  }

  bool _isFilePickerActive = false;

  Future<void> selecteMedia() async {
    if (_isFilePickerActive) {
      log("File picker is already active.");
      return;
    }

    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      _isFilePickerActive = true;

      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      _isFilePickerActive = false;

      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }
        setState(() {});
        log("mediaTypes = $_mediaTypes");
      } else {
        log("No file is selected.");
      }
    } catch (e) {
      log("Error while picking file: $e");
    }
  }

  Future<void> _fillterMyStories(StatusEntity status) async {
    if (status.stories != null) {
      _stories = status.stories!;
      for (StatusImageEntity story in status.stories!) {
        myStories.add(
          StoryItem(
            url: story.url!,
            viewers: story.viewers,
            type: StoryItemTypeExtension.fromString(story.type!),
          ),
        );
      }
    }
  }

  void _eitherShowOrUploadSheet(
    StatusEntity? myStatus,
    UserEntity currentUser,
  ) {
    if (myStatus != null) {
      _showStatusImageViewBottomModalSheet(
        stories: myStories,
        status: myStatus,
      );
    } else {
      selecteMedia().then((value) {
        if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
            builder: (context) {
              return ShowMultiImageAndVideoPickedWidget(
                selectedFiles: _selectedMedia!,
                onTap: () {
                  _uploadImageStatus(currentUser);
                  Navigator.pop(context);
                },
              );
            },
          );
        }
      });
    }
  }

  Future _showStatusImageViewBottomModalSheet({
    StatusEntity? status,
    required List<StoryItem> stories,
  }) async {
    log("stories ---- $stories");
    if (stories.isEmpty) {
      log("Không có stories để hiển thị");
      return;
    }
    showModalBottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      context: context,
      builder: (context) {
        return FlutterStoryView(
          createdAt: status!.createdAt!,
          onComplete: () {
            Navigator.pop(context);
          },
          caption: "This is very beatiful photo",
          onPageChanged: (index) {
            BlocProvider.of<StatusCubit>(context).seenStatusUpdate(
              statusId: status.statusId!,
              imageIndex: index,
              userId: widget.userId,
            );
          },
          storyItems: stories,
          enableOnHoldHide: false,
        );
      },
    );
  }

  _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
      files: _selectedMedia!,
      onComplete: (isComplete) {},
    ).then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        _stories.add(
          StatusImageEntity(
            url: statusImageUrls[i],
            type: _mediaTypes![i],
            viewers: const [],
          ),
        );
      }
      dependence.sl<GetMyStatusFutureUseCase>()(widget.userId).then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                status: StatusEntity(
                  statusId: myStatus.first.statusId,
                  stories: _stories,
                ),
              )
              .then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(uid: widget.userId!, index: 1),
                  ),
                );
              });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
                status: StatusEntity(
                  caption: "",
                  createdAt: DateTime.now(),
                  stories: _stories,
                  userId: currentUser.userId,
                  username: currentUser.username,
                  profileUrl: currentUser.profileUrl,
                  imageUrl: statusImageUrls[0],
                  phoneNumber: currentUser.phoneNumber,
                ),
              )
              .then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return HomePage(uid: widget.userId, index: 1);
                    },
                  ),
                );
              });
        }
      });
      ;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if (state is GetSingleUserLoaded) {
          final currentUser = state.singleUser;

          return BlocBuilder<StatusCubit, StatusState>(
            builder: (context, state) {
              if (state is StatusLoaded) {
                final statuses = state.statuses;
                log("status --- init $statuses");
                if (_stories.isEmpty) {
                  return _buildBodyWidget(statuses, currentUser);
                } else {
                  return BlocBuilder<GetMyStatusCubit, GetMyStatusState>(
                    builder: (context, state) {
                      if (state is GetMyStatusLoaded) {
                        log("my status ${state.myStatus}");
                        return _buildBodyWidget(
                          statuses,
                          currentUser,
                          myStatus: state.myStatus,
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: tabColor),
                      );
                    },
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(color: tabColor),
              );
            },
          );
        }

        return const Center(child: CircularProgressIndicator(color: tabColor));
      },
    );
  }

  _buildBodyWidget(
    List<StatusEntity> statuses,
    UserEntity currentUser, {
    StatusEntity? myStatus,
  }) {
    log("status up----$statuses");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    myStatus != null
                        ? GestureDetector(
                          onTap: () {
                            _eitherShowOrUploadSheet(myStatus, currentUser);
                          },
                          child: Container(
                            width: 55,
                            height: 55,
                            margin: const EdgeInsets.all(12.5),
                            child: CustomPaint(
                              painter: StatusDottedBordersWidget(
                                isMe: true,
                                numberOfStories: myStatus.stories!.length,
                                spaceLength: 4,
                                images: myStatus.stories!,
                                userId: currentUser.userId,
                              ),
                              child: Container(
                                margin: const EdgeInsets.all(3),
                                width: 55,
                                height: 55,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: profileWidget(
                                    imageUrl: myStatus.imageUrl,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          width: 60,
                          height: 60,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: profileWidget(
                              imageUrl: currentUser.profileUrl,
                            ),
                          ),
                        ),
                    myStatus != null
                        ? Container()
                        : Positioned(
                          right: 10,
                          bottom: 8,
                          child: GestureDetector(
                            onTap: () {
                              _eitherShowOrUploadSheet(myStatus, currentUser);
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: tabColor,
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  width: 2,
                                  color: backgroundColor,
                                ),
                              ),
                              child: const Center(
                                child: Icon(Icons.add, size: 20),
                              ),
                            ),
                          ),
                        ),
                  ],
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("My Status", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 2),
                      GestureDetector(
                        onTap: () {
                          _eitherShowOrUploadSheet(myStatus, currentUser);
                        },
                        child: Text(
                          "tab to add your status widget",
                          style: TextStyle(color: greyColor),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.myStatusPage);
                  },
                  child: Icon(
                    Icons.more_horiz,
                    color: greyColor.withAlpha((255 * 0.5).toInt()),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Text(
              "Recents update",
              style: TextStyle(
                fontSize: 13,
                color: greyColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListView.builder(
              itemCount: statuses.length,

              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (context, index) {
                log("status down----$statuses");

                final status = statuses[index];

                List<StoryItem> stories = [];

                for (StatusImageEntity storyItem in status.stories!) {
                  stories.add(
                    StoryItem(
                      url: storyItem.url!,
                      viewers: storyItem.viewers,
                      type: StoryItemTypeExtension.fromString(storyItem.type!),
                    ),
                  );
                }
                return ListTile(
                  onTap: () {
                    _showStatusImageViewBottomModalSheet(
                      status: status,
                      stories: stories,
                    );
                  },
                  leading: CustomPaint(
                    painter: StatusDottedBordersWidget(
                      numberOfStories: status.stories!.length,
                      isMe: false,
                      images: status.stories,
                      spaceLength: 4,
                      userId: widget.userId,
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      height: 55,
                      width: 55,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: profileWidget(imageUrl: status.imageUrl),
                      ),
                    ),
                  ),
                  title: Text(
                    "${status.username}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  subtitle: Text(formatDateTime(status.createdAt!)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
