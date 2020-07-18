import 'dart:io';

import 'package:doctorapp/ProfileImage/Utility.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/ProfileModelClass.dart';
import 'package:doctorapp/model/hotel_app_theme.dart';
import 'package:doctorapp/navigation_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  DBHelper helper = DBHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  bool male = false;
  bool female = false;
  Future<File> imageFile;
  DateTime _dateTime = DateTime.now();
  String imageName = "";
  Image imageFromPreferences;
  ProfileInfoModel note;
  String ImagePath1;

  List<String> listOflifestyle = ['Sedentary', 'Active'];

  String selectedlifestyle = 'Sedentary';
  String dropdownNames;

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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            NavigationHomeScreen()));
                              },
                              child: new Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 22.0,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: new Text('PROFILE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            )
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              width: 140.0,
                              height: 140.0,
                              child: imageFromGallery(),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
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
                            )),
                      ]),
                    )
                  ],
                ),
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
                          padding:
                              EdgeInsets.only(left: 25.0, right: 25.0, top: 0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
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
                              onChanged: (String txt) {},
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              cursorColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Your Name',
                                hintStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
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
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              controller: EmailController,
                              onChanged: (String txt) {},
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              cursorColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Your Email',
                                hintStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
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
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
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
                                  return 'Please enter Mobile Number';
                                }
                                return null;
                              },
                              controller: ContactController,
                              onChanged: (String txt) {},
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              cursorColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Your Mobile',
                                hintStyle: TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      getDateUI(),
                      Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
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
                          padding:
                              EdgeInsets.only(left: 25.0, right: 25.0, top: 0),
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
                                      color: male
                                          ? Colors.green
                                          : Colors.transparent,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/images/male.png'),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Male',
                                          style: TextStyle(fontSize: 15),
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
                                      color: female
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
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          'Female',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    )),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
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
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 16, top: 8, bottom: 8),
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
                                          left: 16,
                                          right: 16,
                                          top: 4,
                                          bottom: 4),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Height';
                                          }
                                          return null;
                                        },
                                        controller: HeightController,
                                        onChanged: (String txt) {},
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        cursorColor:
                                            HotelAppTheme.buildLightTheme()
                                                .primaryColor,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Your Height',
                                          hintStyle: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 0, right: 16, top: 8, bottom: 8),
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
                                          left: 16,
                                          right: 16,
                                          top: 4,
                                          bottom: 4),
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter Weight';
                                          }
                                          return null;
                                        },
                                        controller: WeightController,
                                        onChanged: (String txt) {},
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        cursorColor:
                                            HotelAppTheme.buildLightTheme()
                                                .primaryColor,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Enter Your Weight',
                                          hintStyle: TextStyle(fontSize: 15),
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
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                HotelAppTheme.buildLightTheme().backgroundColor,
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
                              onChanged: (String txt) {},
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                              cursorColor:
                                  HotelAppTheme.buildLightTheme().primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter Your BodyMass',
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
                              padding: EdgeInsets.only(left: 25),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text('Current Life Style',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 16, right: 16),
                              child: Card(
                                  child: DropdownButton(
                                isExpanded: true,
                                value: selectedlifestyle,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.blueGrey),
                                icon: Icon(Icons.keyboard_arrow_down),
                                underline: Container(color: Colors.transparent),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedlifestyle = newValue;
                                    print(selectedlifestyle);
                                  });
                                },
                                items: listOflifestyle.map((category) {
                                  return DropdownMenuItem(
                                    child: Container(
                                        margin:
                                            EdgeInsets.only(left: 4, right: 4),
                                        child: Text(category,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.blueGrey))),
                                    value: category,
                                  );
                                }).toList(),
                              )),
                            )
                          ],
                        ),
                      ),
                      _getActionButtons()
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
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
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if (ImagePath1 != null) {
                      _save();
                    } else {
                      _showAlertDialog(
                          'Image not Added', 'Please Add Profile Picture!!');
                    }
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  void _save() async {
    int result = 0;
    String dateofBirth = DateFormat.yMMMd().format(_dateTime);
    print('Date of birth is : ' + dateofBirth);
    var saveProfile = ProfileInfoModel(
        NameController.text,
        'Username',
        EmailController.text,
        ContactController.text,
        gender,
        dateofBirth,
        HeightController.text,
        WeightController.text,
        BodymassController.text,
        selectedlifestyle,
        ImagePath1);
    result = await helper.insertProfileInfoMethod(saveProfile);
    if (result > 0) {
      _showAlertDialog('successful', 'Your Profile is Saved Successfully!!');
    } else {
      _showAlertDialog('Alert', 'Problem Save Profile Information!!');
    }
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
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

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {});
      },
    );
  }
}
