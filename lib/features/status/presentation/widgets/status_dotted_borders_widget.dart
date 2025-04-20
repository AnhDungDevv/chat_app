import 'dart:math';

import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';
import 'package:flutter/material.dart';

class StatusDottedBordersWidget extends CustomPaint {
  //number of stories
  final int numberOfStories;

  // Length of the space arc
  final int spaceLength;
  final String? userId;
  final List<StatusImageEntity>? images;
  final bool isMe;
  StatusDottedBordersWidget({
    super.key,
    required this.numberOfStories,
    this.spaceLength = 10,
    this.userId,
    this.images,
    required this.isMe,
  });

  //start of the arc painting in degree(0-360)
  double startOfArcInDegree = 0;

  double inRads(double degree) {
    return (degree * pi) / 180;
  }

  @override
  bool shouldRepaint(StatusDottedBordersWidget oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    if (numberOfStories <= 1) {
      final Color circleColor;
      if (isMe) {
        circleColor = greyColor.withAlpha((0.5 * 255).toInt());
      } else if (images![0].viewers!.contains(userId)) {
        circleColor = greyColor.withAlpha((0.5 * 255).toInt());
      } else {
        circleColor = tabColor;
      }
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        min(size.width / 2, size.height / 2),
        Paint()
          ..color = circleColor
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
      );
    } else {
      double arcLength =
          (360 - (numberOfStories * spaceLength)) / numberOfStories;

      if (arcLength <= 0) {
        arcLength = 360 / spaceLength - 1;
      }
      for (int i = 0; i < numberOfStories; i++) {
        canvas.drawArc(
          rect,
          inRads(startOfArcInDegree),
          inRads(arcLength),
          false,
          Paint()
            ..color =
                isMe
                    ? greyColor.withAlpha((0.5 * 255).toInt())
                    : images![i].viewers!.contains(userId)
                    ? greyColor.withAlpha((0.5 * 255).toInt())
                    : tabColor
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke,
        );
        startOfArcInDegree += arcLength + spaceLength;
      }
    }
  }
}
