import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatelessWidget {
  final String url;

  PhotoViewScreen(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: PhotoView(
          imageProvider: NetworkImage(url ?? "https://i.stack.imgur.com/y9DpT.jpg"),
        ),
      ),
    );
  }
}
