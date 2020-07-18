import 'package:flutter/material.dart';




class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;


  void getCarPostcount() async {

  }
  void getMyBookingcount() async {

  }
  void getRentercount() async {

  }
  void getPaymentcount() async {

  }
  void getFavoritecount() async {


  }
  final List<Widget> _children = [
    Home(),
    Home(),
    Home(),
    Home(),
    Home(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car, color: Colors.black),
            title: Text(
              'Posted Cars',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark, color: Colors.black),
            title: Text(
              'My Bookings',
              style: TextStyle(color: Colors.black),
            ),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.black),
              title: Text(
                'Renter Info',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.payment, color: Colors.black),
              title: Text(
                'Payment Method',
                style: TextStyle(color: Colors.black),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, color: Colors.black),
              title: Text(
                'My Favorite Car',
                style: TextStyle(color: Colors.black),
              )),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      if(index == 0) {
        getCarPostcount();
      }else if(index == 1){
        getMyBookingcount();
      }else if(index == 2){
        getRentercount();
      }else if(index == 3){
        getPaymentcount();
      }else if(index == 4){
        getFavoritecount();
      }
      _currentIndex = index;
    });
  }
  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
