import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/features/app/constants/app_assets.dart';
import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/material.dart';

Widget profileWidget({String? imageUrl, File? image}) {
  if (image == null) {
    if (imageUrl == null || imageUrl == "") {
      return Image.asset(AppAssets.defaultAvatar, fit: BoxFit.cover);
    } else {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return const CircularProgressIndicator(color: tabColor);
        },
        errorWidget:
            (context, url, error) =>
                Image.asset(AppAssets.defaultAvatar, fit: BoxFit.cover),
      );
    }
  } else {
    return Image.file(image, fit: BoxFit.cover);
  }
}
