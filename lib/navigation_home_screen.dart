import 'package:doctorapp/Pages/SubscriptionPage.dart';
import 'package:doctorapp/Profile/UserProfile.dart';
import 'package:doctorapp/Utilities/DBHelper.dart';
import 'package:doctorapp/model/PaymentModel.dart';
import 'package:flutter/material.dart';
import 'Pages/AppointmentList.dart';
import 'Pages/DocAppointment.dart';
import 'Pages/DoctorsList.dart';
import 'Profile/NewUserProfile.dart';
import 'Pages/PaymentList.dart';
import 'app_theme.dart';
import 'custom_drawer/drawer_user_controller.dart';
import 'custom_drawer/home_drawer.dart';
import 'home_screen.dart';
import 'model/DocAppointmentModel.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  AnimationController sliderAnimationController;
  DBHelper databaseHelper = DBHelper();
  List<PaymentModel> paymentmodel;
  int count = 0;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            animationController: (AnimationController animationController) {
              sliderAnimationController = animationController;
            },
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = const MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        setState(() {
          screenView = NavigateToDocInfo();
        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        setState(() {
          screenView = NavigateToDocAppointment();
        });
      } else if (drawerIndex == DrawerIndex.Invite) {
        setState(() {
          screenView = NavigateAppointmentList();
        });
      } else if (drawerIndex == DrawerIndex.Listing) {
        setState(() {
          screenView = ListingResults();
        });
      } else if (drawerIndex == DrawerIndex.About) {
        setState(() {
          screenView = subsscriptionPage();
        });
      } else if (drawerIndex == DrawerIndex.Transactions) {
        setState(() {
          screenView = TransactionHistoryPage();
        });
      } else if (drawerIndex == DrawerIndex.Profile) {
        setState(() {
          screenView = Profiling();
        });
      } else {
        //do in your way......
      }
    }
  }

  NavigateToDocInfo() async {
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => DoctorInfoList()));
  }

  NavigateToDocAppointment() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => AppointmentScreen(
                DocAppointmentModel(
                    "", "", "", "", "", "", "", "", false, "", ""),
                "Appointment Details")));
  }

  NavigateAppointmentList() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => DoctorAppointmentInfoList()));
  }

  void SearcResults() async {}
  ListingResults() async {}
  subsscriptionPage() async {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => SubscriptionScreen("Subscription")));
  }

  int payment_count = 0;
  TransactionHistoryPage() async {
    paymentmodel = await databaseHelper.getPaymentMethodList();
    payment_count = paymentmodel.length;
    if (payment_count > 0) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => PayMethodList()));
    } else {
      _showAlertDialog(
          "Alert!", "Please Subscribe For Any Package from Subscription!!");
    }
  }

  Profiling() async {
    count = await databaseHelper.getMyProfileCount();
    print('Count issss : ' + count.toString());
    if (count > 0) {
      Navigator.push(context,
          new MaterialPageRoute(builder: (context) => ProfileInfoList()));
    } else {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => ProfilePage()));
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
