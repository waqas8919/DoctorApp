import 'dart:math';

import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/AuthenticateModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:doctorapp/model/GenderClass.dart';
import 'package:doctorapp/model/StatusClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hotel_app_theme.dart';
import '../navigation_home_screen.dart';
import 'DoctorsList.dart';

class AuthInfoScreen extends StatefulWidget {
  final String appBarTitle;
  final AuthModel docinfo;

  AuthInfoScreen(this.docinfo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _DoctorInfoState(this.docinfo, this.appBarTitle);
  }
}

class _DoctorInfoState extends State<AuthInfoScreen> {
  DBHelper helper = DBHelper();
  AuthModel note;
  DoctorInfoModel Docdata;
  int count = 0;
  String appBarTitle;
  int doctorsid;
  String firstname;
  String lastname;
  String gender;
  String phoneno;
  String email;
  String hospital;
  String status;
  _DoctorInfoState(this.note, this.appBarTitle);

  TextEditingController AuthenticateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    generateRandomNumber();
    doctorsid = note.docid;
    firstname = note.firstname;
    lastname = note.lastname;
    gender = note.gender;
    phoneno = note.phone;
    email = note.email;
    hospital = note.hospital;
    status = note.status;
    print("Name is : " + status);
    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Container(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getAuthenticateUI(),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: HotelAppTheme.buildLightTheme().primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),

                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _save();  //  add renter information
                      },
                      child: Center(
                        child: Text(
                          'Authenticate',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget getAuthenticateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
            child: Text(
              'Authenticate Code',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    controller: AuthenticateController,
                    onChanged: (String txt) {
                      updateauth();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Authenticate Code',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void  generateRandomNumber() {

    var random = new Random();
    // Printing Random Number between 1 to 100000000 on Terminal Window.
    AuthenticateController.text = random.nextInt(100000000).toString();
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  appBarTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() async{
    await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  void updateauth() {
    note.authcode = AuthenticateController.text;
  }

// this function add renter information
  void _save() async {
    int result;

    if (note.authid != null) {
      // Case 1: Update operation
      result = await helper.updateAuthInfo(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertAuthInfo(note);
      moveToLastScreen();
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Authentication code Added Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Authentication code');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.authid == null) {
      _showAlertDialog('Status', 'No Authentication Code  was deleted');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteAuthInfo(note.authid);
    if (result != 0) {
      _showAlertDialog('Status', 'Authentication Code Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Authentication Code');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
