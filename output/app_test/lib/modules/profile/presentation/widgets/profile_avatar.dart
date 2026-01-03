/// Profile avatar widget.
library;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Avatar widget for user profile.
class ProfileAvatar extends StatelessWidget {
  final String? photoUrl;
  final String initials;
  final double size;

  const ProfileAvatar({
    super.key,
    this.photoUrl,
    required this.initials,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: photoUrl != null
          ? CachedNetworkImageProvider(photoUrl!)
          : null,
      child: photoUrl == null
          ? Text(
              initials,
              style: TextStyle(
                fontSize: size * 0.4,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}

