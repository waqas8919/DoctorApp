import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctorapp/Pages/AuthPage.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/AuthenticateModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:doctorapp/model/GenderClass.dart';
import 'package:doctorapp/model/StatusClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../hotel_app_theme.dart';
import 'DoctorsList.dart';

class DoctorInfoScreen extends StatefulWidget {
  final String appBarTitle;
  final DoctorInfoModel docinfo;

  DoctorInfoScreen(this.docinfo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _DoctorInfoState(this.docinfo, this.appBarTitle);
  }
}

class _DoctorInfoState extends State<DoctorInfoScreen> {
  final _firstname = GlobalKey<FormState>();
  final _lastname = GlobalKey<FormState>();
  final _email = GlobalKey<FormState>();
  final _phone = GlobalKey<FormState>();

  DBHelper helper = DBHelper();
  Firestore _firestore = Firestore.instance;
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
                    ],
                  ),
                ),
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
                        if (_firstname.currentState.validate() &&
                            _lastname.currentState.validate() &&
                            _email.currentState.validate() &&
                            _phone.currentState.validate()) {
                          _firestore.collection("Groups").add({
                            'groupName': firstnameController.text +
                                ' ' +
                                lastnamenameController.text,
                            'picture': '',
                          });
                          _save();
                        }
                      },
                      child: Center(
                        child: Text(
                          'Add Doctor',
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

  Widget getFirstNameUI() {
    return Form(
      //padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      key: _firstname,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter firstname';
                      }
                      return null;
                    },
                    controller: firstnameController,
                    onChanged: (String txt) {
                      updatefirstname();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter FirstName',
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
    return Form(
      key: _lastname,
      //padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter lastname';
                      }
                      return null;
                    },
                    controller: lastnamenameController,
                    onChanged: (String txt) {
                      updatelastname();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter LastName',
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

  Widget getGenderUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text("Select gender :"),
          SizedBox(
            height: 20.0,
          ),
          DropdownButton(
            value: _selectedGender,
            items: _dropdownMenuItems,
            onChanged: onChangeDropdownItem,
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
    return Form(
      key: _email,
      //padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Email';
                      }
                      return null;
                    },
                    controller: emailController,
                    onChanged: (String txt) {
                      updateemail();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Email Address',
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

  Widget getPhoneNoUI() {
    return Form(
      key: _phone,
      //padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Phone no';
                      }
                      return null;
                    },
                    controller: phoneController,
                    onChanged: (String txt) {
                      updatePhoneno();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Phone No',
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

  Widget getHospitalNameUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 0),
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
                    controller: hospitalController,
                    onChanged: (String txt) {
                      updateHospitalname();
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter Hospital Name',
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

  Widget getStatusUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Select a Status"),
                      SizedBox(
                        height: 20.0,
                      ),
                      DropdownButton(
                        value: _selectedStatus,
                        items: _dropdownStatusItems,
                        onChanged: onChangeDropdownStatusItem,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
//    return Padding(
//      padding: const EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 8),
//      child: Row(
//        children: <Widget>[
//          Padding(
//            padding:
//            const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 8),
//            child: Text(
//              'Status      ',
//              textAlign: TextAlign.left,
//              style: TextStyle(
//                  color: Colors.grey,
//                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
//                  fontWeight: FontWeight.normal),
//            ),
//          ),
//          Expanded(
//            child: Padding(
//              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
//              child: Container(
//                decoration: BoxDecoration(
//                  color: HotelAppTheme.buildLightTheme().backgroundColor,
//                  borderRadius: const BorderRadius.all(
//                    Radius.circular(38.0),
//                  ),
//                  boxShadow: <BoxShadow>[
//                    BoxShadow(
//                        color: Colors.grey.withOpacity(0.2),
//                        offset: const Offset(0, 2),
//                        blurRadius: 8.0),
//                  ],
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.only(
//                      left: 16, right: 16, top: 4, bottom: 4),
//                  child: TextField(
//                    controller: StatusController,
//                    onChanged: (String txt) {
//                      updateUsername();
//                    },
//                    style: const TextStyle(
//                      fontSize: 18,
//                    ),
//                    cursorColor: HotelAppTheme.buildLightTheme().primaryColor,
//                    decoration: InputDecoration(
//                      border: InputBorder.none,
//                      hintText: 'Status',
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ),
//        ],
//      ),
//    );
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
