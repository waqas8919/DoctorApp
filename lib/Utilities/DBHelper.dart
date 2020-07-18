import 'dart:async';
import 'dart:io' as io;
import 'package:doctorapp/Pages/SubscriptionPage.dart';
import 'package:doctorapp/model/AuthenticateModel.dart';
import 'package:doctorapp/model/DocAppointmentModel.dart';
import 'package:doctorapp/model/DoctorInfoModel.dart';
import 'package:doctorapp/model/PaymentModel.dart';
import 'package:doctorapp/model/ProfileModelClass.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;

  //Doctor Info Table
  static const String doctorId = 'doctorid';
  static const String firstname = 'firstname';
  static const String lastname = 'lastname';
  static const String gender = 'gender';
  static const String username = 'username';
  static const String token = 'token';
  static const String phone = 'phone';
  static const String email = 'email';
  static const String hospital = 'hospital';
  static const String status = 'status'; //payment table Also

  //Appoint Table
  static const String appointmentid = 'appointmentid';
  static const String professionalID = 'professionalID';
  static const String appdate = 'appdate';
  static const String appointmenttime = 'appointmenttime';
  static const String insertdatetime = 'insertdatetime';
  static const String title = 'title';
  static const String note = 'note';
  static const String appointmentType = 'appointmentType';
  static const String doctorname = 'doctorname';
  static const String isuploadedtoweb = 'isuploadedtoweb';
  static const String slottime = 'slottime';

  //Authentication Table
  static const String authid = 'authid';
  static const String authcode = 'authcode';
  static const String docid = 'docid';

  //Payment Table

  static const String paymentid = 'id';
  static const String cardnumber = 'cardnumber';
  static const String name = 'name';
  static const String expiry = 'expiry';
  static const String cvv = 'cvv';
  static const String amount = 'amount';
  static const String sdeposit = 'sdeposit';
  static const String paydate = 'paydate';
  static const String subtype = 'subtype';

  //Profile fields

  static const String profileid = 'profileid';
// static const String name         = 'name';
// static const String username     = 'username';
// static const String email        = 'email';
  static const String contact = 'contact';
  static const String address = 'address';
// static const String gender       = 'gender';
  static const String dateofbirth = 'dateofbirth';
  static const String height = 'height';
  static const String weight = 'weight';
  static const String bodymasse = 'bodymasse';
  static const String lifestyle = 'lifestyle';
  static const String profileImage = 'profileImage';

  static const String doctorsTable = 'DoctorInfo_tbl';
  static const String appointmentTable = 'DocAppointment_tbl';
  static const String AuthenticateTable = 'Authenticate_tbl';
  static const String paymentTable = 'Payment_tbl';
  static const String profileTable = 'Profile_tbl';

  static const String DB_NAME = 'Book_Doc_Appointment_Db.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

//  Create Database
  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 4, onCreate: _onCreate);
    return db;
  }

// Add Tables In Database

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $doctorsTable($doctorId INTEGER PRIMARY KEY AUTOINCREMENT, $firstname TEXT, $lastname TEXT, $gender TEXT, $username TEXT, $token TEXT,$phone TEXT,$email TEXT, $hospital TEXT, $status TEXT,$professionalID TEXT)');
    await db.execute(
        'CREATE TABLE $appointmentTable($appointmentid INTEGER PRIMARY KEY AUTOINCREMENT, $professionalID TEXT, $appdate TEXT, $appointmenttime TEXT, $insertdatetime TEXT, $title TEXT,$note TEXT,$appointmentType TEXT, $doctorname TEXT, $isuploadedtoweb BOOLEAN, $status TEXT,$slottime TEXT)');
    await db.execute(
        'CREATE TABLE $AuthenticateTable($authid INTEGER PRIMARY KEY AUTOINCREMENT, $authcode TEXT,$docid INTEGER, $firstname TEXT, $lastname TEXT, $gender TEXT,$phone TEXT,$email TEXT, $hospital TEXT, $status TEXT)');
    await db.execute(
        'CREATE TABLE $paymentTable($paymentid INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT,$cardnumber TEXT,$expiry TEXT,$cvv TEXT,$amount TEXT,$sdeposit TEXT, $paydate TEXT, $status TEXT, $subtype TEXT)');
    await db.execute(
        'CREATE TABLE $profileTable($profileid INTEGER PRIMARY KEY AUTOINCREMENT, $name TEXT,$username TEXT,$email TEXT,$contact TEXT,$address TEXT,$gender TEXT, $height TEXT, $weight TEXT, $bodymasse TEXT, $lifestyle TEXT,$dateofbirth TEXT,$profileImage TEXT)');
  }

