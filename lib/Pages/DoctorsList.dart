import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Pages/DocPageLabel.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hotel_app_theme.dart';
import '../navigation_home_screen.dart';
import 'AuthPage.dart';
import 'DoctorPage.dart';

class DoctorInfoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDocListState();
  }
}

class NewDocListState extends State<DoctorInfoList> {
  DBHelper databaseHelper = DBHelper();
  List<DoctorInfoModel> noteList;
  Firestore _firestore = Firestore.instance;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<DoctorInfoModel>();
      updateListView();  // get renter information
    }

    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Padding(padding: EdgeInsets.only(bottom: 15.0)),
              getAddDoctorButton(),
              Expanded(child: getNoteListView())
            ],
          )),
    );
  }
  Widget getAddDoctorButton() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16, right: 16, bottom: 16, top: 0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: HotelAppTheme.buildLightTheme().primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
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
              //_save();  //  add renter information
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => DoctorInfoScreen(
                          DoctorInfoModel("","","","","","","","","",""),
                          "Doctors List")));
            },
            child: Center(
              child: Text(
                'Add Doctor',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
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
                        children: <Widget>[
                          Text(this.noteList[position].firstname + ' ' + this.noteList[position].lastname),
                          Text(
                                this.noteList[position].status),

                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                           Text(this.noteList[position].email),
                          Text(this.noteList[position].gender),

                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                navigateToDetail(this.noteList[position], 'Doctor Information');   // update renter details
                              },
                              icon: Icon(
                                Icons.edit,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor,
                                size: 20,
                              ),
                              label: Text(
                                'View',
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

                                                  _firestore.collection('Groups').getDocuments().then((snapShote) => {
                                                    for(DocumentSnapshot doc in snapShote.documents){
                                                     doc.reference.delete(),
                                                    }
                                                  });
                                                  _delete(context,
                                                      this.noteList[position]);  // delete renter information
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
                                size: 20,
                              ),
                              label: Text(
                                'Delete',
                                style: TextStyle(fontSize: 15),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            onTap: () {

            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, DoctorInfoModel note) async {
    int result = await databaseHelper.deleteDoctorInfo(note.doctorid);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(DoctorInfoModel note, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DoctorPageLabel(note, title);
    }));

    if (result == true) {
      updateListView();
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  void updateListView() {
    var dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<DoctorInfoModel>> noteListFuture = databaseHelper.getDoctorInfoList();
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
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => NavigationHomeScreen()));
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
                  'Doctor Info',
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
            ),
          ],
        ),
      ),
    );
  }
}
