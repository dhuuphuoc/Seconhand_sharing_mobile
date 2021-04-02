import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:image_picker/image_picker.dart';

class PostItemScreen extends StatefulWidget {
  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  @override
  void initState() {
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
      backgroundColor: Color(0xFFCFD8DC),
      appBar: AppBar(
          title: Text(S.of(context).donate,
              style: TextStyle(color: Color(0xFF528FEB)))),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Form(
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                margin: new EdgeInsets.all(10),
                child: new Row(
                  children: [
                    new Column(
                      children: [
                        Image.asset(
                          "assets/images/person.png",
                          fit: BoxFit.fill,
                          width: 50,
                        )
                      ],
                    ),
                    new Column(
                      children: [new Text('Name'), new Text("Address")],
                    ),
                    new Column(
                      children: [
                        Icon(Icons.location_on_outlined)
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
