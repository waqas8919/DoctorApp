import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:doctorapp/Payment/credit_card_bloc.dart';
import 'package:doctorapp/Payment/profile_tile.dart';
import 'package:doctorapp/Payment/uidata.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/PaymentModel.dart';
import 'package:intl/intl.dart';
import '../hotel_app_theme.dart';
import '../main_page.dart';
import '../navigation_home_screen.dart';

class ShowCreditCardPage extends StatefulWidget {
  final String appBarTitle;
  final PaymentModel carpost;

  ShowCreditCardPage(this.carpost, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return _CreditCarScreenState(this.carpost, this.appBarTitle);
  }
}

class _CreditCarScreenState extends State<ShowCreditCardPage> {
  final _creditCardKey = GlobalKey<FormState>();
  List<PaymentModel> payment;

//  final _expiryKey = GlobalKey<FormState>();
//  final _cvvKey = GlobalKey<FormState>();
//  final _nameKey = GlobalKey<FormState>();
//  final _amountKey = GlobalKey<FormState>();

  DBHelper helper = DBHelper();
  PaymentModel note;
  bool isDataAvailable = true;
  String appBarTitle;
  DateTime todaydate = DateTime.now();
  String dateToday;

  _CreditCarScreenState(this.note, this.appBarTitle);

  BuildContext _context;
  CreditCardBloc cardBloc;
  MaskedTextController ccMask =
      MaskedTextController(mask: "0000 0000 0000 0000");
  MaskedTextController expMask = MaskedTextController(mask: "00/00");
  MaskedTextController cvvMask = MaskedTextController(mask: "000");
  MaskedTextController nameMask =
      MaskedTextController(mask: "*******************");
  MaskedTextController amountMask = MaskedTextController(mask: "**********");
  TextEditingController cardname = new TextEditingController();
  TextEditingController expirycontroller = new TextEditingController();
  TextEditingController cvvcontroller = new TextEditingController();

