import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:mime/mime.dart' as mime;
import 'package:secondhand_sharing/models/image_model/image_data.dart';

class ImageModel {
  List<ImageData> imagesData = [];
  static final ImageModel _singleton = ImageModel._create();

  factory ImageModel() {
    return _singleton;
  }

  ImageModel._create();

  Future<void> loadImages() async {
    var capture = await path.getExternalStorageDirectory();

    var dcimPath = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DCIM);

    var picturePath = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_PICTURES);

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
        imagesData.add(ImageData(file.readAsBytesSync(), file.path));
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
}
