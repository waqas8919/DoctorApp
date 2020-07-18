

import 'package:doctorapp/Pages/AppointmentList.dart';
import 'package:doctorapp/Pages/BookAppointment.dart';
import 'package:doctorapp/Pages/DocAppointment.dart';
import 'package:doctorapp/TeleConsult/TeleMainScreen.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/hotel_app_theme.dart';
import 'package:doctorapp/model/AppointmentTypeClass.dart';
import 'package:doctorapp/model/DocAppointmentModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:intl/intl.dart';
import 'package:doctorapp/navigation_home_screen.dart';
import 'package:flutter/material.dart';

class ViewAppointmentScreen extends StatefulWidget {
  final String appBarTitle;
  final DocAppointmentModel note;

  ViewAppointmentScreen(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _FiltersAppointmentState(this.note, this.appBarTitle);
  }
}

class _FiltersAppointmentState extends State<ViewAppointmentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DBHelper helper = DBHelper();
  List<DocAppointmentModel> SearchList;
  DateTime _dateTime = DateTime.now();
  String appBarTitle;
  String Name;

  DocAppointmentModel note;
  DoctorInfoModel docinfo;
  bool showSlot = false;


  _FiltersAppointmentState(this.note, this.appBarTitle);


  TextEditingController AppointmentTime = new TextEditingController();
  TextEditingController AppointmentType = new TextEditingController();
  TextEditingController NoteText = new TextEditingController();

  List<AppointmentTypeClass> _Type = AppointmentTypeClass.getAppointments();
  List<DropdownMenuItem<AppointmentTypeClass>> _dropdownMenuItems;
  AppointmentTypeClass _selectedAppointmentType;

  Iterable<TimeOfDay> getTimes(
      TimeOfDay startTime, TimeOfDay endTime, Duration step) sync* {
    var hour = startTime.hour;
    var minute = startTime.minute;

    do {
      yield TimeOfDay(hour: hour, minute: minute);
      minute += step.inMinutes;
      while (minute >= 60) {
        minute -= 60;
        hour++;
      }
    } while (hour < endTime.hour ||
        (hour == endTime.hour && minute <= endTime.minute));
  }
  List<DropdownMenuItem<AppointmentTypeClass>> buildDropdownMenuItems(List type) {
    List<DropdownMenuItem<AppointmentTypeClass>> items = List();
    for (AppointmentTypeClass appointtype in type) {
      items.add(
        DropdownMenuItem(
          value: appointtype,
          child: Text(appointtype.name),
        ),
      );
    }
    return items;
  }
  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_Type);
    _selectedAppointmentType = _dropdownMenuItems[0].value;
    super.initState();
  }

  onChangeDropdownItem(AppointmentTypeClass selectedAppointType) {
    setState(() {
      _selectedAppointmentType = selectedAppointType;
      //UpdateAppointmentType();
    });
  }

  @override
  Widget build(BuildContext context) {
    NoteText.text = note.note;
    Name = note.doctorname;
    AppointmentTime.text = note.slottime;
    AppointmentType.text = note.appointmentType;
    return WillPopScope(
      onWillPop: () {
        // Write some code to control things, when user press Back navigation button in device navigationBar
        moveToLastScreen();
      },
      child: Container(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getDoctorNameUI(), // meter select
                      const Divider(
                        height: 1,
                      ),
                      getAppointmentTypeUI(),
                      const Divider(
                        height: 1,
                      ),
                      getAppointmentTimeUI(),
                      const Divider(
                        height: 1,
                      ),
                      getNoteUI(),
                      SizedBox(
                        height: 5,
                      ),
                      getButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
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
                                        'Do you Want to Cancel?')),
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
                                _delete();
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => TeleConsultScreen()));// delete renter information
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
              //_delete();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              navigateToDetail(note, 'Appointment Details');   // update renter details
            },
            child: Text(
              "Re-Schedule",
              style: TextStyle(color: Colors.white),
            ),
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
        ],
      ),
    );
  }

  void navigateToDetail(DocAppointmentModel note, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookAppointmentScreen(note, title);
    }));


    List<RaisedButton> buttonsList = new List<RaisedButton>();

    List<Widget> _buildButtonsWithNames() {
      final startTime = TimeOfDay(hour: 9, minute: 0);
      final endTime = TimeOfDay(hour: 15, minute: 0);
      final step = Duration(minutes: 20);

      final times = getTimes(startTime, endTime, step)
          .map((tod) => tod.format(context))
          .toList();

      for (int i = 0; i < times.length; i++) {
        buttonsList.add(RaisedButton(
            onPressed: () {
              AppointmentTime.text = times[i] + ' - ' + times[i + 1];
            },
            color: HotelAppTheme.buildLightTheme().primaryColor,
            child: Text(times[i])));
      }
      return buttonsList;
    }

    Widget Show() {
      return Container();
    }

    Widget getSlotTimeUI() {
      return Padding(
          padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Wrap(children: _buildButtonsWithNames()))
            ],
          ));
    }


    Widget getSlots() {
      return Padding(
          padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
          child: Wrap(
            spacing: 3,
            children: <Widget>[
              RaisedButton(onPressed: (){AppointmentTime.text = "9:00" + " - " + "9:20";},child: Text("9:00"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "9:20" + " - " + "9:40";},child: Text("9:20"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "9:40" + " - " + "10:00";},child: Text("9:40"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "10:00" + " - " + "10:20";},child: Text("10:00"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "10:20" + " - " + "10:40";},child: Text("10:20"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "10:40" + " - " + "11:00";},child: Text("10:40"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "11:00" + " - " + "11:20";},child: Text("11:00"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "11:20" + " - " + "11:40";},child: Text("11:20"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "11:40" + " - " + "12:00";},child: Text("11:40"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "12:00" + " - " + "12:20";},child: Text("12:00"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "12:20" + " - " + "12:40";},child: Text("12:20"),color: HotelAppTheme.buildLightTheme().primaryColor,),
              RaisedButton(onPressed: (){AppointmentTime.text = "12:40" + " - " + "13:00";},child: Text("12:40"),color: HotelAppTheme.buildLightTheme().primaryColor,)
            ],
          )
      );
    }


    updateDoctorName() {
      note.doctorname = Name;
    }

    UpdateAppointmentType() {
      note.appointmentType = _selectedAppointmentType.name;
    }

    updateAppointmentTime() {
      note.appointmenttime = AppointmentTime.text;
    }

    updateAppointmentDate() {
      note.appdate = _dateTime.toString();
    }

    updateNote() {
      note.note = NoteText.text;
    }


    void _showAlertDialog(String title, String message) {
      AlertDialog alertDialog = AlertDialog(
        title: Text(title),
        content: Text(message),
      );
      showDialog(context: context, builder: (_) => alertDialog);
    }

    void _showSnackBar(message) {
      final snackBar = new SnackBar(
        content: new Text(message),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

void moveToLastScreen() {
  Navigator.pop(context, true);
}
  void moveToPreviousScreen() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => DoctorAppointmentInfoList()));
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
                  'Doctor Appointment',
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

  Widget getDoctorNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 18, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Doctor Name: ",style: TextStyle(fontSize: 17),),
          Text(Name,style: TextStyle(fontSize: 17),),
        ],
      ),
    );
  }

  Widget getAppointmentTimeUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 18, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Appointment Time :",style: TextStyle(fontSize: 17),),
          Text(AppointmentTime.text,style: TextStyle(fontSize: 17),),
        ],
      ),
    );
  }

  Widget getAppointmentTypeUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Appointment Type :",style: TextStyle(fontSize: 17),),
          Text(AppointmentType.text,style: TextStyle(fontSize: 17),),
        ],
      ),
    );
  }

  Widget getNoteUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
            const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
            child: Text(
              'Note',
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
                    Radius.circular(5.0),
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
                    controller: NoteText,
                    maxLines: 3,
                    enabled: false,
                    onChanged: (String txt) {
                      //showSlot = false;
                      //updateNote();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Note',
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

  void _save() async {
    DateTime insertdate = DateTime.now();
    note.insertdatetime = DateFormat.yMMMd().format(insertdate);
    note.slottime = AppointmentTime.text;
    note.appdate = DateFormat.yMMMd().format(_dateTime);

    int result;

    if (note.appointmentid != null) {
      // Case 1: Update operation
      result = await helper.updateDoctorAppointmentInfo(note);
    } else {
      // Case 2: Insert Operation
      result = await helper.insertAppointmentDoctorInfo(note);
      moveToLastScreen();
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Appointment Booked Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Booking Doctor Appointment');
    }

  }

  void _delete()async {
    moveToPreviousScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.appointmentid == null) {
      _showAlertDialog('Status', 'Try Again Problem Re-Scheduling');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteDoctorAppointmentInfo(note.appointmentid);
    if (result != 0) {
      _showAlertDialog('Status', 'Appointment Cancelled');
    } else {
      _showAlertDialog(
          'Status', 'Error Occured while Re-Scheduling');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

}