//Insert Record In Post Car Table

  Future<int> insertDoctorInfo(DoctorInfoModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.insert(doctorsTable, docinfo.toMap());
    return result;
  }

  Future<int> insertAppointmentDoctorInfo(DocAppointmentModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.insert(appointmentTable, docinfo.toMap());
    return result;
  }

  Future<int> insertAuthInfo(AuthModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.insert(AuthenticateTable, docinfo.toMap());
    return result;
  }

  // insert record in Payment table
  Future<int> insertPaymentMethod(PaymentModel payment) async {
    var dbClient = await db;
    var result = await dbClient.insert(paymentTable, payment.toMap());
    return result;
  }

  Future<int> insertProfileInfoMethod(ProfileInfoModel payment) async {
    var dbClient = await db;
    var result = await dbClient.insert(profileTable, payment.toMap());
    return result;
  }

  Future<List<DoctorInfoModel>> getDoctorInfoList() async {
    var doctorinfoMapList =
        await getDoctorInfoMapList(); // Get 'Map List' from database
    int count =
        doctorinfoMapList.length; // Count the number of map entries in db table

    List<DoctorInfoModel> doctorinfoList = List<DoctorInfoModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      doctorinfoList.add(DoctorInfoModel.fromMapObject(doctorinfoMapList[i]));
    }

    return doctorinfoList;
  }

  Future<List<DoctorInfoModel>> getSpecificDoctorInfoList(int adocid) async {
    var doctorinfoMapList = await getSpecificDoctorInfoMapList(
        adocid); // Get 'Map List' from database
    int count =
        doctorinfoMapList.length; // Count the number of map entries in db table

    List<DoctorInfoModel> doctorinfoList = List<DoctorInfoModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      doctorinfoList.add(DoctorInfoModel.fromMapObject(doctorinfoMapList[i]));
    }

    return doctorinfoList;
  }

  Future<List<DocAppointmentModel>> getDoctorAppointmentInfoList() async {
    var doctorinfoMapList =
        await getDoctorAppointmentInfoMapList(); // Get 'Map List' from database
    int count =
        doctorinfoMapList.length; // Count the number of map entries in db table

    List<DocAppointmentModel> doctorinfoList = List<DocAppointmentModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      doctorinfoList
          .add(DocAppointmentModel.fromMapObject(doctorinfoMapList[i]));
    }

    return doctorinfoList;
  }

  Future<List<DoctorInfoModel>> getDoctorNameList() async {
    var doctorinfoMapList =
        await getDoctorNamesMapList(); // Get 'Map List' from database
    int count =
        doctorinfoMapList.length; // Count the number of map entries in db table

    List<DoctorInfoModel> doctorinfoList = List<DoctorInfoModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      doctorinfoList.add(DoctorInfoModel.fromMapObject(doctorinfoMapList[i]));
    }

    return doctorinfoList;
  }

  Future<List<AuthModel>> getAuthList() async {
    var doctorinfoMapList =
        await getAuthMapList(); // Get 'Map List' from database
    int count =
        doctorinfoMapList.length; // Count the number of map entries in db table

    List<AuthModel> doctorinfoList = List<AuthModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      doctorinfoList.add(AuthModel.fromMapObject(doctorinfoMapList[i]));
    }

    return doctorinfoList;
  }

  //Get payment List
  Future<List<PaymentModel>> getPaymentMethodList() async {
    var paymentMapList =
        await getPaymentMethodMapList(); // Get 'Map List' from database
    int count =
        paymentMapList.length; // Count the number of map entries in db table

    List<PaymentModel> paymentList = List<PaymentModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      paymentList.add(PaymentModel.fromMapObject(paymentMapList[i]));
    }
    return paymentList;
  }

  Future<List<ProfileInfoModel>> getProfileMethodList() async {
    var profileMapList =
        await getProfileMethodMapList(); // Get 'Map List' from database
    int count =
        profileMapList.length; // Count the number of map entries in db table

    List<ProfileInfoModel> profiletList = List<ProfileInfoModel>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      profiletList.add(ProfileInfoModel.fromMapObject(profileMapList[i]));
    }
    return profiletList;
  }

