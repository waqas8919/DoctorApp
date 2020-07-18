import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/TeleConsult/Auth/auth.dart';
import 'package:doctorapp/TeleModel/user.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/ProfileModelClass.dart';
import 'package:flutter/material.dart';
import '../navigation_home_screen.dart';
import 'groups_page.dart';
import 'chat_page.dart';
import 'video_room.dart';
import 'package:provider/provider.dart';

class PageNavigator extends StatefulWidget {
  PageNavigator();

  @override
  PageNavigatorState createState() => PageNavigatorState();
}

class PageNavigatorState extends State<PageNavigator> {
  AuthService _auth = AuthService();
  DBHelper helper = DBHelper();
  ProfileInfoModel note;

  String selectedGroupID;
  String selectedGroupName;
  PageController controller = PageController(initialPage: 0);

  Firestore _firestore = Firestore.instance;

  String newUsername;

  bool dialogueUp = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    // Enter username/image dialogue
    _firestore.collection('Users').document(user.uid).get().then((doc) {
      if (doc.exists && doc.data['username'] != null) {
        print("user exists");
        print("username: " + doc.data['username']);
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
              "You Must Enter Username",
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
                },
              ),
            ],
          ),
          barrierDismissible: true,
        );
      }
    });

    // main PageView, contains group page, chat page, and video room
    return NavigationHomeScreen();
  }

  // Used in other pages to set the selected page of the PageView
  void setPage(int page) {
    controller.animateToPage(page,
        duration: Duration(milliseconds: 250), curve: Curves.bounceInOut);
  }
}
