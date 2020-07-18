import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User{
  String email;
  final String uid;
  String userName;
  String name;
  String contact;
  String address;

  //This is to check if the user has its unique user name from firebase
  User({this.uid, this.email, this.userName, this.name,this.contact,this.address});
}

String formatTimeOfDay(TimeOfDay tod) {
  final now = new DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
  final format = DateFormat.jm();  //"6:00 AM"
  return format.format(dt);
}

class UserModel {
  final int id; 
  final String iconPath;
  final String userName;
  final String name;
  final String contact;
  final String address;

  UserModel({this.id, this.iconPath, this.userName,this.name,this.contact,this.address});
}