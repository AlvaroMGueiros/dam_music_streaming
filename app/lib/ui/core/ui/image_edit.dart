import 'dart:ui';

import 'package:flutter/material.dart';

class ImageRoundEdit extends StatelessWidget {

  final GestureTapCallback? onTap;
  final dynamic coverPlaylistFile;

  const ImageRoundEdit({
    super.key,
    this.onTap,
    this.coverPlaylistFile
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 80,
          backgroundColor: Colors.grey.shade300,
          backgroundImage: coverPlaylistFile.existsSync() ? FileImage(
              coverPlaylistFile) : null,
          child: coverPlaylistFile.existsSync()
              ? null
              : Icon(
            Icons.music_note,
            size: 50,
            color: Colors.grey.shade600,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}