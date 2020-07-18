import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/AppointmentTypeClass.dart';
import 'package:doctorapp/model/DocAppointmentModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../hotel_app_theme.dart';
import 'package:intl/intl.dart';

class AppointmentScreen extends StatefulWidget {
  final String appBarTitle;
  final DocAppointmentModel note;

  AppointmentScreen(this.note, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _FiltersAppointmentState(this.note, this.appBarTitle);
  }
}

class _FiltersAppointmentState extends State<AppointmentScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DBHelper helper = DBHelper();
  List<DocAppointmentModel> SearchList;
  DateTime _dateTime = DateTime.now();
  String appBarTitle;
  String Name;

  DocAppointmentModel note;
  DoctorInfoModel docinfo;
  List<DoctorInfoModel> docs;
  bool showSlot = false;


  _FiltersAppointmentState(this.note, this.appBarTitle);

  TextEditingController AppointmentTime = new TextEditingController();
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

  List<DropdownMenuItem<AppointmentTypeClass>> buildDropdownMenuItems(
      List type) {
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
      UpdateAppointmentType();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (docs == null) {
      docs = List<DoctorInfoModel>();
      updateListView();  // get renter information
    }
    NoteText.text = note.note;
    Name = note.doctorname;
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
                      getDateUI(),
                      const Divider(
                        height: 1,
                      ),
                      showSlot == true ? getSlots() : Show(),
                      const Divider(
                        height: 1,
                      ),
                      getNoteUI(),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 16, top: 8),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: HotelAppTheme.buildLightTheme().primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
                      highlightColor: Colors.transparent,
                      onTap: () {
                        //_save();
                        if (Name == '') {
                          _showAlertDialog("Status", "Select Doctor");
                        } else if (_selectedAppointmentType.name == 'Select Appointment Type') {
                          _showAlertDialog("Status", "Select Appointment Type");
                        } else if (AppointmentTime.text == '') {
                          _showAlertDialog("Status", "Pick Appointment Time");
                        } else {
                          _save();
                        }
                        // add search preferences
                        //_showSnackBar("Preferences Saved Successfully!");
                      },
                      child: Center(
                        child: Text(
                          'Request',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget getDoctorNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Select Doctor                         "),
          FutureBuilder<List<DoctorInfoModel>>(
              future: helper.getDoctorNameData(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<DoctorInfoModel>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return DropdownButton<DoctorInfoModel>(
                    items: snapshot.data
                        .map((user) => DropdownMenuItem<DoctorInfoModel>(
                              child: Text(user.firstname + ' ' + user.lastname),
                              value: user,
                            ))
                        .toList(),
                    onChanged: (DoctorInfoModel value) {
                      setState(() {
                        docinfo = value;
                        Name = value.firstname + ' ' + value.lastname;
                        updateDoctorName();
                      });
                    },
                    isExpanded: false,
                    //value: docinfo,
                    hint: Text(Name),
//                  docinfo != null ? Text(
//                      Name) : Text("No Doctor selected"),
                    );
              }),
        ],
      ),
    );
  }

  Widget getAppointmentTypeUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(" Appointment Type :"),
          SizedBox(
            height: 20.0,
          ),
          DropdownButton(
            value: _selectedAppointmentType,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
          ),
        ],
      ),
    );
  }


  Widget getDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          RaisedButton(
            child: Text('Pick a date'),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate:
                          _dateTime == null ? DateTime.now() : _dateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2021))
                  .then((date) {
                setState(() {
                  _dateTime = date;
                  showSlot = true;
                  updateAppointmentDate();
                });
              });
            },
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
          Text(_dateTime == null
              ? 'Nothing has been picked yet'
              : DateFormat.yMMMd().format(_dateTime)),
        ],
      ),
    );
  }

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

  Widget getAppointmentTimeUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HotelAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
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
                    controller: AppointmentTime,
                    focusNode: FocusNode(),
                    enableInteractiveSelection: false,
                    enabled: false,
                    onChanged: (String txt) {
                      updateAppointmentTime();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Appointment Time',
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
                    onChanged: (String txt) {
                      //showSlot = false;
                      updateNote();
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
  bool pressAttention = true;
  bool pressAttention1 = true;
  bool pressAttention2 = true;
  bool pressAttention3 = true;
  bool pressAttention4 = true;
  bool pressAttention5 = true;
  bool pressAttention6 = true;
  bool pressAttention7 = true;
  bool pressAttention8 = true;
  bool pressAttention9 = true;
  bool pressAttention10 = true;
  bool pressAttention11 = true;


  Widget getSlots() {
    return Padding(
        padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
        child: Wrap(
          spacing: 3,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention = !pressAttention;
                  pressAttention1  = true;
                  pressAttention2  = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;
                });
                AppointmentTime.text = "9:00" + " - " + "9:20";
              },
              child: Text("9:00"),
              color: pressAttention
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention = true;
                  pressAttention1 = !pressAttention1;
                  pressAttention2  = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;
                });
                AppointmentTime.text = "9:20" + " - " + "9:40";
              },
              child: Text("9:20"),
              color: pressAttention1
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = !pressAttention2;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "9:40" + " - " + "10:00";
              },
              child: Text("9:40"),
              color: pressAttention2
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = !pressAttention3;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;
//                  print("Checking" + _selectedAppointmentType.name);

                });
                AppointmentTime.text = "10:00" + " - " + "10:20";
              },
              child: Text("10:00"),
              color: pressAttention3
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = !pressAttention4;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "10:20" + " - " + "10:40";
              },
              child: Text("10:20"),
              color: pressAttention4
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = !pressAttention5;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "10:40" + " - " + "11:00";
              },
              child: Text("10:40"),
              color: pressAttention5
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = !pressAttention6;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "11:00" + " - " + "11:20";
              },
              child: Text("11:00"),
              color: pressAttention6
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = !pressAttention7;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "11:20" + " - " + "11:40";
              },
              child: Text("11:20"),
              color: pressAttention7
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = !pressAttention8;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "11:40" + " - " + "12:00";
              },
              child: Text("11:40"),
              color: pressAttention8
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = !pressAttention9;
                  pressAttention10 = true;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "12:00" + " - " + "12:20";
              },
              child: Text("12:00"),
              color: pressAttention9
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = !pressAttention10;
                  pressAttention11 = true;

                });
                AppointmentTime.text = "12:20" + " - " + "12:40";
              },
              child: Text("12:20"),
              color: pressAttention10
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.blue : Colors.blue[900],
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  pressAttention  = true;
                  pressAttention1  = true;
                  pressAttention2 = true;
                  pressAttention3  = true;
                  pressAttention4  = true;
                  pressAttention5  = true;
                  pressAttention6  = true;
                  pressAttention7  = true;
                  pressAttention8  = true;
                  pressAttention9  = true;
                  pressAttention10 = true;
                  pressAttention11 = !pressAttention11;

                });
                AppointmentTime.text = "12:40" + " - " + "13:00";
              },
              child: Text("12:40"),
              color: pressAttention11
                  ? HotelAppTheme.buildLightTheme().primaryColor
                  : _selectedAppointmentType.name == 'TeleConsultation' ? Colors.lightBlueAccent : Colors.blue[900],
            )
          ],
        ));
  }

  void moveToLastScreen() async {
    Navigator.pop(context, true);
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
      _showAlertDialog('Status', 'Appointment Request Successfully');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Booking Doctor Appointment');
    }
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
      Future<List<DoctorInfoModel>> noteListFuture = helper.getDoctorInfoList();
      noteListFuture.then((noteList) {
        setState(() {
          this.docs = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  void _showSnackBar(message) {
    final snackBar = new SnackBar(
      content: new Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