//  Future<int> SubscriptionExists(String Plan) async {
//    var dbClient = await db;
//    String sql;
//    sql = "SELECT * FROM $paymentTable WHERE $subtype = $Plan";
//    int result = await dbClient.rawQuery(sql);
//    return result;
//  }

  Future<int> deleteDoctorInfo(int id) async {
    var dbClient = await db;
    int result = await dbClient
        .rawDelete('DELETE FROM $doctorsTable WHERE $doctorId = $id');
    return result;
  }

  Future<int> deleteprofileInfo(int id) async {
    var dbClient = await db;
    int result = await dbClient
        .rawDelete('DELETE FROM $profileTable WHERE $profileid = $id');
    return result;
  }

  Future<int> deleteDoctorAppointmentInfo(int id) async {
    var dbClient = await db;
    int result = await dbClient
        .rawDelete('DELETE FROM $appointmentTable WHERE $appointmentid = $id');
    return result;
  }

  Future<int> deleteAuthInfo(int id) async {
    var dbClient = await db;
    int result = await dbClient
        .rawDelete('DELETE FROM $AuthenticateTable WHERE $authid = $id');
    return result;
  }

  Future<int> deletePaymentMethod(int id) async {
    var dbClient = await db;
    int result = await dbClient
        .rawDelete('DELETE FROM $paymentTable WHERE $paymentid = $id');
    return result;
  }

  Future<int> updateDoctorInfo(DoctorInfoModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.update(doctorsTable, docinfo.toMap(),
        where: '$doctorId = ?', whereArgs: [docinfo.doctorid]);
    return result;
  }

  Future<int> updateDoctorAppointmentInfo(DocAppointmentModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.update(appointmentTable, docinfo.toMap(),
        where: '$appointmentid = ?', whereArgs: [docinfo.appointmentid]);
    return result;
  }

  Future<int> updateAuthInfo(AuthModel docinfo) async {
    var dbClient = await db;
    var result = await dbClient.update(AuthenticateTable, docinfo.toMap(),
        where: '$authid = ?', whereArgs: [docinfo.authid]);
    return result;
  }

//update payment
  Future<int> updatePayment(PaymentModel payment) async {
    var dbClient = await db;
    var result = await dbClient.update(paymentTable, payment.toMap(),
        where: '$paymentid = ?', whereArgs: [payment.id]);
    return result;
  }

  Future<int> updateProfileInfo(ProfileInfoModel payment) async {
    var dbClient = await db;
    var result = await dbClient.update(profileTable, payment.toMap(),
        where: '$profileid = ?', whereArgs: [payment.profileid]);
    return result;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<List<DoctorInfoModel>> getDoctorNameData() async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $doctorsTable";

    var result = await dbClient.rawQuery(sql);

    if (result.length == 0) return null;

    List<DoctorInfoModel> list = result.map((item) {
      return DoctorInfoModel.fromMapObject(item);
    }).toList();
    return list;
  }

  Future<List<PaymentModel>> getSubscriptiomData(String Plan) async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $paymentTable";

    var result = await dbClient.rawQuery(sql);
    var sub = result.where((element) => element.containsValue(Plan)).toList();

    print("sub is" + sub.length.toString());

    if (result.length == 0) return null;

    List<PaymentModel> list = result.map((item) {
      return PaymentModel.fromMapObject(item);
    }).toList();
    return list;
  }

  Future<List<Map<String, dynamic>>> getDoctorInfoMapList() async {
    var dbClient = await db;

    var result = await dbClient.query(doctorsTable, orderBy: '$doctorId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getSpecificDoctorInfoMapList(
      int adocid) async {
    var dbClient = await db;
    String sql;
    sql = "SELECT * FROM $doctorsTable where $doctorId = $adocid";
    var result = await dbClient.rawQuery(sql);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAuthMapList() async {
    var dbClient = await db;

    var result =
        await dbClient.query(AuthenticateTable, orderBy: '$authid ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getDoctorAppointmentInfoMapList() async {
    var dbClient = await db;

    var result =
        await dbClient.query(appointmentTable, orderBy: '$appointmentid ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getProfileMethodMapList() async {
    var dbClient = await db;

    var result = await dbClient.query(profileTable, orderBy: '$profileid ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getDoctorNamesMapList() async {
    var dbClient = await db;

    var result = await dbClient
        .rawQuery('SELECT $doctorsTable.firstname FROM $doctorsTable');
    return result;
  }

  Future<int> getDoctorInfoCount() async {
    var dbClient = await db;
    List<Map<String, dynamic>> x =
        await dbClient.rawQuery('SELECT COUNT (*) from $doctorsTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getSubscriptionInfoCount(String Plan) async {
    var dbClient = await db;
    List<Map<String, dynamic>> x = await dbClient
        .rawQuery('SELECT COUNT (*) from $paymentTable WHERE $subtype = $Plan');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Map<String, dynamic>>> getPaymentMethodMapList() async {
    var dbClient = await db;

    var result = await dbClient.query(paymentTable, orderBy: '$paymentid ASC');
    return result;
  }

  Future<int> getMyProfileCount() async {
    var dbClient = await db;
    List<Map<String, dynamic>> x =
        await dbClient.rawQuery('SELECT COUNT (*) from $profileTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
}
