import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:mime/mime.dart' as mime;
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/selective_image_view/selective_image_view.dart';

class ImagesPickerBottomSheet extends StatefulWidget {
  final List<File> imagesInGallery;
  final Map<String, File> images;
  final Function onSubmit;

  ImagesPickerBottomSheet(this.imagesInGallery, this.images, this.onSubmit);

  @override
  _ImagesPickerBottomSheetState createState() =>
      _ImagesPickerBottomSheetState();
}

class _ImagesPickerBottomSheetState extends State<ImagesPickerBottomSheet> {
  bool _isLoading = false;

  Future<File> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      return image;
    } else {
      print('No image selected.');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: IconButton(
            onPressed: () {
              getImage().then((image) {
                setState(() {
                  widget.imagesInGallery.insert(0, image);
                });
              });
            },
            icon: Icon(Icons.camera_alt_rounded),
          ),
          title: Text(
            S.of(context).selectPhotos,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: widget.onSubmit,
            icon: Icon(Icons.check),
            color: Theme.of(context).primaryColor,
          ),
        ),
        Expanded(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.count(
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  cacheExtent: 5000,
                  children: widget.imagesInGallery.map((image) {
                    return SelectiveImageView(
                        onPress: () {
                          setState(() {
                            if (widget.images.containsKey(image.path)) {
                              widget.images.remove(image.path);
                            } else {
                              widget.images[image.path] = image;
                            }
                          });
                        },
                        image: image,
                        isSelected: widget.images.containsKey(image.path));
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
