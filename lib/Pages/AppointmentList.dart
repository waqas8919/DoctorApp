import 'package:doctorapp/Pages/AppointmentView.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/DocAppointmentModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../hotel_app_theme.dart';

class DoctorAppointmentInfoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDocListState();
  }
}

class NewDocListState extends State<DoctorAppointmentInfoList> {
  DBHelper databaseHelper = DBHelper();
  List<DocAppointmentModel> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<DocAppointmentModel>();
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
                        children: <Widget>[
                          Text("Appointment With: "),
                          Text(this.noteList[position].doctorname != null ? this.noteList[position].doctorname : ""),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Appointment Date"),
                          Text(this.noteList[position].appdate != null ? this.noteList[position].appdate : ""),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Appointment Time"),
                          Text(this.noteList[position].slottime != null ? this.noteList[position].slottime : ""),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Text("Notes"),
                          Text(this.noteList[position].note != null ? this.noteList[position].note : ""),
                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          FlatButton.icon(
                              onPressed: () {
                                navigateToDetail(this.noteList[position], 'Appointment Details');   // update renter details
                              },
                              icon: Icon(
                                Icons.edit,
                                color: HotelAppTheme.buildLightTheme()
                                    .primaryColor,
                                size: 15,
                              ),
                              label: Text(
                                'View Details',
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

  void _delete(BuildContext context, DocAppointmentModel note) async {
    int result = await databaseHelper.deleteDoctorAppointmentInfo(note.appointmentid);
    if (result != 0) {
      updateListView();
    }
  }

  void navigateToDetail(DocAppointmentModel note, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ViewAppointmentScreen(note, title);
    }));

    if (result == true) {
      updateListView();
    }
    Navigator.of(context, rootNavigator: true).pop();
  }

  void updateListView() {
    var dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<DocAppointmentModel>> noteListFuture = databaseHelper.getDoctorAppointmentInfoList();
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
                  'Appointment History',
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
