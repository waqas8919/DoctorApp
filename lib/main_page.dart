import 'package:doctorapp/Pages/DocAppointment.dart';
import 'package:doctorapp/TeleConsult/TeleMainScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'Pages/AppointmentList.dart';
import 'Pages/DoctorsList.dart';
import 'TeleConsult/TeleMainPageNew.dart';
import 'Utilities/DBHelper.dart';
import 'model/DocAppointmentModel.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DBHelper databaseHelper = DBHelper();
  List<DocAppointmentModel> docapoint;
  DocAppointmentModel checkdata;
  int doc_count = 0;

  void getDoccount() async {
    docapoint = await databaseHelper.getDoctorAppointmentInfoList();
    doc_count = docapoint.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text('Doctor',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0)),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  //Text('Dashboard', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 24.0)),
                ],
              ),
            )
          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _SearchClick(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Doctor',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Doctor Information          ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21.0))
                        ],
                      ),
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'res/doctor.png',
                                fit: BoxFit.cover,
                              ),
                            ))),
                      )
                    ]),
              ),
            ), // Search car clicked in dashboard
            _FavoriteClick(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Book Appointment',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Book your Appointment     ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0))
                        ],
                      ),
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'res/bookapnt.png',
                                fit: BoxFit.cover,
                              ),
                            ))),
                      )
                    ]),
              ),
            ), // Favorite car card in dashboard
            _AppointmentDetailClick(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Your Appointment',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('View Appointment Details ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 21.0))
                        ],
                      ),
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'res/listing.png',
                                fit: BoxFit.fill,
                              ),
                            ))),
                      )
                    ]),
              ),
            ), //post a car card in dashboard
            _TeleConsultationClick(
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('TeleConsultation',
                              style: TextStyle(color: Colors.blueAccent)),
                          Text('Remote diagnosis & Treatment',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 19.0))
                        ],
                      ),
                      Expanded(
                        child: Material(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'res/teleconsult.png',
                                fit: BoxFit.cover,
                              ),
                            ))),
                      )
                    ]),
              ),
            ), // listing car in dashboard
          ],
          staggeredTiles: [
            StaggeredTile.extent(2, 180.0),
            StaggeredTile.extent(2, 180.0),
            StaggeredTile.extent(2, 180.0),
            StaggeredTile.extent(2, 180.0),
          ],
        ));
  }

  Widget _SearchClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => DoctorInfoList()));
                  },
            child: child));
  }

  void SearcResults() async {}

  Widget _FavoriteClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => AppointmentScreen(
                                DocAppointmentModel("", "", "", "", "", "", "",
                                    "", false, "", ""),
                                "Appointment Details")));
                  },
            child: child));
  }

  Widget _AppointmentDetailClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () async {
                    docapoint =
                        await databaseHelper.getDoctorAppointmentInfoList();
                    doc_count = docapoint.length;
                    if (doc_count > 0) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  DoctorAppointmentInfoList()));
                    } else {
                      _showAlertDialog(
                          'Alert', 'Your havent Booked Any Appointment');
                    }
                  },
            child: child));
  }

  Widget _TeleConsultationClick(Widget child, {Function() onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => TeleConsultScreenNew()));
                  },
            child: child));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
