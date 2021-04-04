import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/widgets/gradient_button/gradient_button.dart';
import 'package:secondhand_sharing/widgets/horizontal_categories_list/horizontal_categories_list.dart';

class PostItemScreen extends StatefulWidget {
  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  CategoryModel _categoryModel = CategoryModel();
  bool _isLoading = true;
  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
    super.initState();
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No image selected");
      }
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
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text("Name"),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.pink,
                      ),
                      Text("Address")
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
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Container(
                      constraints: BoxConstraints(minWidth: 120),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined),
                          Text("Add photo"),
                        ],
                      ),
                    ),
                  ],
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
