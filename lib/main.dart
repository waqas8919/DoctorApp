import 'package:doctorapp/Pages/Login.dart';
import 'package:flutter/material.dart';

import 'TeleConsult/Auth/login.dart';
import 'TeleConsult/TeleMainScreen.dart';
import 'navigation_home_screen.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return MaterialApp
      (
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TeleConsultScreen(),    //   Navigate to Main Dashboard Screen
      //home: MainFireBase(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
