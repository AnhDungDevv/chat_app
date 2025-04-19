import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:chat_application/features/app/constants/app_assets.dart';
import 'package:chat_application/features/app/constants/app_const.dart';
import 'package:chat_application/features/app/constants/message_type_const.dart';
import 'package:chat_application/features/app/global/widgets/dialog_widget.dart';
import 'package:chat_application/features/app/global/widgets/show_image_picked_widget.dart';
import 'package:chat_application/features/app/global/widgets/show_video_picked_widget.dart';
import 'package:chat_application/features/app/storage/storage_provider.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:chat_application/features/chat/domain/entities/message_reply_entity.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_cubit.dart';
import 'package:chat_application/features/chat/presentation/cubit/message/message_state.dart';
import 'package:chat_application/features/chat/presentation/widgets/chat_utils.dart';
import 'package:chat_application/features/chat/presentation/widgets/message_bubble.dart';
import 'package:chat_application/features/chat/presentation/widgets/message_replay_preview_widget.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;
  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final _scrollEmojiController = ScrollController();

  MessageLoaded? lastLoadedState;

  bool _isDisplaySendButton = false;
  bool _isShowAttachWindown = false;
  bool _isRecording = false;
  bool _isRecordInit = false;
  FlutterSoundRecorder? _soundRecorder;

  File? _image;
  File? _video;
  bool isShowEmojiKeyboard = false;
  FocusNode focusNode = FocusNode();
  void _hideEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void _showEmojiContainer() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void _showKeyboard() => focusNode.requestFocus();
  void _hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      setState(() {
        _showKeyboard();
        _hideEmojiContainer();
      });
    } else {
      _hideKeyboard();
      _showEmojiContainer();
    }
  }

  Future selectedImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });
    } catch (e) {
      toast("some error occured $e");
    }
  }

  Future<void> selectVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _video = File(pickedFile.path);
        } else {
          print("No video has been selected");
        }
      });
    } catch (e) {
      toast("Some error occurred while selecting video: $e");
    }
  }

  @override
  void initState() {
    _soundRecorder = FlutterSoundRecorder();
    _openAudioRecording();
    context.read<MessageCubit>().getMessages(
      message: MessageEntity(
        senderId: widget.message.senderId,
        recipientId: widget.message.recipientId,
      ),
    );
    super.initState();
  }

  Future<void> _openAudioRecording() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException("Mic permisson not allowed");
    }
    await _soundRecorder!.openRecorder();
    _isRecordInit = true;
  }

  Future<void> _scrollToBottom({bool animated = true}) async {
    if (!_scrollController.hasClients) return;

    await Future.delayed(const Duration(milliseconds: 100));

    final position = _scrollController.position.maxScrollExtent;

    if (animated) {
      await _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(position);
    }
  }

  void onMessageSwipe({
    String? message,
    String? username,
    String? type,
    bool? isMe,
  }) {
    BlocProvider.of<MessageCubit>(
      context,
    ).setMessageReplay = MessageReplayEntity(
      message: message,
      username: username,
      messageType: type,
      isMe: isMe,
    );
  }

  @override
  void dispose() {
    _textMessageController.dispose();
    _scrollController.dispose();
    _soundRecorder?.closeRecorder();
    _soundRecorder = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    final provider = BlocProvider.of<MessageCubit>(context);

    final isReplying = provider.messageReplay.message != null;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text("${widget.message.recipientName}"),
            Text(
              "Online",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam_rounded, size: 25),
          SizedBox(width: 25),
          Icon(Icons.call, size: 25),
          SizedBox(width: 25),
          Icon(Icons.more_vert, size: 25),
          SizedBox(width: 15),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          setState(() {
            _isShowAttachWindown = false;
          });
        },
        child: Stack(
          children: [
            Positioned.fill(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: Image.asset(AppAssets.backgroundApp, fit: BoxFit.cover),
            ),
            Column(
              children: [
                Expanded(
                  child: BlocConsumer<MessageCubit, MessageState>(
                    listener: (context, state) {
                      if (state is MessageLoaded) {
                        lastLoadedState = state;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _scrollToBottom();
                        });
                      }
                    },
                    builder: (context, state) {
                      final messages =
                          (state is MessageLoaded)
                              ? state.messages
                              : lastLoadedState?.messages ?? [];
                      return ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          if (message.senderId == widget.message.senderId) {
                            return MessageBubble(
                              key: Key(message.messageId!),
                              message: "${message.message}",
                              messageType: message.messageType!,
                              alignment: Alignment.centerRight,
                              createAt: message.createdAt!,
                              isSeen: false,
                              isShowTick: true,
                              messageBgColor: tabColor,
                              reply: MessageReplayEntity(
                                message: message.repliedMessage,
                                messageType: message.repliedMessageType,
                                username: message.repliedTo,
                              ),
                              onLongPress: () {
                                focusNode.unfocus();
                                displayAlertDialog(
                                  context,
                                  onTap: () {
                                    BlocProvider.of<MessageCubit>(
                                      context,
                                    ).deleteMessage(
                                      message: MessageEntity(
                                        senderId: message.senderId,
                                        recipientId: message.recipientName,
                                        messageId: message.messageId,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },

                                  confirmTitle: "Delete",
                                  content:
                                      "Are you sure you want to delete this meesage",
                                );
                              },
                              onSwipe: (details) {
                                onMessageSwipe(
                                  message: message.message,
                                  username: message.senderName,
                                  type: message.messageType,
                                  isMe: true,
                                );
                                setState(() {});
                              },
                            );
                          } else {
                            return MessageBubble(
                              key: Key(message.messageId!),
                              message: "${message.message}",
                              messageType: message.messageType!,
                              alignment: Alignment.centerLeft,
                              createAt: message.createdAt!,
                              isSeen: false,
                              isShowTick: true,
                              reply: MessageReplayEntity(
                                message: message.repliedMessage,
                                messageType: message.repliedMessageType,
                                username: message.recipientName,
                              ),
                              messageBgColor: senderMessageColor,
                              onLongPress: () {
                                focusNode.unfocus();
                                displayAlertDialog(
                                  context,
                                  onTap: () {
                                    BlocProvider.of<MessageCubit>(
                                      context,
                                    ).deleteMessage(
                                      message: MessageEntity(
                                        senderId: message.senderId,
                                        recipientId: message.recipientId,
                                        messageId: message.messageId,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  confirmTitle: "Delete",
                                  content:
                                      "Are you sure you want to delete this meesage",
                                );
                              },
                              onSwipe: (details) {
                                onMessageSwipe(
                                  message: message.message,
                                  username: message.senderName,
                                  type: message.messageType,
                                  isMe: false,
                                );
                                setState(() {});
                              },
                            );
                          }
                        },
                      );
                    },
                  ),
                ),

                isReplying == true
                    ? const SizedBox(height: 5)
                    : const SizedBox(height: 0),

                isReplying == true
                    ? Row(
                      children: [
                        Expanded(
                          child: MessageReplayPreviewWidget(
                            onCancelReplayListener: () {
                              provider.setMessageReplay = MessageReplayEntity();
                              // setState(() {});
                            },
                          ),
                        ),
                        Container(width: 60),
                      ],
                    )
                    : Container(),

                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: isReplying == true ? 0 : 5,
                    bottom: 5,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius:
                                isReplying == true
                                    ? const BorderRadius.only(
                                      bottomLeft: Radius.circular(25),
                                      bottomRight: Radius.circular(24),
                                    )
                                    : BorderRadius.circular(25),
                          ),
                          child: TextField(
                            focusNode: focusNode,
                            onTap: () {
                              setState(() {
                                _isShowAttachWindown = false;
                                isShowEmojiKeyboard = false;
                              });
                            },
                            controller: _textMessageController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _isDisplaySendButton = true;
                                  _textMessageController.text = value;
                                });
                              } else {
                                setState(() {
                                  _isDisplaySendButton = false;
                                  _textMessageController.text = value;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              prefixIcon: GestureDetector(
                                onTap: toggleEmojiKeyboard,
                                child: Icon(
                                  isShowEmojiKeyboard == false
                                      ? Icons.emoji_emotions
                                      : Icons.keyboard_outlined,
                                  color: greyColor,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Wrap(
                                  children: [
                                    Transform.rotate(
                                      angle: -0.5,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _isShowAttachWindown =
                                                !_isShowAttachWindown;
                                          });
                                        },
                                        child: Icon(
                                          Icons.attach_file,
                                          color: greyColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    GestureDetector(
                                      onTap: () {
                                        selectedImage().then((value) {
                                          if (_image != null) {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((time) {
                                                  showImagePickedBottomModalSheet(
                                                    context,
                                                    recipientName:
                                                        widget
                                                            .message
                                                            .recipientName,
                                                    file: _image,
                                                    onTap: () {
                                                      _sendImageMessage();
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                });
                                          }
                                        });
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: greyColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: tabColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _sendTextMessage();
                          },
                          child: Center(
                            child: Icon(
                              _isDisplaySendButton
                                  ? Icons.send_outlined
                                  : _isRecording
                                  ? Icons.close
                                  : Icons.mic,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                isShowEmojiKeyboard
                    ? SizedBox(
                      height: 310,
                      child: Stack(
                        children: [
                          (Platform.isAndroid || Platform.isIOS)
                              ? EmojiPicker(
                                scrollController: _scrollEmojiController,
                                config: const Config(
                                  height: 256,
                                  checkPlatformCompatibility: true,
                                  viewOrderConfig: ViewOrderConfig(),
                                  emojiViewConfig: EmojiViewConfig(
                                    emojiSizeMax: 28 * 1.2,
                                  ),
                                  skinToneConfig: SkinToneConfig(),
                                  categoryViewConfig: CategoryViewConfig(),
                                  bottomActionBarConfig:
                                      BottomActionBarConfig(),
                                  searchViewConfig: SearchViewConfig(),
                                ),

                                onEmojiSelected: ((category, emoji) {
                                  setState(() {
                                    _textMessageController.text =
                                        _textMessageController.text +
                                        emoji.emoji;
                                  });
                                }),
                              )
                              : SizedBox(),

                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: appBarColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(
                                      Icons.search,
                                      size: 20,
                                      color: greyColor,
                                    ),
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_emotions_outlined,
                                          size: 20,
                                          color: tabColor,
                                        ),
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.gif_box_outlined,
                                          size: 20,
                                          color: greyColor,
                                        ),
                                        SizedBox(width: 15),
                                        Icon(
                                          Icons.ad_units,
                                          size: 20,
                                          color: greyColor,
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _textMessageController
                                              .text = _textMessageController
                                              .text
                                              .substring(
                                                0,
                                                _textMessageController
                                                        .text
                                                        .length -
                                                    2,
                                              );
                                        });
                                      },
                                      child: const Icon(
                                        Icons.backspace_outlined,
                                        size: 20,
                                        color: greyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                    : const SizedBox(),
              ],
            ),
            _isShowAttachWindown == true
                ? Positioned(
                  bottom: 65,
                  top: 260,
                  left: 15,
                  right: 15,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.2,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: bottomAttachContainerColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _attachWindowItem(
                              icon: Icons.document_scanner,
                              color: Colors.deepPurpleAccent,
                              title: "Document",
                            ),
                            _attachWindowItem(
                              icon: Icons.camera_alt,
                              color: Colors.pinkAccent,
                              title: "Camera",
                              onTap: () {},
                            ),
                            _attachWindowItem(
                              icon: Icons.image,
                              color: Colors.purpleAccent,
                              title: "Gallery",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _attachWindowItem(
                              icon: Icons.headphones,
                              color: Colors.deepOrange,
                              title: "Audio",
                            ),
                            _attachWindowItem(
                              icon: Icons.location_on,
                              color: Colors.green,
                              title: "Location",
                            ),
                            _attachWindowItem(
                              icon: Icons.account_circle,
                              color: Colors.deepPurpleAccent,
                              title: "Contact",
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _attachWindowItem(
                              icon: Icons.bar_chart,
                              color: Colors.deepOrange,
                              title: "Poll",
                            ),
                            _attachWindowItem(
                              icon: Icons.gif_box_outlined,
                              color: Colors.green,
                              title: "Gif",
                              onTap: () {
                                _sendGifMessage();
                              },
                            ),
                            _attachWindowItem(
                              icon: Icons.videocam_rounded,
                              color: Colors.deepPurpleAccent,
                              title: "Video",
                              onTap: () {
                                selectVideo().then((value) {
                                  if (_video != null) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((time) {
                                          showVideoPickedBottomModalSheet(
                                            context,
                                            recipientName:
                                                widget.message.recipientName,
                                            file: _video,
                                            onTap: () {
                                              _sendVideoMessage();
                                              Navigator.pop(context);
                                            },
                                          );
                                        });
                                  }
                                });
                                setState(() {
                                  _isShowAttachWindown = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                : Container(),
          ],
        ),
      ),
    );
  }

  _attachWindowItem({
    IconData? icon,
    Color? color,
    String? title,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: color,
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 5),
          Text(
            "$title",
            style: const TextStyle(color: greyColor, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _sendTextMessage() async {
    final provider = BlocProvider.of<MessageCubit>(context);

    if (_isDisplaySendButton || _textMessageController.text.trim().isNotEmpty) {
      if (provider.messageReplay.message != null) {
        _sendMessage(
          message: _textMessageController.text,
          type: MessageTypeConst.textMessage,
          repliedMessage: provider.messageReplay.message,
          repliedTo: provider.messageReplay.userId,
          repliedMessageType: provider.messageReplay.messageType,
        );
      } else {
        _sendMessage(
          message: _textMessageController.text,
          type: MessageTypeConst.textMessage,
        );
      }
      provider.setMessageReplay = MessageReplayEntity();
      setState(() {
        _textMessageController.clear();
      });
      return;
    }

    if (!_isRecordInit) return;

    final temporaryDir = await getTemporaryDirectory();
    final tempPath =
        '${temporaryDir.path}/record_${DateTime.now().millisecondsSinceEpoch}.m4a';

    try {
      if (_isRecording) {
        final path = await _soundRecorder!.stopRecorder();
        setState(() => _isRecording = false);

        if (path != null) {
          final file = File(path);
          final url = await StorageProviderRemoteDataSource.uploadMessageFile(
            file: file,
            onComplete: (_) {},
            otherUid: widget.message.recipientId,
            type: MessageTypeConst.audioMessage,
          );
          _sendMessage(message: url, type: MessageTypeConst.audioMessage);
        }
      } else {
        await _soundRecorder!.startRecorder(
          toFile: tempPath,
          codec: Codec.aacMP4,
        );
        setState(() => _isRecording = true);
      }
    } catch (e) {
      debugPrint("🎙️ Recorder error: $e");
      toast("some error");
    }
  }

  void _sendImageMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _image!,
      otherUid: widget.message.recipientId,
      type: MessageTypeConst.photoMessage,
      onComplete: (isUploading) {},
    ).then((imageUrl) {
      _sendMessage(message: imageUrl, type: MessageTypeConst.photoMessage);
    });
  }

  void _sendVideoMessage() {
    StorageProviderRemoteDataSource.uploadMessageFile(
      file: _video!,
      otherUid: widget.message.recipientId,
      type: MessageTypeConst.videoMessage,
      onComplete: (isUploading) {},
    ).then((imageUrl) {
      _sendMessage(message: imageUrl, type: MessageTypeConst.videoMessage);
    });
  }

  void _sendMessage({
    required String message,
    required String type,
    String? repliedMessage,
    String? repliedTo,
    String? repliedMessageType,
  }) {
    ChatUtils.sendMesssage(
      context,
      messageEntity: widget.message,
      message: message,
      type: type,
      repliedTo: (repliedTo != null && repliedTo.isNotEmpty) ? repliedTo : null,
      repliedMessage: repliedMessage,
      repliedMessageType: repliedMessageType,
    ).then((value) {
      setState(() {
        _textMessageController.clear();
      });
    });
    _scrollToBottom();
  }

  Future _sendGifMessage() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      String fixedUrl = "https://media.giphy.com/media/${gif.id}/giphy.gif";
      _sendMessage(message: fixedUrl, type: MessageTypeConst.gifMessage);
    }
  }
}

// Possition, Image, Expanded. Swip, Listview, Gesdetec, Messagetpwidget,
