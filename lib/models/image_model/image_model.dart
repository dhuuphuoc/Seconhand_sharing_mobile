import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart' as mime;
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:watcher/watcher.dart';

class ImageModel {
  List<ImageData> imagesData = [];
  static final ImageModel _singleton = ImageModel._create();

  factory ImageModel() {
    return _singleton;
  }

  ImageModel._create();

  void onFileChanged(WatchEvent event) {
    print(event.path);
    if (event.type == ChangeType.ADD) {
      var file = File(event.path);
      imagesData.add(ImageData(file.readAsBytesSync(), file.path));
    }
    if (event.type == ChangeType.REMOVE) {
      imagesData.removeWhere((image) => image.path == event.path);
    }
    if (event.type == ChangeType.MODIFY) {
      var file = File(event.path);
      var imageData = imagesData.firstWhere((image) => image.path == file.path);
      imageData.data = file.readAsBytesSync();
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
    var captureWatcher = DirectoryWatcher(capture.path);
    captureWatcher.events.listen(onFileChanged);
    var dcimWatcher = DirectoryWatcher(dcimPath);
    dcimWatcher.events.listen(onFileChanged);
    var pictureWatcher = DirectoryWatcher(picturePath);
    pictureWatcher.events.listen(onFileChanged);
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
