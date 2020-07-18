import 'package:doctorapp/Pages/DocAppointment.dart';
import 'package:doctorapp/Pages/FamilyPage.dart';
import 'package:doctorapp/Pages/GoldPage.dart';
import 'package:doctorapp/Pages/PlatinumPage.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/PaymentModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../hotel_app_theme.dart';
import '../navigation_home_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final String appBarTitle;

  SubscriptionScreen(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _MainPageState(this.appBarTitle);
  }
}

class _MainPageState extends State<SubscriptionScreen> {
  String appBarTitle;
  DBHelper helper = DBHelper();
  List<PaymentModel> payment;
  String SubscribeType = 'Family';
  String SubscribeType1 = 'Gold';
  String SubscribeType2 = 'Platinum';

  _MainPageState(this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    if (payment == null) {
      payment = List<PaymentModel>();
      updateListView(); // get payment list
    }
    var j =
        payment.where((element) => element.subtype == SubscribeType).toList();
    var k =
        payment.where((element) => element.subtype == SubscribeType1).toList();
    var l =
        payment.where((element) => element.subtype == SubscribeType2).toList();
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          // actions: <Widget>[
          //   Container(
          //     margin: EdgeInsets.only(right: 0.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: <Widget>[
          //         FlatButton.icon(
          //             onPressed: () {
          //               Navigator.push(
          //                   context,
          //                   new MaterialPageRoute(
          //                       builder: (context) => NavigationHomeScreen()));
          //             },
          //             icon: Icon(Icons.arrow_back),
          //             label: Text("Back")),
          //         //Text("asds",style: TextStyle(color: Colors.black),),
          //       ],
          //     ),
          //   )
          // ],
          title: Text('Subscription',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0)),
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _PackageView(
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: j.length > 0
                            ? Material(
                                borderRadius: BorderRadius.circular(24.0),
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Image.asset(
                                    'res/family.png',
                                    fit: BoxFit.fill,
                                  ),
                                )))
                            : k.length > 0
                                ? Material(
                                    borderRadius: BorderRadius.circular(24.0),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'res/gold.png',
                                        fit: BoxFit.fill,
                                      ),
                                    )))
                                : l.length > 0
                                    ? Material(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Image.asset(
                                            'res/Platinum.png',
                                            fit: BoxFit.fill,
                                          ),
                                        )))
                                    : Material(
                                        borderRadius:
                                            BorderRadius.circular(24.0),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Image.asset(
                                            'assets/images/n.png',
                                            fit: BoxFit.fill,
                                          ),
                                        ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                  j.length > 0
                                      ? 'you Have already Subscribed ' +
                                          SubscribeType +
                                          ' Package'
                                      : k.length > 0
                                          ? 'you Have already Subscribed ' +
                                              SubscribeType1 +
                                              ' Package'
                                          : l.length > 0
                                              ? 'you Have already Subscribed ' +
                                                  SubscribeType2 +
                                                  ' Package'
                                              : 'you havent subscribed for any Package',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0)),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
            ), // Search car clicked in dashboard

            _FamilyClick(
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                'res/family.png',
                                fit: BoxFit.fill,
                              ),
                            ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Family',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0)),
                              Text('RM 27',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.0))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              FamilyScreen("Subscriptions")));
                                },
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                    )),
                                child: Text("View Plan"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ), // Search car clicked in dashboard

            _GoldClick(
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                'res/gold.png',
                                fit: BoxFit.fill,
                              ),
                            ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Gold',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0)),
                              Text('RM 118',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.0))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              GoldScreen("Subscriptions")));
                                },
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                    )),
                                child: Text("View Plan"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ), // Favorite car card in dashboard
            _PlatinumClick(
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Image.asset(
                                'res/Platinum.png',
                                fit: BoxFit.fill,
                              ),
                            ))),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Platinum',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.0)),
                              Text('RM 188',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10.0))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              PlatinumScreen("Subscriptions")));
                                },
                                color: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                    )),
                                child: Text("View Plan"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ), //post a car card in dashboard

            // listing car in dashboard
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 70.0),
            StaggeredTile.extent(1, 240.0),
            StaggeredTile.extent(1, 240.0),
            StaggeredTile.extent(2, 240.0),
          ],
        ));
  }

  Widget _PackageView(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {},
            child: child));
  }

  Widget _FamilyClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {},
            child: child));
  }

  void SearcResults() async {}

  Widget _GoldClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {},
            child: child));
  }

  Widget _PlatinumClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null ? () => onTap() : () {},
            child: child));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  int count = 0;
  void updateListView() {
    var dbFuture = helper.initDb();
    dbFuture.then((database) {
      Future<List<PaymentModel>> noteListFuture = helper.getPaymentMethodList();
      noteListFuture.then((noteList) {
        setState(() {
          this.payment = noteList;
          this.count = noteList.length;
        });
      });
    });
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
}
