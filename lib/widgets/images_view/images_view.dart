import 'package:flutter/material.dart';
import 'package:secondhand_sharing/screens/photo_view_screen/photo_view_screen.dart';

class ImagesView extends StatefulWidget {
  final List<String> images;

  ImagesView(this.images);
  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  String selectedImage;

  @override
  void initState() {
    if (widget.images.isNotEmpty)
      selectedImage = widget.images[0];
    else
      selectedImage = "https://i.stack.imgur.com/y9DpT.jpg";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotoViewScreen(selectedImage)));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                selectedImage,
                height: screenSize.height * 0.6,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: widget.images
                  .map((image) => InkWell(
                        onTap: () {
                          setState(() {
                            selectedImage = image;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  selectedImage == image ? Border.all(color: Theme.of(context).primaryColor, width: 2) : null),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              image,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}
