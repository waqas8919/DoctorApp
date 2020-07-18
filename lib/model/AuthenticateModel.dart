class AuthModel {

  int _authid;
  String _authenticateCode;
  int _docid;
  String _firstname;
  String _lastname;
  String _gender;
  String _phone;
  String _email;
  String _hospital;
  String _status;



  AuthModel(this._authenticateCode,this._docid,this._firstname,this._lastname,
      this._gender,this._phone,this._email,this._hospital,this._status);
  AuthModel.withId(this._authid,this._authenticateCode,this._docid,this._firstname,this._lastname,
      this._gender,this._phone,this._email,this._hospital,this._status);


  int get authid => _authid;
  String get authcode => _authenticateCode;
  int get docid => _docid;
  String get firstname => _firstname;
  String get lastname=>_lastname;
  String get gender => _gender;
  String get phone => _phone;
  String get email => _email;
  String get hospital => _hospital;
  String get status => _status;


  set authcode(String newauthcode) {
    if (newauthcode.length <= 255) {
      this._authenticateCode = newauthcode;
    }
  }
  set docid(int newdocid) {
      this._docid = newdocid;
  }
  set firstname(String newFirstName) {
    if (newFirstName.length <= 255) {
      this._firstname = newFirstName;
    }
  }
  set lastname(String newLastName) {
    if (newLastName.length <= 255) {
      this._lastname = newLastName;
    }
  }
  set gender(String newGender) {
    if (newGender.length <= 255) {
      this._gender = newGender;
    }
  }
  set phone(String newPhone) {
    if (newPhone.length <= 255) {
      this._phone = newPhone;
    }
  }
  set email(String newEmail) {
    if (newEmail.length <= 255) {
      this._email= newEmail;
    }
  }
  set hospital(String newHospital) {
    if (newHospital.length <= 255) {
      this._hospital= newHospital;
    }
  }

  set status(String newStatus) {
    if (newStatus.length <= 255) {
      this._status= newStatus;
    }
  }


  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (authid != null) {
      map['authid'] = _authid;
    }
    map['authcode'] = _authenticateCode;
    map['docid'] = _docid;
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['gender'] = _gender;
    map['phone'] = _phone;
    map['email'] = _email;
    map['hospital'] = _hospital;
    map['status'] = _status;
    return map;
  }

  // Extract a Note object from a Map object
  AuthModel.fromMapObject(Map<String, dynamic> map) {
    this._authid = map['authid'];
    this._authenticateCode =map['authcode'];
    this._docid =map['docid'];
    this._firstname =map['firstname'];
    this._lastname =map['lastname'];
    this._gender=map['gender'];
    this._phone =map['phone'];
    this._email =map['email'];
    this._hospital = map['hospital'];
    this._status = map['status'];
  }
}