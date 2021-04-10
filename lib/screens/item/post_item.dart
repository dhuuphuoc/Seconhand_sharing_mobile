import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/screens/item/local_widget/add_photo/add_photo.dart';
import 'package:secondhand_sharing/screens/item/local_widget/image_view/image_view.dart';
import 'package:secondhand_sharing/screens/item/local_widget/selective_image_view/selective_image_view.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';
import 'package:secondhand_sharing/widgets/horizontal_categories_list/horizontal_categories_list.dart';
import "package:ext_storage/ext_storage.dart";
import 'package:path_provider/path_provider.dart' as path;
import 'package:mime/mime.dart' as mime;

class PostItemScreen extends StatefulWidget {
  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  CategoryModel _categoryModel = CategoryModel();
  @override
  void initState() {
    loadDirectory();
    super.initState();
  }

  List<File> _imagesInGallery = [];
  var _images = <File>[];
  final picker = ImagePicker();
  var capture;
  var dcimPath;
  var picturePath;
  void loadDirectory() async {
    capture = await path.getExternalStorageDirectory();

    dcimPath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DCIM);

    picturePath = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_PICTURES);
  }

  Future<void> loadImages() async {
    _imagesInGallery = [];

    await collectImagesFromDirectory(capture);

    var dcim = Directory(dcimPath);
    await collectImagesFromDirectory(dcim);

    var picture = Directory(picturePath);
    await collectImagesFromDirectory(picture);
  }

  Future<void> collectImagesFromDirectory(FileSystemEntity entity) async {
    if (entity is File) {
      File file = entity;
      if (mime.lookupMimeType(file.path).startsWith("image/"))
        _imagesInGallery.add(file);
      return;
    }
    if (entity is Directory) {
      Directory dir = entity;
      await dir.list().forEach((element) async {
        await collectImagesFromDirectory(element);
      });
    }
  }

  void submitImage() {
    setState(() {});
    Navigator.pop(context);
  }

  Future<File> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      return image;
    } else {
      print('No image selected.');
      return null;
    }
  }

  void pickImages() {
    loadImages().whenComplete(() {
      showModalBottomSheet(
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Container(
                  height: 300,
                  padding: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(
                          onPressed: () {
                            getImage().then((image) {
                              setModalState(() {
                                _imagesInGallery.insert(0, image);
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
                          onPressed: _images.length == 0 ? null : submitImage,
                          icon: Icon(Icons.check),
                          color: _images.length == 0
                              ? Theme.of(context).iconTheme.color
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: GridView.count(
                          mainAxisSpacing: 10,
                          crossAxisCount: 3,
                          cacheExtent: 10000,
                          children: _imagesInGallery.map((image) {
                            return SelectiveImageView(
                              onPress: () {
                                setModalState(() {
                                  if (_images.any((selectedImage) {
                                    return selectedImage.path == image.path;
                                  })) {
                                    _images.removeWhere((selectedImage) {
                                      return selectedImage.path == image.path;
                                    });
                                  } else {
                                    _images.add(image);
                                  }
                                });
                              },
                              image: image,
                              isSelected: _images.any((selectedImage) {
                                return selectedImage.path == image.path;
                              }),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ));
            });
          },
          backgroundColor: Theme.of(context).backgroundColor,
          context: context);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).donate,
              style: Theme.of(context).textTheme.headline1)),
      body: SingleChildScrollView(
        child: Form(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(children: [
              //Avatar address
              Card(
                margin: EdgeInsets.zero,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                      maxRadius: 25,
                      child: Image.asset(
                        "assets/images/person.png",
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                      backgroundColor: Colors.transparent),
                  title: Text("Hữu Dũng"),
                  subtitle: Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.pink),
                      Text("67 Dã tượng")
                    ],
                  ),
                  trailing: IconButton(
                    color: Theme.of(context).primaryColor,
                    icon: Icon(Icons.map_outlined),
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Title
              TextFormField(
                decoration: InputDecoration(
                    hintText: "${S.of(context).title}...",
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              //Add photo
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length + 1,
                  cacheExtent: 10000,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return AddPhoto(onPress: pickImages);
                    } else {
                      File image = _images[index - 1];
                      return ImageView(image: image);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Categories
              HorizontalCategoriesList(_categoryModel),
              SizedBox(
                height: 10,
              ),
              //Phone number
              TextFormField(
                decoration: InputDecoration(
                    hintText: "${S.of(context).phoneNumber}",
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              //Description
              TextFormField(
                minLines: 8,
                maxLines: 10,
                decoration: InputDecoration(
                    hintText: "${S.of(context).description}...",
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              GradientButton(
                onPress: () {},
                text: S.of(context).post,
              ),
              SizedBox(
                height: 20,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
