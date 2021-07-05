import 'package:flutter/material.dart';
import 'package:secondhand_sharing/generated/l10n.dart';
import 'package:secondhand_sharing/models/comment/comment.dart';
import 'package:secondhand_sharing/models/user/access_info/access_info.dart';
import 'package:secondhand_sharing/services/api_services/post_services/post_services.dart';
import 'package:secondhand_sharing/utils/time_ago/time_ago.dart';
import 'package:secondhand_sharing/widgets/avatar/avatar.dart';
import 'package:secondhand_sharing/widgets/mini_indicator/mini_indicator.dart';

class CommentBottomSheet extends StatefulWidget {
  final int postId;

  CommentBottomSheet(this.postId);

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  List<Comment> _comments = [];
  int _pageSize = 10;
  int _pageNumber = 1;
  bool _isEnd = false;
  bool _isLoading = true;
  bool _isPosting = false;
  var _commentController = TextEditingController();

  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    var comments = await PostServices.getComments(widget.postId, _pageNumber, _pageSize);

    setState(() {
      if (comments.length < _pageSize) _isEnd = true;
      _comments.addAll(comments);
      _isLoading = false;
    });
  }

  Future<void> comment() async {
    if (_commentController.text == "") return;
    setState(() {
      _isPosting = true;
    });
    var comment = await PostServices.postComment(widget.postId, _commentController.text);
    if (comment != null) {
      setState(() {
        comment.avatarUrl = AccessInfo().userInfo.avatarUrl;
        comment.postByAccountName = AccessInfo().userInfo.fullName;
        _comments.insert(0, comment);
        _commentController.text = "";

        _isPosting = false;
      });
    }
  }

  @override
  void initState() {
    print(widget.postId);
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.9,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            S.of(context).comment,
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                reverse: true,
                children: [
                  if (_comments.isEmpty && !_isLoading)
                    Container(
                      height: screenSize.height * 0.5,
                      child: Center(
                          child: Text(
                        S.of(context).noAnyComments,
                        style: Theme.of(context).textTheme.headline4,
                      )),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  ..._comments.map((comment) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: Avatar(comment.avatarUrl, 20),
                            horizontalTitleGap: 10,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  margin: EdgeInsets.zero,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comment.postByAccountName,
                                          style: Theme.of(context).textTheme.headline3,
                                        ),
                                        Text(comment.content),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 2),
                            child: Text(
                              "${TimeAgo.parse(comment.postTime, locale: Localizations.localeOf(context).languageCode)}",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          )
                        ],
                      )),
                  if (_isLoading)
                    Container(
                      height: screenSize.height * 0.1,
                      child: Center(
                        child: MiniIndicator(),
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!_isEnd && !_isLoading)
                    ListTile(
                      onTap: () {
                        _pageNumber++;
                        loadData();
                      },
                      title: Text(
                        "${S.of(context).seeMore}...",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.zero,
              child: TextField(
                  controller: _commentController,
                  maxLines: 4,
                  minLines: 1,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "${S.of(context).comment}...",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 20, top: 14, right: 12, bottom: 12),
                    suffixIcon: IconButton(
                      splashRadius: 24,
                      icon: _isPosting ? MiniIndicator() : Icon(Icons.send),
                      onPressed: comment,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
