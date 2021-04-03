import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                foregroundImage: AssetImage(
                  "assets/images/person.png",
                ),
              ),
              title: Container(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("Share your item"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