  Widget bodyData() {
    return Container(
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
                    creditCardWidget(),
                    fillEntries(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget fillEntries() {
    return Form(
      key: _creditCardKey,
      autovalidate: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              enabled: false,
              controller: cardname,
              keyboardType: TextInputType.number,
              maxLength: 19,
              style: TextStyle(fontFamily: UIData.ralewayFont),
              onChanged: (out) {
                cardBloc.ccInputSink.add(ccMask.text);
                print(ccMask.text);
              },
              decoration: InputDecoration(
                  hintText: note.cardnumber,
                  labelText: 'Card Number',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()),
            ),
            TextFormField(
              enabled: false,
              controller: expirycontroller,
              keyboardType: TextInputType.number,
              maxLength: 5,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.expInputSink.add(expMask.text),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintText: note.expiry,
                  labelText: 'Expiry Date',
                  border: OutlineInputBorder()),
            ),
            TextFormField(
              enabled: false,
              controller: cvvcontroller,
              keyboardType: TextInputType.number,
              maxLength: 3,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.cvvInputSink.add(cvvMask.text),
              decoration: InputDecoration(
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  hintText: note.cvv,
                  labelText: 'CVV',
                  border: OutlineInputBorder()),
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Name of Card Holder';
                }
                return null;
              },
              enabled: false,
              controller: nameMask,
              keyboardType: TextInputType.text,
              maxLength: 20,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.nameInputSink.add(nameMask.text),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Name on card",
                  border: OutlineInputBorder()),
            ),
            TextFormField(
              enabled: false,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter Amount';
                }
                return null;
              },
              controller: amountMask,
              keyboardType: TextInputType.number,
              maxLength: 10,
              style: TextStyle(
                  fontFamily: UIData.ralewayFont, color: Colors.black),
              onChanged: (out) => cardBloc.amountInputSink.add(amountMask.text),
              decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  labelText: "Total Amount",
                  border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }

  Widget creditCardWidget() {
    var deviceSize = MediaQuery.of(_context).size;
    return Container(
      height: deviceSize.height * 0.3,
      color: Colors.grey.shade300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 3.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: UIData.kitGradients)),
              ),
              Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "res/map.png",
                  fit: BoxFit.cover,
                ),
              ),
              MediaQuery.of(_context).orientation == Orientation.portrait
                  ? cardEntries()
                  : FittedBox(
                      child: cardEntries(),
                    ),
              Positioned(
                right: 10.0,
                top: 10.0,
                child: Icon(
                  FontAwesomeIcons.ccVisa,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
//              Positioned(
//                right: 10.0,
//                bottom: 10.0,
//                child: StreamBuilder<String>(
//                  stream: cardBloc.nameOutputStream,
//                  initialData: "Your Name",
//                  builder: (context, snapshot) => Text(
//                    snapshot.data.length > 0 ? snapshot.data : "Your Name",
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontFamily: UIData.ralewayFont,
//                        fontSize: 20.0),
//                  ),
//                ),
//              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardEntries() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder<String>(
                stream: cardBloc.ccOutputStream,
                initialData: "**** **** **** ****",
                builder: (context, snapshot) {
                  snapshot.data.length > 0
                      ? ccMask.updateText(snapshot.data)
                      : null;
                  return Text(
                    snapshot.data.length > 0
                        ? snapshot.data
                        : "**** **** **** ****",
                    style: TextStyle(color: Colors.white, fontSize: 22.0),
                  );
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<String>(
                    stream: cardBloc.expOutputStream,
                    initialData: "MM/YY",
                    builder: (context, snapshot) {
                      snapshot.data.length > 0
                          ? expMask.updateText(snapshot.data)
                          : null;
                      return ProfileTile(
                        textColor: Colors.white,
                        title: "Expiry",
                        subtitle:
                            snapshot.data.length > 0 ? snapshot.data : "MM/YY",
                      );
                    }),
                SizedBox(
                  width: 30.0,
                ),
                StreamBuilder<String>(
                    stream: cardBloc.cvvOutputStream,
                    initialData: "***",
                    builder: (context, snapshot) {
                      snapshot.data.length > 0
                          ? cvvMask.updateText(snapshot.data)
                          : null;
                      return ProfileTile(
                        textColor: Colors.white,
                        title: "CVV",
                        subtitle:
                            snapshot.data.length > 0 ? snapshot.data : "***",
                      );
                    }),
              ],
            ),
          ],
        ),
      );

  String SubscribeType;

  @override
  Widget build(BuildContext context) {
    if (payment == null) {
      payment = List<PaymentModel>();
      updateListView(); // get payment list
    }
    print(note.cardnumber);
    //ccMask.text = note.cardnumber;
    //expMask.text = note.expiry;
    //cvvMask.text = note.cvv;
    nameMask.text = note.name;
    cardname.text = note.cardnumber;
    expirycontroller.text = note.expiry;
    cvvcontroller.text = note.cvv;
    amountMask.text = note.amount;
    SubscribeType = note.subtype;

    dateToday = new DateFormat.yMMMd().format(todaydate);

    _context = context;
    cardBloc = CreditCardBloc();
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: bodyData(),
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

  Widget PaySuccessData() => Center(
          child: RaisedButton(
        shape: StadiumBorder(),
        onPressed: () => showSuccessDialog(),
        color: Colors.amber,
        child: Text("Add Payment"),
      )
//        isDataAvailable
//            ? RaisedButton(
//                shape: StadiumBorder(),
//                onPressed: () => showSuccessDialog(),
//                color: Colors.amber,
//                child: Text("Process Payment"),
//              )
//            : CircularProgressIndicator(),
          );

  void showSuccessDialog() {
    print("Mask Check " + ccMask.text);
    setState(() {
      isDataAvailable = false;
      if (_creditCardKey.currentState.validate()) {
        goToDialog();
      } else {
        _showAlertDialog(
            "Status", "Please Fill All Entries  to Process Payment");
      }
    });
  }

  goToDialog() {
    setState(() {
      isDataAvailable = true;
    });
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    successTicket(),
                    SizedBox(
                      height: 10.0,
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ));
  }

  successTicket() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Material(
          clipBehavior: Clip.antiAlias,
          elevation: 2.0,
          borderRadius: BorderRadius.circular(4.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ProfileTile(
                  title: "Thank You!",
                  textColor: Colors.purple,
                  subtitle: "Confirm Your Payment Details",
                ),
                ListTile(
                  title: Text("Date"),
                  subtitle: Text(dateToday),
                ),
                ListTile(
                  title: Text("Name : " + nameMask.text),
                  trailing: Text("Expiry : " + expMask.text),
                ),
                ListTile(
                  title: Text("Amount : " + amountMask.text),
                ),
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0.0,
                  color: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.ccVisa,
                      color: Colors.blue,
                    ),
                    title: Text("Credit/Debit Card"),
                    subtitle: Text("Card No : " + ccMask.text),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 8),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: HotelAppTheme.buildLightTheme().primaryColor,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(24.0)),
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
                        onTap: () async {
                          var j = payment
                              .where(
                                  (element) => element.subtype == SubscribeType)
                              .toList();
                          if (j.length > 0) {
                            _showAlertDialog('Alert',
                                'You have Already Subscribed for this Plan!!');
                            Navigator.of(context).pop();
                          } else {
                            _save();
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                        child: Center(
                          child: Text(
                            'Save Payment',
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

  void moveToLastScreen() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
  }

// Add payment method details

  void _save() async {
    int result;
    note.name = nameMask.text;
    note.cardnumber = ccMask.text;
    note.cvv = cvvMask.text;
    note.expiry = expMask.text;
    note.amount = amountMask.text;
    note.paydate = dateToday;
    note.status = "Successful";
    note.subtype = SubscribeType;

    if (note.id != null) {
      // Case 1: Update operation
      result = await helper.updatePayment(note);
      Navigator.pop(context, true);
      Navigator.of(context, rootNavigator: true).pop();
    } else {
      // Case 2: Insert Operation

      result = await helper.insertPaymentMethod(note);
      moveToLastScreen();
    }
    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Your Payment is Succesfully Added');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Payment Details');
    }
  }

  int count = 0;
  void updateListView() {
    var dbFuture = helper.initDb();
    dbFuture.then((database) {
      Future<List<PaymentModel>> noteListFuture = helper.getPaymentMethodList();
      noteListFuture.then((noteList) {
        setState(() {
          this.payment = noteList;
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
}
