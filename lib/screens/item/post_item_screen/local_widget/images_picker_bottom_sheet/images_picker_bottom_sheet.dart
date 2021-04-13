import 'dart:io';
import 'dart:typed_data';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:mime/mime.dart' as mime;
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/selective_image_view/selective_image_view.dart';

class ImagesPickerBottomSheet extends StatefulWidget {
  final List<ImageData> imagesInGallery;

  ImagesPickerBottomSheet(
    this.imagesInGallery,
  );

  @override
  _ImagesPickerBottomSheetState createState() =>
      _ImagesPickerBottomSheetState();
}

class _ImagesPickerBottomSheetState extends State<ImagesPickerBottomSheet> {
  bool _isLoading = false;
  Map<String, ImageData> _images = {};
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

  void onSubmit() {
    Navigator.pop(context, _images);
  }

  @override
  Widget build(BuildContext context) {
    _images.addAll(ModalRoute.of(context).settings.arguments);
    return Container(
      height: 300,
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              onPressed: () {
                getImage().then((image) {
                  setState(() {
                    widget.imagesInGallery.insert(
                        0, ImageData(image.readAsBytesSync(), image.path));
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
              onPressed: onSubmit,
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
                    primary: true,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    cacheExtent: 2000,
                    children: widget.imagesInGallery.map((image) {
                      return SelectiveImageView(
                          onPress: () {
                            setState(() {
                              if (_images.containsKey(image.path)) {
                                _images.remove(image.path);
                              } else {
                                _images[image.path] = image;
                              }
                            });
                          },
                          image: image,
                          isSelected: _images.containsKey(image.path));
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
