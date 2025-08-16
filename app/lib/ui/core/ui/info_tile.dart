import 'dart:ui';

import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String subtitle;
  final Widget? leading;
  final Widget? trailing;
  final GestureTapCallback? onTap;

  const InfoTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.leading,
    this.trailing,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          image: DecorationImage(
            image: NetworkImage(imageUrl ?? ''),
            fit: BoxFit.cover,
          ),
        ),
      ),

      title: Text(title ?? ''),
      subtitle: Text(subtitle ?? ''),
      contentPadding: EdgeInsets.only(left: 7),
      trailing: trailing,
      onTap: onTap,
    );
  }
}