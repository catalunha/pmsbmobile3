import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget{
  final ImageProvider image;

  const CircleImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: image,
          ),
        ),
      ),
    );
  }
}