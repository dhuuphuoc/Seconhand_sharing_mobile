import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/address_model/address_model.dart';
import 'package:secondhand_sharing/models/category_model/category.dart';
import 'package:secondhand_sharing/models/category_model/category_model.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_model/image_model.dart';
import 'package:secondhand_sharing/models/item_model/post_item_model.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/add_photo/add_photo.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/image_view/image_view.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/images_picker_bottom_sheet/images_picker_bottom_sheet.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/user_info_card/user_info_card.dart';
import 'package:secondhand_sharing/services/api_services/item_services/item_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/category_tab/category_tab.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';

class PostItemScreen extends StatefulWidget {
  @override
  _PostItemScreenState createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen>
    with TickerProviderStateMixin {
  CategoryModel _categoryModel = CategoryModel();

  var _images = <String, ImageData>{};

  Future<void> requestStoragePermission() async {
    if (await Permission.storage.isDenied) {
      if (await Permission.storage.request().isGranted) {
        await ImageModel().loadImages();
      }
    }
  }

  @override
  void initState() {
    requestStoragePermission();
    super.initState();
  }

  AddressModel _addressModel = AddressModel();
  void pickImages() {
    showModalBottomSheet(
            context: context,
            builder: (context) {
              return ImagesPickerBottomSheet();
            },
            routeSettings: RouteSettings(arguments: _images))
        .then((value) {
      if (value != null) {
        setState(() {
          _images = value;
        });
      }
    });
  }

  void onSubmit() async {
    String addressValidateMessage =
        Validator.validateAddressModel(_addressModel);
    if (addressValidateMessage != null) {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(
                S.of(context).address, addressValidateMessage, "OK");
          });
      return;
    }
    String imagesValidateMessage = Validator.validateImages(_images);
    if (imagesValidateMessage != null) {
      showDialog(
          context: context,
          builder: (context) {
            return NotifyDialog(
                S.of(context).images, imagesValidateMessage, "OK");
          });
      return;
    }
    if (!_formKey.currentState.validate()) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.zero,
          content: ListBody(
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          ),
          actions: <Widget>[],
        );
      },
    );
    PostItemForm postItemForm = PostItemForm(
        imageNumber: _images.length,
        itemName: _titleController.text,
        categoryId: _categoryModel.selectedId,
        description: _descriptionController.text,
        receiveAddress: _addressModel);
    PostItemModel postItemModel = await ItemServices.postItem(postItemForm);
    if (postItemModel != null) {
      for (int i = 0; i < _images.length; i++) {
        int statusCode = await ItemServices.uploadImage(
            _images.values.elementAt(i),
            postItemModel.data.imageUploads[i].presignUrl);
      }
      // showNotifyDialog(S.of(context).posted, S.of(context).postedNotification);
    } else {
      // showNotifyDialog(S.of(context).error, S.of(context).postError);
    }
    Navigator.pop(context);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context).postedNotification),
      ),
    );
  }

  void onMapPress() async {
    Navigator.pushNamed(context, "/item/address", arguments: _addressModel)
        .then((value) {
      setState(() {
        if (value != null) _addressModel = value;
      });
    });
  }

  final _titleController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(S.of(context).donate,
              style: Theme.of(context).textTheme.headline1)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(children: [
              //Avatar address
              UserInfoCard(_addressModel, onMapPress),
              SizedBox(
                height: 20,
              ),
              //Title
              TextFormField(
                controller: _titleController,
                validator: Validator.validateTitle,
                decoration: InputDecoration(
                    hintText: "${S.of(context).title}...",
                    labelText: "${S.of(context).title}",
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
                  itemCount: _images.values.toList().length + 1,
                  cacheExtent: 10000,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return AddPhoto(onPress: pickImages);
                    } else {
                      ImageData image = _images.values.toList()[index - 1];
                      return ImageView(image: image);
                    }
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //Categories
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).backgroundColor,
                    borderRadius: BorderRadius.circular(10)),
                height: 130,
                child: ListView.builder(
                  itemExtent: 90,
                  scrollDirection: Axis.horizontal,
                  itemCount: _categoryModel.categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    Category category = _categoryModel.categories[index];
                    return CategoryTab(
                        category.id == _categoryModel.selectedId, category, () {
                      setState(() {
                        _categoryModel.selectedId = category.id;
                      });
                    });
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              //Phone number
              TextFormField(
                validator: Validator.validatePhoneNumber,
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "0912345678",
                    labelText: "${S.of(context).phoneNumber}",
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
                maxLines: 20,
                validator: Validator.validateDescription,
                controller: _descriptionController,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                    hintText: "${S.of(context).description}...",
                    filled: true,
                    fillColor: Theme.of(context).backgroundColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onSubmit, child: Text(S.of(context).post))),
              SizedBox(
                height: 10,
              )
            ]),
          ),
        ),
      ),
    );
  }
}
