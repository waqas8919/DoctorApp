class PaymentModel {
  int _id;
  String _name;
  String _cardnumber;
  String _expiry;
  String _cvv;
  String _amount;
  String _paydate;
  String _status;
  String _subtype;


  PaymentModel(this._name,this._cardnumber,this._expiry,this._cvv,this._amount,this._paydate,this._status,this._subtype);
  PaymentModel.withId(this._name,this._cardnumber,this._expiry,this._cvv,this._amount,this._paydate,this._status,this._subtype);


  int get id => _id;
  String get name=>_name;
  String get cardnumber => _cardnumber;
  String get expiry => _expiry;
  String get cvv => _cvv;
  String get amount => _amount;
  String get paydate => _paydate;
  String get status => _status;
  String get subtype => _subtype;

  set name(String newname) {
    if (newname.length <= 255) {
      this._name = newname;
    }
  }
  set cardnumber(String newcardno) {
    if (newcardno.length <= 255) {
      this._cardnumber = newcardno;
    }
  }
  set expiry(String newexpiry) {
    if (newexpiry.length <= 255) {
      this._expiry = newexpiry;
    }
  }
  set cvv(String newcvv) {
    if (newcvv.length <= 255) {
      this._cvv = newcvv;
    }
  }
  set amount(String newamount) {
    if (newamount.length <= 255) {
      this._amount = newamount;
    }
  }
  set paydate(String newpaydate) {
    if (newpaydate.length <= 255) {
      this._paydate = newpaydate;
    }
  }
  set status(String newstatus) {
    if (newstatus.length <= 255) {
      this._status = newstatus;
    }
  }
  set subtype(String newsubtype) {
    if (newsubtype.length <= 255) {
      this._subtype = newsubtype;
    }
  }
  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['cardnumber'] = _cardnumber;
    map['expiry'] = _expiry;
    map['cvv'] = _cvv;
    map['amount'] = _amount;
    map['paydate'] = _paydate;
    map['status'] = _status;
    map['subtype'] = _subtype;

    return map;
  }
  // Extract a Note object from a Map object
  PaymentModel.fromMapObject(Map<String, dynamic> map) {

    this._id = map['id'];
    this._name = map['name'];
    this._cardnumber = map['cardnumber'];
    this._expiry = map['expiry'];
    this._cvv = map['cvv'];
    this._amount = map['amount'];
    this._paydate = map['paydate'];
    this._status = map['status'];
    this._subtype = map['subtype'];
  }
}