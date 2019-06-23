import 'package:flutter/material.dart';

class SquareImage extends StatelessWidget {
  final ImageProvider image;

  const SquareImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image,
          ),
        ),
      ),
    );
  }
}
