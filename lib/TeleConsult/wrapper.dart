import 'package:doctorapp/TeleConsult/Auth/logsignin_page.dart';
import 'package:doctorapp/TeleModel/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Wrapper extends StatelessWidget {
  final Widget homePage;

  Wrapper({this.homePage});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    
    //Checking if the user is logged in or not
    if(user == null) {
      return LogsignIn();
    }else{
      print(user.uid);
      return homePage;
    }
  }
}