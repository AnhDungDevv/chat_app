import 'dart:math';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:chat_application/features/status/domain/entities/status_image_entity.dart';
import 'package:flutter/material.dart';

class StatusDottedBordersWidget extends CustomPainter {
  final int numberOfStories;
  final int spaceLength;
  final String? userId;
  final List<StatusImageEntity>? images;
  final bool isMe;

  StatusDottedBordersWidget({
    required this.numberOfStories,
    this.spaceLength = 10,
    this.userId,
    this.images,
    required this.isMe,
  });

  double startOfArcInDegree = 0;

  double inRads(double degree) => (degree * pi) / 180;

  @override
  bool shouldRepaint(StatusDottedBordersWidget oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    Color getColorForIndex(int index) {
      if (images == null || images!.isEmpty) {
        return greyColor.withAlpha((0.5 * 255).toInt());
      }

      final image = images![index];
      final hasViewed = image.viewers?.contains(userId) ?? false;

      if (isMe || hasViewed) {
        return greyColor.withAlpha((0.5 * 255).toInt());
      } else {
        return tabColor;
      }
    }

    if (numberOfStories <= 1) {
      final circleColor = getColorForIndex(0);

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
        final arcColor = getColorForIndex(i % (images?.length ?? 1));

        canvas.drawArc(
          rect,
          inRads(startOfArcInDegree),
          inRads(arcLength),
          false,
          Paint()
            ..color = arcColor
            ..strokeWidth = 2.5
            ..style = PaintingStyle.stroke,
        );

        startOfArcInDegree += arcLength + spaceLength;
      }
    }
  }
}
