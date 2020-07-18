import 'package:doctorapp/Pages/PaymentShow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/PaymentModel.dart';
import 'package:flutter/painting.dart';
import '../hotel_app_theme.dart';
import 'PaymentMethod.dart';

class PayMethodList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewPrefListState();
  }
}

class NewPrefListState extends State<PayMethodList> {
  DBHelper databaseHelper = DBHelper();
  List<PaymentModel> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<PaymentModel>();
      updateListView(); // get payment list
    }

    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(child: getNoteListView())
            ],
          )),
    );
  }

  ListView getNoteListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            this.noteList[position].subtype,
                            style: TextStyle(
                                fontSize: 23, fontWeight: FontWeight.w500),
                          ),
                          Text('RM ' + this.noteList[position].amount),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('Transaction Date: '),
                          Text(this.noteList[position].paydate),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text('Status: '),
                          Text(this.noteList[position].status),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 5.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                navigateToDetail(this.noteList[position],
                                    'Payment Details'); // update payment details
                              },
                              icon: Icon(
                                Icons.delete,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor,
                                size: 25,
                              ),
                              label: Text(
                                'View Details',
                                style: TextStyle(fontSize: 15),
                              )),
                          FlatButton.icon(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Select You Options'),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      child: Text(
                                                          'Do you Want to delete?')),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text('Yes'),
                                                onPressed: () {
                                                  _delete(
                                                      context,
                                                      this.noteList[
                                                          position]); // delete payment details
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('No'),
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor,
                                size: 25,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(fontSize: 15),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, PaymentModel note) async {
    int result = await databaseHelper.deletePaymentMethod(note.id);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(PaymentModel note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ShowCreditCardPage(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    var dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<PaymentModel>> noteListFuture =
          databaseHelper.getPaymentMethodList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
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
                  'Payment Method',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
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
