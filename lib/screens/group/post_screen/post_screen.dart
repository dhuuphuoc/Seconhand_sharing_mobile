import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/group_model/group_detail/group_detail.dart';
import 'package:secondhand_sharing/models/image_model/image_data.dart';
import 'package:secondhand_sharing/models/image_upload_model/images_upload_model.dart';
import 'package:secondhand_sharing/models/post/post.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/add_photo/add_photo.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/image_view/image_view.dart';
import 'package:secondhand_sharing/screens/item/post_item_screen/local_widget/images_picker_bottom_sheet/images_picker_bottom_sheet.dart';
import 'package:secondhand_sharing/services/api_services/api_services.dart';
import 'package:secondhand_sharing/services/api_services/post_services/post_services.dart';
import 'package:secondhand_sharing/utils/validator/validator.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/dialog/notify_dialog/notify_dialog.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  GroupDetail _group;
  List<ImageData> _images = [];
  bool _isPosting = false;
  bool _isSuccess = true;
  var _contentController = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  void pickImages() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ImagesPickerBottomSheet();
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _images.addAll(value);
        });
      }
    });
  }

  Future<void> onPost() async {
    if (!_formKey.currentState.validate()) return;
    setState(() {
      _isPosting = true;
    });
    ImagesUploadModel imagesUploadModel = await PostServices.post(
        PostForm(content: _contentController.text, imageNumber: _images.length, groupId: _group.id, visibility: 0));
    if (imagesUploadModel != null) {
      for (int i = 0; i < _images.length; i++) {
        bool result = await APIService.uploadImage(_images.elementAt(i), imagesUploadModel.imageUploads[i].presignUrl);
        if (!result) {
          _isSuccess = false;
        }
      }
      // showNotifyDialog(S.of(context).posted, S.of(context).postedNotification);
    } else {
      _isSuccess = false;
    }
    if (_isSuccess) {
      showDialog(context: context, builder: (context) => NotifyDialog(S.of(context).success, S.of(context).groupPosted, "OK"))
          .then((value) {
        Navigator.pop(context, true);
      });
    }
    setState(() {
      _isPosting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _group = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).postItem,
          style: Theme.of(context).textTheme.headline2,
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: Avatar(AccessInfo().userInfo.avatarUrl, 24),
                title: Row(
                  children: [
                    Text(
                      AccessInfo().userInfo.fullName,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Icon(Icons.arrow_right),
                    Expanded(
                      child: Text(
                        _group.groupName,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  S.of(context).group,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(10)),
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _images.length + 1,
                cacheExtent: 10000,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return AddPhoto(onPress: pickImages);
                  } else {
                    ImageData image = _images[index - 1];
                    return ImageView(image, () {
                      setState(() {
                        _images.removeAt(index - 1);
                      });
                    });
                  }
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              minLines: 8,
              maxLines: 20,
              readOnly: _isPosting,
              validator: Validator.validateContent,
              controller: _contentController,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "${S.of(context).content}...",
                filled: true,
                fillColor: Theme.of(context).backgroundColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (_isPosting)
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Center(child: MiniIndicator()),
              ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: ElevatedButton(
                onPressed: onPost,
                child: Text(S.of(context).post),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
