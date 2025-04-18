import 'package:chat_application/features/app/constants/app_assets.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/chat/domain/entities/message_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

class SingleChatPage extends StatefulWidget {
  final MessageEntity message;
  const SingleChatPage({super.key, required this.message});

  @override
  State<SingleChatPage> createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textMessageController = TextEditingController();
  bool _isDisplaySendButton = false;

  bool _isShowAttachWindown = false;

  @override
  void dispose() {
    _textMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child:
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: 2, // Replace with dynamic message count
                  //   itemBuilder: (context, index) {
                  //     return _messageLayout(
                  //       message: "Hello",
                  //       alignment: Alignment.centerRight,
                  //       createAt: Timestamp.now(),
                  //       isSeen: false,
                  //       isShowTick: true,
                  //       messageBgColor: tabColor,
                  //       onLongPress: () {},
                  //       onSwipe: (details) {},
                  //     );
                  //   },
                  // ),
                  ListView(
                    children: [
                      _messageLayout(
                        message: "Hello",
                        alignment: Alignment.centerRight,
                        createAt: Timestamp.now(),
                        isSeen: false,
                        isShowTick: true,
                        messageBgColor: tabColor,
                        onLongPress: () {},
                        onSwipe: (details) {},
                      ),
                      _messageLayout(
                        message: "How are you",
                        alignment: Alignment.centerLeft,
                        createAt: Timestamp.now(),
                        isSeen: false,
                        isShowTick: false,
                        messageBgColor: senderMessageColor,
                        onLongPress: () {},
                        onSwipe: (details) {},
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: appBarColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            onTap: () {
                              setState(() {
                                _isShowAttachWindown = false;
                                _isShowAttachWindown = false;
                              });
                            },
                            controller: _textMessageController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() {
                                  _isDisplaySendButton = true;
                                });
                              } else {
                                setState(() {
                                  _isDisplaySendButton = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.emoji_emotions,
                                color: greyColor,
                              ),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Wrap(
                                  children: [
                                    Transform.rotate(
                                      angle: -0.5,
                                      child: GestureDetector(
                                        onTap: () {
                                          _isShowAttachWindown =
                                              !_isShowAttachWindown;
                                        },
                                        child: Icon(
                                          Icons.attach_file,
                                          color: greyColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Icon(Icons.camera_alt, color: greyColor),
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
                        child: Center(
                          child: Icon(
                            _isDisplaySendButton
                                ? Icons.send_outlined
                                : Icons.mic,
                            color: whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _isShowAttachWindown == true
                ? Positioned(
                  bottom: 65,
                  top: 340,
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

  _messageLayout({
    Color? messageBgColor,
    Alignment? alignment,
    Timestamp? createAt,
    GestureDragUpdateCallback? onSwipe,
    double? rightPadding,
    String? message,
    bool? isShowTick,
    bool? isSeen,
    VoidCallback? onLongPress,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SwipeTo(
        onRightSwipe: onSwipe,
        child: GestureDetector(
          onLongPress: onLongPress,
          child: Container(
            alignment: alignment,
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      padding: const EdgeInsets.only(
                        left: 3,
                        right: 85,
                        top: 5,
                        bottom: 5,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.80,
                      ),
                      decoration: BoxDecoration(
                        color: messageBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$message',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 3),
                  ],
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        DateFormat.jm().format(createAt!.toDate()),
                        style: const TextStyle(
                          fontSize: 12,
                          color: lightGreyColor,
                        ),
                      ),
                      SizedBox(width: 5),
                      isShowTick == true
                          ? Icon(
                            isSeen == true ? Icons.done_all : Icons.done,
                            size: 16,
                            color:
                                isSeen == true ? Colors.blue : lightGreyColor,
                          )
                          : Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
}
