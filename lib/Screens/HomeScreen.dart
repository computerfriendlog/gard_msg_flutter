import 'dart:io';

import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Screens/Job/CurrentJobsScreen.dart';
import 'package:gard_msg_flutter/Screens/LoginScreen.dart';
import 'package:gard_msg_flutter/Screens/MessageScreen.dart';
import 'package:gard_msg_flutter/Widgets/boxForHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';

import '../APIs/RestClient.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String month = '';
String day = '';
String date = '';

String deviceType = '';
String name = '';
String officeName = '';
String gard_id = '';
String password = '';
String office_phone = '';

class _HomeScreenState extends State<HomeScreen> {
  bool availableForJob = true;
  final restClient = RestClient();
  int total_jobs = 0;
  int total_accepted_jobs = 0;
  int total__new_jobs = 0;
  int total_no_of_hours = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitailData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: _hight,
            width: _width,
            child: ListView(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: _width * 0.13,
                      color: Theme.of(context).primaryColor,
                      padding:
                          const EdgeInsets.only(top: 4, bottom: 4, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () async {
                                bool result = await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        //title: Text('Confirmation'),
                                        content: const Text(
                                            'Do you want to logout from this application?'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(
                                                      false); // dismisses only the dialog and returns false
                                            },
                                            child: const Text('No'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(
                                                      true); // dismisses only the dialog and returns true
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      );
                                    });
                                if (result) {
                                  print('logout');
                                  if (Helper.logOut() == true) {
                                    Navigator.of(context)
                                        .pushNamed(LoginScreen.routeName);
                                  } else {
                                    showToast(
                                      "Logout failed, try again",
                                      duration: const Duration(seconds: 1),
                                      position: ToastPosition.top,
                                      backgroundColor:
                                          Colors.black.withOpacity(0.8),
                                      radius: 3.0,
                                      textStyle:
                                          const TextStyle(fontSize: 14.0),
                                    );
                                  }
                                } else {
                                  print('don\'t logout');
                                }
                              },
                              icon: const Icon(
                                Icons.logout,
                                size: 30,
                                color: Colors.white,
                              )),
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 23,
                                fontWeight: FontWeight.w400),
                          ),
                          LiteRollingSwitch(
                            //initial value
                            value: availableForJob,
                            textOn: 'Online',
                            textOff: 'Offline',
                            colorOn: Colors.greenAccent,
                            colorOff: Colors.redAccent,
                            iconOn: Icons.done,
                            iconOff: Icons.double_arrow_rounded,
                            textSize: 15.0,
                            textOffColor: Colors.white,
                            textOnColor: Colors.white,
                            onChanged: (bool state) {
                              //Use it to manage the different states
                              print('Current State of SWITCH IS: $state');
                              LocalDatabase.setAvailable(availableForJob);
                            },
                            onTap: () {
                              makeSelfOnline();
                            },
                            onDoubleTap: () {
                              makeSelfOnline();
                            },
                            onSwipe: () {
                              makeSelfOnline();
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: _hight * 0.85,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                color: Colors.black,
                                size: 30,
                              ),
                              Text(
                                'Guard : ${name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 14),
                              )
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              border:
                                  Border.all(width: 0.5, color: Constants.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.only(
                                top: 5, left: 5, right: 5),
                            margin: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: _width * 0.2,
                                      child: Card(
                                        elevation: 5,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.9),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                month.split('')[0] +
                                                    month.split('')[1] +
                                                    month.split('')[2],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Card(
                                              elevation: 0,
                                              color: Constants.redAccent,
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                      date,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                      day.split('')[0] +
                                                          day.split('')[1] +
                                                          day.split('')[2],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          '${total_accepted_jobs} Accepted',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          '${total__new_jobs} New',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w100,
                                              fontSize: 16,
                                              color: Constants.grey
                                                  .withOpacity(0.8)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: _width * 0.2,
                                      child: Card(
                                        elevation: 5,
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.9),
                                        child: Column(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                '  Total ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Card(
                                              elevation: 0,
                                              color: Constants.redAccent,
                                              child: Column(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(3.0),
                                                    child: Text(
                                                      ' ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                      '${total_jobs}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Total hours last 7 days: $total_no_of_hours',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.6)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                top: 5, right: 25, left: 25, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.only(top: 5, bottom: 5),
                                  width: _width * 0.19,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        width: 0.5, color: Constants.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            width: 35,
                                            height: 35,
                                            'assets/images/ic_call_office.png'),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.0, bottom: 5),
                                          child: Text(
                                            'Call office',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      //call to office
                                      print('phone nummber is $office_phone');
                                      Helper.makePhoneCall(office_phone);
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: _width * 0.19,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        width: 0.5, color: Constants.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            width: 35,
                                            height: 35,
                                            'assets/images/ic_location.png'),
                                        //ic_location     ic_emergency
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.0, bottom: 5),
                                          child: Text(
                                            'Location',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      print('getting current location...');
                                      bool via_system = await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              //title: Text('Confirmation'),
                                              content: const Text(
                                                  'Share you location via'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(
                                                            false); // dismisses only the dialog and returns false
                                                  },
                                                  child: const Text('SMS'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop(
                                                            true); // dismisses only the dialog and returns true
                                                  },
                                                  child: const Text('System'),
                                                ),
                                              ],
                                            );
                                          });
                                      await Helper.determineCurrentPosition();
                                      if (via_system) {
                                        //update via system
                                        sendviaSystem();
                                      } else {
                                        //send via sms
                                        sendviaSms();
                                        //print('location issss ${Helper.currentPositon.latitude}');
                                      }
                                    },
                                  ),
                                ),
                                Container(
                                  width: _width * 0.19,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        width: 0.5, color: Constants.grey),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: InkWell(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                            width: 35,
                                            height: 35,
                                            'assets/images/ic_emergency.png'),
                                        //ic_location     ic_emergency
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 15.0, bottom: 5),
                                          child: Text(
                                            'Emergency',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      //call to office
                                      //print('caaaaaaaaaaaaaaaaalin');
                                      sendAlert();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(CurrentJobs.routeName);
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Current jobs',
                                    picture: 'assets/images/ic_patrol.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, MessageScreen.routeName);
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Office messages',
                                    picture: 'assets/images/ic_msg.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  print('clndr  on tap');
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Calendar',
                                    picture: 'assets/images/ic_setting.png'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () {
                                  print('job on tap');
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'History',
                                    picture: 'assets/images/ic_history.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  print('ofic msg on tap');
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Availability',
                                    picture:
                                        'assets/images/ic_availability.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  print('clndr  on tap');
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Document',
                                    picture: 'assets/images/ic_document.png'),
                              ),
                            ],
                          ),
                          const Divider(
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  void makeSelfOnline() {
    setState(() {
      availableForJob = !availableForJob;
    });
  }

  void loadInitailData() async {
    name = await LocalDatabase.getString(LocalDatabase.NAME);
    officeName = await LocalDatabase.getString(LocalDatabase.USER_OFFICE);
    gard_id = await LocalDatabase.getString(LocalDatabase.GUARD_ID);
    password = await LocalDatabase.getString(LocalDatabase.USER_PASSWORD);
    office_phone = await LocalDatabase.getString(LocalDatabase.USER_MOBILE);

    if (Platform.isAndroid) {
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      deviceType = 'IOS';
    }
    print(
        'after login detail is here  $officeName  \n $gard_id      \n   $password   ');
    availableForJob = await LocalDatabase.isAvailable() ?? false;
    DateTime now = DateTime.now();
    //print('day is ${DateFormat('EEEE').format(now)}');

    month = DateFormat.MMMM().format(now);
    date = DateFormat('dd').format(now);
    day = DateFormat('EEEE').format(now);
    setState(() {});
    getDashboardData();
    await Helper.determineCurrentPosition();
  }

  void getDashboardData() async {
    final parameters = {
      'type': Constants.DASHBOARD_TYPE,
      'office_name': officeName,
      'guard_id': gard_id,
      'password': password,
    };

    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);
    print(
        'dashboard responce is hereeee.         $respoce   mmmmmmmm  ${respoce.data['DATA'][0]}');
    if (respoce.data['RESULT'] == 'OK' && respoce.data['msg'] == 'success') {
      total_jobs = respoce.data['DATA'][0]['total_jobs'];
      total_accepted_jobs = respoce.data['DATA'][0]['total_accepted_jobs'];
      total__new_jobs = respoce.data['DATA'][0]['total_jobs_new'];
      total_no_of_hours = respoce.data['DATA'][0]['total_no_of_hours'];
      setState(() {});
    } else {
      print("api not working... " + respoce.data['msg']);
    }
  }

  void sendviaSms() async {
    final parameters = {
      'type': Constants.RETURN_LINK,
      'office_name': officeName,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('link retrun is here...  $respoce');
    if (respoce.data['msg'] == 'success') {
      Helper.textviaSim(office_phone, respoce.data['DATA']['link']);
    }
  }

  void sendviaSystem() async {
    final parameters = {
      'type': Constants.UPDATE_DRIVER_DOC,
      'office_name': officeName,
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
    };
    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('location update via system, respoce is here...  $respoce');
    if (respoce.data['msg'] == 'Current Location Updated') {
      showToast(
        "Location updated",
        duration: const Duration(seconds: 1),
        position: ToastPosition.top,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 14.0),
      );
    } else {
      showToast(
        "Can\'t update Location, please try again",
        duration: const Duration(seconds: 1),
        position: ToastPosition.top,
        backgroundColor: Colors.black.withOpacity(0.8),
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 14.0),
      );
    }
  }

  void sendAlert() async {
    final parameters = {
      'type': Constants.PANIC_ALERT,
      'office_name': officeName,
      'guard_id': gard_id,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('alert sent, respoce is here...  $respoce');
    if (respoce.data['msg'] == 'Alert sent') {
      showToast(
        "Alert sent",
        duration: const Duration(seconds: 1),
        position: ToastPosition.top,
        backgroundColor: Colors.green,
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 14.0),
      );
    } else {
      showToast(
        "Alert can\'t send, please try again",
        duration: const Duration(seconds: 1),
        position: ToastPosition.top,
        backgroundColor: Colors.green,
        radius: 3.0,
        textStyle: const TextStyle(fontSize: 14.0),
      );
    }
  }
}
