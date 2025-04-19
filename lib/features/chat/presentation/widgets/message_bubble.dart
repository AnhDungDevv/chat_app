import 'package:chat_application/features/app/constants/message_type_const.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/chat/domain/entities/message_reply_entity.dart';
import 'package:chat_application/features/chat/presentation/widgets/message_replay_type_widget.dart';
import 'package:chat_application/features/chat/presentation/widgets/message_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.senderId,
    required this.message,
    required this.messageType,
    required this.alignment,
    required this.createAt,
    required this.isShowTick,
    required this.isSeen,
    required this.messageBgColor,
    this.rightPadding,
    this.reply,
    this.onLongPress,
    this.onSwipe,
  });

  final String message;
  final String senderId;
  final String messageType;
  final Alignment alignment;
  final DateTime createAt;
  final bool isShowTick;
  final double? rightPadding;
  final bool isSeen;
  final Color messageBgColor;
  final MessageReplayEntity? reply;
  final VoidCallback? onLongPress;
  final GestureDragUpdateCallback? onSwipe;

  @override
  Widget build(BuildContext context) {
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
                      padding: EdgeInsets.only(
                        left: 5,
                        right:
                            messageType == MessageTypeConst.textMessage
                                ? (rightPadding ?? 5)
                                : 5,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reply?.message == null || reply?.message == ""
                              ? const SizedBox()
                              : Container(
                                height:
                                    reply!.messageType ==
                                            MessageTypeConst.textMessage
                                        ? 70
                                        : 80,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: double.infinity,
                                      width: 4.5,
                                      decoration: BoxDecoration(
                                        color:
                                            reply!.userId == senderId
                                                ? Colors.deepPurpleAccent
                                                : tabColor,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(15),
                                          bottomLeft: Radius.circular(15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0,
                                          vertical: 5,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              (reply!.username ?? ''),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    reply!.username == "You"
                                                        ? tabColor
                                                        : Colors
                                                            .deepPurpleAccent,
                                              ),
                                            ),
                                            MessageReplayTypeWidget(
                                              message: reply!.message,
                                              type: reply!.messageType,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          const SizedBox(height: 3),
                          _buildMessageTypeWidget(
                            message: message,
                            messageType: messageType,
                          ),
                        ],
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
                        DateFormat.jm().format(createAt),
                        style: const TextStyle(fontSize: 12, color: greyColor),
                      ),
                      const SizedBox(width: 5),
                      if (isShowTick)
                        Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 16,
                          color: isSeen ? Colors.blue : greyColor,
                        ),
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

  Widget _buildMessageTypeWidget({
    required String message,
    required String messageType,
  }) {
    return MessageTypeWidget(message: message, type: messageType);
  }
}
