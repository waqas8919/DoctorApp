class DocAppointmentModel {

  int _appointmentid;
  String _professionalID;
  String _appointmentDate;
  String _appointmentTime;
  String _insertDateTime;
  String _title;
  String _note;
  String _appointmentType;
  String _doctorname;
  bool _isuploadedtoweb;
  String _status;
  String _slottime;


  DocAppointmentModel(this._professionalID,this._appointmentDate,
      this._appointmentTime,this._insertDateTime,this._title,this._note,this._appointmentType,this._doctorname,this._isuploadedtoweb,this._status,this._slottime);

  DocAppointmentModel.withId(this._appointmentid,this._professionalID,this._appointmentDate,
      this._appointmentTime,this._insertDateTime,this._title,this._note,this._appointmentType,this._doctorname,this._isuploadedtoweb,this._status,this._slottime);

  int get appointmentid => _appointmentid;
  String get professionalID => _professionalID;
  String get appdate => _appointmentDate;
  String get appointmenttime=>_appointmentTime;
  String get insertdatetime => _insertDateTime;
  String get title => _title;
  String get note => _note;
  String get appointmentType => _appointmentType;
  String get doctorname => _doctorname;
  bool get isuploadedtoweb => _isuploadedtoweb;
  String get status => _status;
  String get slottime => _slottime;

  set professionalID(String newprofessionalID) {
    if (newprofessionalID.length <= 255) {
      this._professionalID = newprofessionalID;
    }
  }
  set appdate(String newappointmentdate) {
    if (newappointmentdate.length <= 255) {
      this._appointmentDate = newappointmentdate;
    }
  }
  set appointmenttime(String newappointmenttime) {
    if (newappointmenttime.length <= 255) {
      this._appointmentTime = newappointmenttime;
    }
  }
  set insertdatetime(String newinsertdatetime) {
    if (newinsertdatetime.length <= 255) {
      this._insertDateTime = newinsertdatetime;
    }
  }
  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set note(String newNote) {
    if (newNote.length <= 255) {
      this._note = newNote;
    }
  }
  set appointmentType(String newappointmenttype) {
    if (newappointmenttype.length <= 255) {
      this._appointmentType= newappointmenttype;
    }
  }
  set doctorname(String newdoctorname) {
    if (newdoctorname.length <= 255) {
      this._doctorname= newdoctorname;
    }
  }
  set isuploadedtoweb(bool newisuploadedtoweb) {
    if (newisuploadedtoweb == false || newisuploadedtoweb == true) {
      this._isuploadedtoweb = newisuploadedtoweb;
    }
  }
  set status(String newStatus) {
    if (newStatus.length <= 255) {
      this._status= newStatus;
    }
  }
  set slottime(String newslottime) {
    if (newslottime.length <= 255) {
      this._slottime= newslottime;
    }
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (appointmentid != null) {
      map['appointmentid'] = _appointmentid;
    }
    map['professionalID'] = _professionalID;
    map['appdate'] = _appointmentDate;
    map['appointmenttime'] = _appointmentTime;
    map['insertdatetime'] = _insertDateTime;
    map['title'] = _title;
    map['note'] = _note;
    map['appointmenttype'] = _appointmentType;
    map['doctorname'] = _doctorname;
    map['isuploadedtoweb'] = _isuploadedtoweb? 1 : 0;
    map['status'] = _status;
    map['slottime'] = _slottime;
    return map;
  }

  // Extract a Note object from a Map object
  DocAppointmentModel.fromMapObject(Map<String, dynamic> map) {
    this._appointmentid = map['appointmentid'];
    this._professionalID = map['professionalID'];
    this._appointmentDate =map['appdate'];
    this._appointmentTime =map['appointmentTime'];
    this._insertDateTime=map['insertDateTime'];
    this._title =map['title'];
    this._note =map['note'];
    this._appointmentType =map['appointmentType'];
    this._doctorname =map['doctorname'];
    this._isuploadedtoweb = map['isuploadedtoweb']== 1;
    this._status = map['status'];
    this._slottime = map['slottime'];
  }
}