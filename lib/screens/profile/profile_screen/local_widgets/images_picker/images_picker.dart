import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_model/image_model.dart';
import 'package:secondhand_sharing/screens/profile/profile_screen/local_widgets/tappable_image/tappable_image.dart';
import 'package:secondhand_sharing/widgets/dialog/confirm_dialog/confirm_dialog.dart';

class ImagesPicker extends StatefulWidget {
  @override
  _ImagesPickerState createState() => _ImagesPickerState();
}

class _ImagesPickerState extends State<ImagesPicker> {
  bool _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
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
                    S.of(context).chooseImage,
                    textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close),
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
                          children: _imagesInGallery.map((image) {
                            return TappableImage(() {
                              showDialog(
                                  context: context,
                                  builder: (context) => ConfirmDialog(
                                      S.of(context).areYouSure, S.of(context).avatarChangeConfirmation)).then((value) {
                                if (value == true) {
                                  Navigator.pop(context, image);
                                }
                              });
                            }, image);
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
