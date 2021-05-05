import 'package:flutter/material.dart';

class ImagesView extends StatefulWidget {
  final List<String> images;
  final String itemName;

  ImagesView({this.images, this.itemName});

  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  String selectedImage;

  @override
  void initState() {
    selectedImage = widget.images[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.itemName,
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                selectedImage,
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
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
                              border: selectedImage == image
                                  ? Border.all(
                                      color: Theme.of(context).primaryColor,
                                      width: 2)
                                  : null),
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
            )
          ],
        ),
      ),
    );
  }
}
