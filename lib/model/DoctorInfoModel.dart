class DoctorInfoModel {

  int _doctorid;
  String _firstname;
  String _lastname;
  String _gender;
  String _username;
  String _token;
  String _phone;
  String _email;
  String _hospital;
  String _professionalID;
  String _status;


  DoctorInfoModel(this._firstname,this._lastname,
      this._gender,this._username,this._token,this._phone,this._email,this._hospital,this._professionalID,this._status);

  DoctorInfoModel.withId(this._doctorid,this._firstname,this._lastname,
      this._gender,this._username,this._token,this._phone,this._email,this._hospital,this._professionalID,this._status);

  int get doctorid => _doctorid;
  String get firstname => _firstname;
  String get lastname=>_lastname;
  String get gender => _gender;
  String get username => _username;
  String get token => _token;
  String get phone => _phone;
  String get email => _email;
  String get hospital => _hospital;
  String get professionalID => _professionalID;

  String get status => _status;


  set doctorid(int newdoctorid) {
      this._doctorid = newdoctorid;
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
  set username(String newUsername) {
    if (newUsername.length <= 255) {
      this._username = newUsername;
    }
  }
  set token(String newToken) {
    if (newToken.length <= 255) {
      this._token = newToken;
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
  set professionalID(String newProfessionalID) {
    if (newProfessionalID.length <= 255) {
      this._professionalID= newProfessionalID;
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
    if (doctorid != null) {
      map['doctorid'] = _doctorid;
    }
    map['firstname'] = _firstname;
    map['lastname'] = _lastname;
    map['gender'] = _gender;
    map['username'] = _username;
    map['token'] = _token;
    map['phone'] = _phone;
    map['email'] = _email;
    map['hospital'] = _hospital;
    map['professionalID'] = _professionalID;
    map['status'] = _status;
    return map;
  }

  // Extract a Note object from a Map object
  DoctorInfoModel.fromMapObject(Map<String, dynamic> map) {
    this._doctorid = map['doctorid'];
    this._firstname =map['firstname'];
    this._lastname =map['lastname'];
    this._gender=map['gender'];
    this._username =map['username'];
    this._token =map['token'];
    this._phone =map['phone'];
    this._email =map['email'];
    this._hospital = map['hospital'];
    this._professionalID = map['professionalID'];
    this._status = map['status'];

  }
}