class ProfileInfoModel {

  int _profileid;
  String _name;
  String _username;
  String _email;
  String _contact;
  String _gender;
  String _dateofbirth;
  String _height;
  String _weight;
  String _bodymass;
  String _lifestyle;
  String _profileImage;


  ProfileInfoModel(this._name, this._username, this._email, this._contact,
      this._gender, this._dateofbirth, this._height,
      this._weight, this._bodymass, this._lifestyle,this._profileImage);

  ProfileInfoModel.withId(this._profileid,this._name, this._username, this._email, this._contact,
      this._gender, this._dateofbirth, this._height,
      this._weight, this._bodymass, this._lifestyle,this._profileImage);

  int get profileid => _profileid;
  String get name=>_name;
  String get username=>_username;
  String get email=>_email;
  String get contact=>_contact;
  String get gender=>_gender;
  String get dateofbirth=>_dateofbirth;
  String get height=>_height;
  String get weight=>_weight;
  String get bodymasse=>_bodymass;
  String get lifestyle=>_lifestyle;
  String get profileImage=>_profileImage;


  set name(String newname) {
    if (newname.length <= 255) {
      this._name = newname;
    }
  }

  set username(String newusername) {
    if (newusername.length <= 255) {
      this._username = newusername;
    }
  }

  set email(String newemail) {
    if (newemail.length <= 255) {
      this._email = newemail;
    }
  }

  set contact(String newcontact) {
    if (newcontact.length <= 255) {
      this._contact = newcontact;
    }
  }



  set dateofbirth(String newdateofbirth) {
    if (newdateofbirth.length <= 255) {
      this._dateofbirth = newdateofbirth;
    }
  }

  set gender(String newgender) {
    if (newgender.length <= 255) {
      this._gender = newgender;
    }
  }

  set height(String newheight) {
    if (newheight.length <= 255) {
      this._height = newheight;
    }
  }

  set weight(String newweight) {
    if (newweight.length <= 255) {
      this._weight = newweight;
    }
  }

  set bodymass(String newbodymass) {
    if (newbodymass.length <= 255) {
      this._bodymass = newbodymass;
    }
  }

  set lifestyle(String newlifestyle) {
    if (newlifestyle.length <= 255) {
      this._lifestyle = newlifestyle;
    }
  }
  set profileImage(String newprofileImage) {
    if (newprofileImage.length <= 255) {
      this._profileImage = newprofileImage;
    }
  }


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (profileid != null) {
      map['profileid'] = _profileid;
    }
    map['name'] = _name;
    map['username'] = _username;
    map['email'] = _email;
    map['contact'] = _contact;
    map['gender'] = _gender;
    map['dateofbirth'] = _dateofbirth;
    map['height'] = _height;
    map['weight'] = _weight;
    map['bodymasse'] = _bodymass;
    map['lifestyle'] = _lifestyle;
    map['profileImage'] = _profileImage;
    return map;
  }

  // Extract a Note object from a Map object
  ProfileInfoModel.fromMapObject(Map<String, dynamic> map) {
    this._profileid = map['profileid'];
    this._name = map['name'];
    this._username = map['username'];
    this._email = map['email'];
    this._contact = map['contact'];
    this._gender = map['gender'];
    this._dateofbirth = map['dateofbirth'];
    this._height = map['height'];
    this._weight = map['weight'];
    this._bodymass = map['bodymasse'];
    this._lifestyle = map['lifestyle'];
    this._profileImage = map['profileImage'];
  }
}