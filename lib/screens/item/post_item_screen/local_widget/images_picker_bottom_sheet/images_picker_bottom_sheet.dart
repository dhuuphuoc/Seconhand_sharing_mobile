import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  bool _isLoading = true;

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

  Future<void> loadImages() async {
    var capture = await path.getExternalStorageDirectory();

    var dcimPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);

    var picturePath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_PICTURES);

    await collectImagesFromDirectory(capture);

    var dcim = Directory(dcimPath);
    await collectImagesFromDirectory(dcim);

    var picture = Directory(picturePath);
    await collectImagesFromDirectory(picture);
  }

  Future<void> collectImagesFromDirectory(FileSystemEntity entity) async {
    if (entity is File) {
      File file = entity;
      if (mime.lookupMimeType(file.path).startsWith("image/")) {
        setState(() {
          widget.imagesInGallery.add(file);
        });
      }
      return;
    }
    if (entity is Directory) {
      Directory dir = entity;
      await dir.list().forEach((element) async {
        await collectImagesFromDirectory(element);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    loadImages();
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
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
                S.of(context).addPhoto,
                textAlign: TextAlign.center,
              ),
              trailing: IconButton(
                onPressed: widget.images.length == 0 ? null : widget.onSubmit,
                icon: Icon(Icons.check),
                color: widget.images.length == 0
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).primaryColor,
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
                      cacheExtent: 10000,
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
        ));
  }
}
