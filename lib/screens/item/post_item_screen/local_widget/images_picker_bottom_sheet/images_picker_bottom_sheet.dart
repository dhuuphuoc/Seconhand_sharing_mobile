import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_model/image_model.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/selective_image_view/selective_image_view.dart';

class ImagesPickerBottomSheet extends StatefulWidget {
  @override
  _ImagesPickerBottomSheetState createState() => _ImagesPickerBottomSheetState();
}

class _ImagesPickerBottomSheetState extends State<ImagesPickerBottomSheet> {
  bool _isLoading = false;
  List<ImageData> _images = [];
  List<ImageData> _imagesInGallery = ImageModel().imagesData;
  bool _isPermissionGrant = false;
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

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      if (await Permission.storage.request().isDenied) {
        return;
      }
      await ImageModel().loadImages();
    }
    setState(() {
      _isPermissionGrant = true;
    });
  }

  @override
  void initState() {
    requestStoragePermission();
    super.initState();
  }

  void onSubmit() {
    Navigator.pop(context, _images);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.45,
      child: _isPermissionGrant
          ? Column(
              children: [
                ListTile(
                  leading: IconButton(
                    onPressed: () {
                      getImage().then((image) {
                        setState(() {
                          _imagesInGallery.insert(0, ImageData(image.readAsBytesSync(), image.path));
                        });
                      });
                    },
                    icon: Icon(Icons.camera_alt_rounded),
                  ),
                  title: Text(
                    S.of(context).addPhotos,
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
                          padding: EdgeInsets.symmetric(vertical: 10),
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          cacheExtent: 2000,
                          children: _imagesInGallery.map((image) {
                            return SelectiveImageView(
                                onPress: () {
                                  setState(() {
                                    if (_images.contains(image)) {
                                      _images.remove(image);
                                    } else {
                                      _images.add(image);
                                    }
                                  });
                                },
                                image: image,
                                isSelected: _images.contains(image));
                          }).toList(),
                        ),
                ),
              ],
            )
          : Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).grantStoragePermission,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 10),
                    Text(
                      S.of(context).grantStoragePermissionHint,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(onPressed: requestStoragePermission, child: Text(S.of(context).allowAccess))
                  ],
                ),
              ),
            ),
    );
  }
}
