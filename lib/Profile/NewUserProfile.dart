import 'dart:io';
import 'dart:ui';

import 'package:doctorapp/Profile/UserProfile.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:doctorapp/ProfileImage/Utility.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/ProfileModelClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../hotel_app_theme.dart';
import '../navigation_home_screen.dart';

class ProfileInfoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDocListState();
  }
}

class NewDocListState extends State<ProfileInfoList> {
  DBHelper databaseHelper = DBHelper();
  List<ProfileInfoModel> noteList;
  int count = 0;
  bool male = false;
  bool female = false;
  Future<File> imageFile;
  final FocusNode myFocusNode = FocusNode();
  DBHelper helper = DBHelper();
  DateTime _dateTime = DateTime.now();
  String imageName = "";
  Image imageFromPreferences;
  ProfileInfoModel note;
  String ImagePath1;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return;
      }
      setState(() {
        imageFromPreferences = Utility.imageFromBase64String(img);
        imageName = img;
      });
    });
  }

  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          ImagePath1 = snapshot.data.path;
          print("Image Path is : " + ImagePath1);
          //UpdateImage1Path();
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(
            File(ImagePath1) != null ? File(ImagePath1) : "",
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  TextEditingController NameController = new TextEditingController();
  TextEditingController EmailController = new TextEditingController();
  TextEditingController ContactController = new TextEditingController();
  TextEditingController HeightController = new TextEditingController();
  TextEditingController WeightController = new TextEditingController();
  TextEditingController BodymassController = new TextEditingController();
  TextEditingController LifeStyleController = new TextEditingController();
  String gender;

  List<String> listOflifestyle = ['Sedentary', 'Active'];

  String selectedlifestyle = 'Sedentary';
  String dropdownNames;

  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<ProfileInfoModel>();
      updateListView(); // get renter information
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
                  padding: const EdgeInsets.only(right: 0, left: 0),
                  child: Column(
                    children: <Widget>[
                      new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            width: 140.0,
                            height: 140.0,
                            child: Container(
                              height: 95,
                              width: 95,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                      color: const Color(0x33A6A6A6)),
                                  image: DecorationImage(
                                    image: Image.file(
                                      File(this
                                                  .noteList[position]
                                                  .profileImage) !=
                                              null
                                          ? File(this
                                              .noteList[position]
                                              .profileImage)
                                          : "No Image",
                                    ).image,
                                    fit: BoxFit.fill,
                                  )),
                            ),
                          ),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new GestureDetector(
                            onTap: () {
                              pickImageFromGallery(ImageSource.camera);
                              setState(() {
                                imageFromPreferences = null;
                              });
                            },
                            child: new CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 25.0,
                              child: new Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      new Container(
                        color: Color(0xffFFFFFF),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 10),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
//                                  new Column(
//                                    mainAxisAlignment: MainAxisAlignment.end,
//                                    mainAxisSize: MainAxisSize.min,
//                                    children: <Widget>[
//                                      _status ? _getEditIcon() : new Container(),
//                                    ],
//                                  )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 10, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HotelAppTheme.buildLightTheme()
                                        .backgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
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
                                          return 'Please enter Name';
                                        }
                                        return null;
                                      },
                                      controller: NameController,
                                      onChanged: (String txt) {
                                        print('txt : ' + txt);
                                        note.name = txt;
                                      },
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      cursorColor:
                                          HotelAppTheme.buildLightTheme()
                                              .primaryColor,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: this.noteList[position].name,
                                        hintStyle: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Email ID',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 10, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HotelAppTheme.buildLightTheme()
                                        .backgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
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
                                        left: 0, right: 0, top: 10, bottom: 4),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter Email';
                                        }
                                        return null;
                                      },
                                      controller: EmailController,
                                      onChanged: (String txt) {
                                        note.email = txt;
                                      },
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      cursorColor:
                                          HotelAppTheme.buildLightTheme()
                                              .primaryColor,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: this.noteList[position].email,
                                        hintStyle: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Contact',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 10, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HotelAppTheme.buildLightTheme()
                                        .backgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
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
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter Contact';
                                        }
                                        return null;
                                      },
                                      controller: ContactController,
                                      onChanged: (String txt) {
                                        note.contact = txt;
                                      },
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      cursorColor:
                                          HotelAppTheme.buildLightTheme()
                                              .primaryColor,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            this.noteList[position].contact,
                                        hintStyle: TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 20, bottom: 0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    RaisedButton(
                                      child: Text('Select Date of Birth'),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate: _dateTime == null
                                                    ? DateTime.now()
                                                    : _dateTime,
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2021))
                                            .then((date) {
                                          setState(() {
                                            _dateTime = date;
                                          });
                                        });
                                      },
                                      color: HotelAppTheme.buildLightTheme()
                                          .primaryColor,
                                    ),
                                    Text(_dateTime == null
                                        ? 'Nothing has been picked yet'
                                        : DateFormat.yMMMd().format(_dateTime)),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 0, right: 0, top: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Gender',
                                      style: TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            male = !male;
                                            female = false;
                                            gender = 'Male';
                                          });
                                        },
                                        child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              color: this
                                                          .noteList[position]
                                                          .gender ==
                                                      'Male'
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              image: new DecorationImage(
                                                image: new ExactAssetImage(
                                                    'assets/images/male.png'),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  'Male',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            )),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            female = !female;
                                            male = false;
                                            gender = 'Female';
                                          });
                                        },
                                        child: Container(
                                            width: 100.0,
                                            height: 100.0,
                                            decoration: new BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                              color: this
                                                          .noteList[position]
                                                          .gender ==
                                                      'Female'
                                                  ? Colors.green
                                                  : Colors.transparent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15.0)),
                                              shape: BoxShape.rectangle,
                                              image: new DecorationImage(
                                                image: new ExactAssetImage(
                                                    'assets/images/female.png'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  'Female',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'Height',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'Weight',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 10.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0,
                                              right: 16,
                                              top: 8,
                                              bottom: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: HotelAppTheme
                                                      .buildLightTheme()
                                                  .backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0,
                                                  right: 0,
                                                  top: 10,
                                                  bottom: 4),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter Height';
                                                  }
                                                  return null;
                                                },
                                                controller: HeightController,
                                                onChanged: (String txt) {
                                                  note.height = txt;
                                                },
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                cursorColor: HotelAppTheme
                                                        .buildLightTheme()
                                                    .primaryColor,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: this
                                                      .noteList[position]
                                                      .height,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              top: 10,
                                              bottom: 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: HotelAppTheme
                                                      .buildLightTheme()
                                                  .backgroundColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(15.0),
                                              ),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.2),
                                                    offset: const Offset(0, 2),
                                                    blurRadius: 8.0),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 16,
                                                  right: 16,
                                                  top: 4,
                                                  bottom: 4),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter Weight';
                                                  }
                                                  return null;
                                                },
                                                controller: WeightController,
                                                onChanged: (String txt) {
                                                  note.weight = txt;
                                                },
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                                cursorColor: HotelAppTheme
                                                        .buildLightTheme()
                                                    .primaryColor,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: this
                                                      .noteList[position]
                                                      .weight,
                                                  hintStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 20.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Body Mass',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, right: 0, top: 10, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: HotelAppTheme.buildLightTheme()
                                        .backgroundColor,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15.0),
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
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter BodyMass';
                                        }
                                        return null;
                                      },
                                      controller: BodymassController,
                                      onChanged: (String txt) {
                                        note.bodymass = txt;
                                      },
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      cursorColor:
                                          HotelAppTheme.buildLightTheme()
                                              .primaryColor,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            this.noteList[position].bodymasse,
                                        hintStyle: TextStyle(fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Current Life Style',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: Card(
                                          child: DropdownButton(
                                        isExpanded: true,
                                        value: selectedlifestyle,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        underline: Container(
                                            color: Colors.transparent),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedlifestyle = newValue;
                                            print(selectedlifestyle);
                                            note.lifestyle = selectedlifestyle;
                                          });
                                        },
                                        items: listOflifestyle.map((category) {
                                          return DropdownMenuItem(
                                            child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 4, right: 4),
                                                child: Text(category,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            Colors.blueGrey))),
                                            value: category,
                                          );
                                        }).toList(),
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 45.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            child: new RaisedButton(
                                          child: new Text("Save"),
                                          textColor: Colors.white,
                                          color: Colors.green,
                                          onPressed: () {
                                            setState(() {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              _save(this.noteList[position]);
                                            });
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                        )),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
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

  Widget getDateUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            child: Text('Select Date of Birth'),
            onPressed: () {
              showDatePicker(
                      context: context,
                      initialDate:
                          _dateTime == null ? DateTime.now() : _dateTime,
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2021))
                  .then((date) {
                setState(() {
                  _dateTime = date;
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

  void _save(ProfileInfoModel prog) async {
    int result = 0;
    // String dateofBirth = DateFormat.yMMMd().format(_dateTime);
    // prog.dateofbirth = dateofBirth;
    // prog.profileImage = ImagePath1;
    //prog.gender = gender;

    if (prog.profileid > 0) {
      result = await helper.updateProfileInfo(prog);
      _showAlertDialog('successful', 'Your Profile is Updated Successfully!!');
    } else {
      _showAlertDialog('Alert', 'Problem Save Profile Information!!');
    }

    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  void updateListView() {
    var dbFuture = databaseHelper.initDb();
    dbFuture.then((database) {
      Future<List<ProfileInfoModel>> noteListFuture =
          databaseHelper.getProfileMethodList();
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
                  'Profile',
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
