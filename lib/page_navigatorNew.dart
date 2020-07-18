import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/TeleConsult/Auth/auth.dart';
import 'package:doctorapp/TeleConsult/video_room.dart';
import 'package:doctorapp/TeleModel/user.dart';
import 'package:flutter/material.dart';
import 'TeleConsult/chat_page.dart';
import 'TeleConsult/groups_page.dart';

import 'package:provider/provider.dart';

class PageNavigatorNew extends StatefulWidget {
  PageNavigatorNew();

  @override
  PageNavigatorStateNew createState() => PageNavigatorStateNew();
}

class PageNavigatorStateNew extends State<PageNavigatorNew> {
  String selectedGroupID;
  String selectedGroupName;
  PageController controller = PageController(initialPage: 0);

  Firestore _firestore = Firestore.instance;
  AuthService _auth = AuthService();

  String newUsername;

  bool dialogueUp = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    // Enter username/image dialogue
    _firestore.collection('Users').document(user.uid).get().then((doc) {
      if (doc.exists && doc.data['username'] != null) {
        user.userName = doc.data['username'];
      } else if (!dialogueUp) {
        dialogueUp = true;
        print("user does not exist");
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            elevation: 24.0,
            title: Text(
              "Choose Username",
              style: TextStyle(color: Colors.lightBlue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Username',
                    ),
                    onChanged: (value) {
                      newUsername = value;
                    },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Done"),
                onPressed: () {
                  _firestore.collection("Users").document(user.uid).setData({
                    'username': newUsername,
                  });
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  user.userName = newUsername;
                  User u = Provider.of<User>(context);
                },
              ),
            ],
          ),
          barrierDismissible: true,
        );
      }
    });

    // main PageView, contains group page, chat page, and video room
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: <Widget>[
        //Page 1: Group Selection
        GroupsPage(this),
        //Page 2: Text Chat
        Container(
          child: ChatPage(
            groupId: selectedGroupID,
            groupName: selectedGroupName,
            user: user,
            pageNavigatorState: this,
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(),
            ),
            shadows: [new BoxShadow(blurRadius: 5.0)],
          ),
        ),
        //Page 3: Video Room
        Container(
          child: VideoRoom(
            groupId: selectedGroupID == null ? "test" : selectedGroupID,
          ),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(),
            ),
            shadows: [new BoxShadow(blurRadius: 5.0)],
          ),
        ),
      ],
    );
  }

  // Used in other pages to set the selected page of the PageView
  void setPage(int page) {
    controller.animateToPage(page,
        duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
  }
}
