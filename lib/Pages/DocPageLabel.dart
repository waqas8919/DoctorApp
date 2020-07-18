import 'package:doctorapp/Pages/AuthPage.dart';
import 'package:doctorapp/TeleConsult/TeleMainPageNew.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/AuthenticateModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:doctorapp/model/GenderClass.dart';
import 'package:doctorapp/model/StatusClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hotel_app_theme.dart';
import '../navigation_home_screen.dart';
import 'DoctorsList.dart';

class DoctorPageLabel extends StatefulWidget {
  final String appBarTitle;
  final DoctorInfoModel docinfo;

  DoctorPageLabel(this.docinfo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _DoctorInfoState(this.docinfo, this.appBarTitle);
  }
}

class _DoctorInfoState extends State<DoctorPageLabel> {
  DBHelper helper = DBHelper();
  DoctorInfoModel note;
  String appBarTitle;

  List<GenderClass> _genders = GenderClass.getGenders();
  List<DropdownMenuItem<GenderClass>> _dropdownMenuItems;
  GenderClass _selectedGender;

  List<StatusClass> _status = StatusClass.getStatus();
  List<DropdownMenuItem<StatusClass>> _dropdownStatusItems;
  StatusClass _selectedStatus;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_genders);
    _dropdownStatusItems = buildDropdownStatusItems(_status);
    _selectedGender = _dropdownMenuItems[0].value;
    _selectedStatus = _dropdownStatusItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<GenderClass>> buildDropdownMenuItems(List genders) {
    List<DropdownMenuItem<GenderClass>> items = List();
    for (GenderClass gender in genders) {
      items.add(
        DropdownMenuItem(
          value: gender,
          child: Text(gender.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<StatusClass>> buildDropdownStatusItems(List statuss) {
    List<DropdownMenuItem<StatusClass>> items = List();
    for (StatusClass status in statuss) {
      items.add(
        DropdownMenuItem(
          value: status,
          child: Text(status.name),
        ),
      );
    }
    return items;
  }

  _DoctorInfoState(this.note, this.appBarTitle);

  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnamenameController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController hospitalController = TextEditingController();
  TextEditingController ProfessionalIDController = TextEditingController();
  TextEditingController StatusController = TextEditingController();

  onChangeDropdownItem(GenderClass selectedGender) {
    setState(() {
      _selectedGender = selectedGender;
      updategender();
    });
  }

  onChangeDropdownStatusItem(StatusClass selectedStatus) {
    setState(() {
      _selectedStatus = selectedStatus;
      updateStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    firstnameController.text = note.firstname;
    lastnamenameController.text = note.lastname;
    genderController.text = note.gender;
    usernameController.text = note.username;
    tokenController.text = note.token;
    phoneController.text = note.phone;
    emailController.text = note.email;
    hospitalController.text = note.hospital;
    ProfessionalIDController.text = note.professionalID;
    StatusController.text = note.status;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Container(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              getAppBarUI(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      getEmailHeading(),
                      SizedBox(
                        height: 10,
                      ),
                      getFirstNameUI(),
                      const Divider(
                        height: 1,
                      ),
                      getLastNameUI(),
                      const Divider(
                        height: 1,
                      ),
                      getEmailUI(),
                      //getUserNameUI(),
                      const Divider(
                        height: 1,
                      ),
                      getGenderUI(),
                      const Divider(
                        height: 1,
                      ),
                      getPhoneNoUI(),
                      //getEmailUI(),
                      const Divider(
                        height: 1,
                      ),
                      getHospitalNameUI(),
                      SizedBox(
                        height: 20,
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

  Widget getFirstNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "First Name:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            firstnameController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getProfessionalIDUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
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
                    controller: ProfessionalIDController,
                    onChanged: (String txt) {
                      updateProfessionalID();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter ProfessionalID',
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

  Widget getLastNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            "Last Name:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            lastnamenameController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getGenderUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Gender:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            genderController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getUserNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
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
                    controller: usernameController,
                    onChanged: (String txt) {
                      updateUsername();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Status',
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

  Widget getEmailUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Email:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            emailController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getEmailHeading() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            emailController.text,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget getPhoneNoUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Phone:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            phoneController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getHospitalNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 20, top: 8, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Hospital:",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            hospitalController.text,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget getStatusUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text("Status:"),
          Text(StatusController.text),
        ],
      ),
    );
  }

  Widget getButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => TeleConsultScreenNew()));
            },
            child: Text(
              "Message",
              style: TextStyle(color: Colors.white),
            ),
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              _save();
            },
            child: Text(
              "Register",
              style: TextStyle(color: Colors.white),
            ),
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
          RaisedButton(
            onPressed: () {
              _Reject();
            },
            child: Text(
              "Reject",
              style: TextStyle(color: Colors.white),
            ),
            color: HotelAppTheme.buildLightTheme().primaryColor,
          ),
        ],
      ),
    );
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

  void moveToLastScreen() async {
    await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DoctorInfoList()));
  }

  void moveToAuthScreen(int docid) async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AuthInfoScreen(
                AuthModel(
                    "",
                    docid,
                    firstnameController.text,
                    lastnamenameController.text,
                    _selectedGender.name,
                    phoneController.text,
                    emailController.text,
                    hospitalController.text,
                    _selectedStatus.name),
                "Authenticate Details")));
  }

  void updatefirstname() {
    note.firstname = firstnameController.text;
  }

  void updatelastname() {
    note.lastname = lastnamenameController.text;
  }

  void updategender() {
    note.gender = _selectedGender.name;
  }

  void updateUsername() {
    note.username = usernameController.text;
  }

  void updateemail() {
    note.email = emailController.text;
  }

  void updatePhoneno() {
    note.phone = phoneController.text;
  }

  void updateProfessionalID() {
    note.professionalID = ProfessionalIDController.text;
  }

  void updateHospitalname() {
    note.hospital = hospitalController.text;
  }

  void updateStatus() {
    note.status = _selectedStatus.name;
  }

  void _Reject() async {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DoctorInfoList()));
  }

// this function add renter information
  void _save() async {
    int result = 0;
    int result1 = 0;
    if (note.doctorid != null) {
      note.status = "Pending By Doc";
      // Case 1: Update operation
      result1 = await helper.updateDoctorInfo(note);
      moveToAuthScreen(result1);
    } else {
      // Case 2: Insert Operation
      note.status = "Pending Authentication";
      result = await helper.insertDoctorInfo(note);
      moveToLastScreen();
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Doctor Information Added Successfully');
    }
  }

  void _delete() async {
    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.doctorid == null) {
      _showAlertDialog('Status', 'No Doctor Information  was deleted');
      return;
    }
    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteDoctorInfo(note.doctorid);
    if (result != 0) {
      _showAlertDialog('Status', 'Doctor Information Deleted Successfully');
    } else {
      _showAlertDialog(
          'Status', 'Error Occured while Deleting Doctor Information');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
