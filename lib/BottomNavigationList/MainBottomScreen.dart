import 'package:flutter/material.dart';
import 'home_widget.dart';


class MainBottomBar extends StatefulWidget {
  @override
  _MainBottomBarState createState() => _MainBottomBarState();
}

class _MainBottomBarState extends State<MainBottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Home(),
    );
  }
}

