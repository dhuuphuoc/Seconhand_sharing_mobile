import 'package:flutter/material.dart';
import 'package:secondhand_sharing/screens/photo_view_screen/photo_view_screen.dart';
import 'package:secondhand_sharing/widgets/images_view/images_view.dart';

class ItemDetailCard extends StatefulWidget {
  final List<String> images;
  final String itemName;
  final String description;

  ItemDetailCard({this.images, this.itemName, this.description});

  @override
  _ItemDetailCardState createState() => _ItemDetailCardState();
}

class _ItemDetailCardState extends State<ItemDetailCard> {
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
            Text(widget.description),
            SizedBox(
              height: 10,
            ),
            ImagesView(widget.images)
          ],
        ),
      ),
    );
  }
}
