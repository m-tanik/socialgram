import 'package:flutter/material.dart';
import 'package:social_gram/widgets/custom_image.dart';
import 'package:social_gram/widgets/post.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('full screen image'),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
