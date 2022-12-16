import 'dart:io';
import 'package:gard_msg_flutter/Screens/CalenderScreen.dart';
import 'package:gard_msg_flutter/Services/LocalNotificationService.dart';
import 'package:provider/provider.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Providers/guardStatus.dart';
import 'package:gard_msg_flutter/Screens/Job/CurrentJobsScreen.dart';
import 'package:gard_msg_flutter/Screens/LoginScreen.dart';
import 'package:gard_msg_flutter/Screens/MessageScreen.dart';
import 'package:gard_msg_flutter/Widgets/boxForHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter/foundation.dart';

//import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../APIs/RestClient.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Models/CheckPoint.dart';
import '../Services/LocationService.dart';
import '../main.dart';
import 'AvailabilityScreen.dart';
import 'HistoryScreen.dart';
import 'WebViewScreen.dart';
import 'package:zoom_widget/zoom_widget.dart';
class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

String month = ' . . '; // don't change these values
String day = ' . . ';
String date = ' . . ';

String deviceType = '';
String name = '';
String officeName = '';
String gard_id = '';
String password = '';
String office_phone = '';
String threat_level = '';

class _HomeScreenState extends State<HomeScreen> {
  //bool availableForJob = true;
  final restClient = RestClient();
  int total_jobs = 0;
  int total_accepted_jobs = 0;
  int total__new_jobs = 0;
  int total_no_of_hours = 0;
  Color? greyButtons = Colors.grey[200];

  //LocationService locationService=LocationService();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitailData();
    checkHaveStartedJob(); //then start tracking init
    //round if from notification
    rountNext();
  }

  @override
  Widget build(BuildContext context) {
    print(
        'staus value is,,,,,,,,,,,,, ${Provider.of<GuardStatus>(context).getStatus()}');
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                      height: _width * 0.15,
                      color: Theme.of(context).primaryColor,
                      //padding: const EdgeInsets.only(top: 4, bottom: 4, right: 5),
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
                                  bool yes = await APICalls.logoutCall(context);
                                  if (yes) {
                                    if (Helper.logOut() == true) {
                                      Navigator.of(context)
                                          .pushNamed(LoginScreen.routeName);
                                    } else {
                                      Helper.Toast('Logout failed, try again',
                                          Constants.toast_red);
                                    }
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Current threat level',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100),
                              ),
                              Text(
                                threat_level,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: _width * 0.25,
                            height: _width * 0.1,
                            child: LiteRollingSwitch(
                              //initial value
                              value: Provider.of<GuardStatus>(context,
                                      listen: true)
                                  .getStatus(),
                              //availableForJob
                              textOn: 'Online',
                              textOff: 'Offline',
                              colorOn: Colors.greenAccent,
                              colorOff: Colors.redAccent,
                              iconOn: Icons.done,
                              iconOff: Icons.double_arrow_rounded,
                              textSize: 14.0,
                              textOffColor: Colors.white,
                              textOnColor: Colors.white,
                              onChanged: (bool state) async {
                                //Use it to manage the different states
                                print('Current State of SWITCH IS: $state');

                                bool done = await APICalls.statusChange(
                                    context, state ? "vacant" : "onbreak");
                                print('Current strus.....: $done');
                                if (done) {
                                  Provider.of<GuardStatus>(context)
                                      .changeStatus(state);
                                } else {
                                  Provider.of<GuardStatus>(context)
                                      .changeStatus(!state);
                                }
                                setState(() {});
                              },

                              onTap: () async {
                                //makeSelfOnline();
                                //print('before State of SWITCH IS: ${await LocalDatabase.isAvailable()}');
                              },
                              onDoubleTap: () {
                                //makeSelfOnline();
                              },
                              onSwipe: () {
                                //makeSelfOnline();
                              },
                            ),
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
                              color: greyButtons,
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
                                        elevation: 0,
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
                                        ) ,
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          'Accepted : $total_accepted_jobs ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.green),
                                        ),
                                        const Divider(
                                          thickness: 1,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'New : $total__new_jobs ',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.blueAccent
                                              //Constants.grey.withOpacity(0.8)
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: _width * 0.2,
                                      child: Card(
                                        elevation: 0,
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
                                    color: greyButtons,
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
                                    color: greyButtons,
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
                                    color: greyButtons,
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
                                      APICalls.sendAlert(context);
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
                                  Navigator.pushNamed(
                                      context, CalenderScreen.routeName);
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
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, HistoryScreen.routeName);
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'History',
                                    picture: 'assets/images/ic_history.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, AvailabilityScreen.routeName);
                                },
                                child: BoxForHome(
                                    width_box: _width * 0.25,
                                    hight_box: _width * 0.3,
                                    lableText: 'Availability',
                                    picture: 'assets/images/ic_availability.png'),
                              ),
                              InkWell(
                                onTap: () async {
                                  //Helper.stopTracking();
                                  String link =
                                      await APICalls.documentAPICall(context);
                                  if (link != 'null') {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => WebViewScreen(
                                                title: 'Documents',
                                                url: link)));
                                  }
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

  // void makeSelfOnline() {
  //   setState(() {
  //     availableForJob = !availableForJob;
  //   });
  // }

  void loadInitailData() async {
    name = await LocalDatabase.getString(LocalDatabase.NAME);
    officeName = await LocalDatabase.getString(LocalDatabase.USER_OFFICE);
    gard_id = await LocalDatabase.getString(LocalDatabase.GUARD_ID);
    password = await LocalDatabase.getString(LocalDatabase.USER_PASSWORD);
    office_phone = await LocalDatabase.getString(LocalDatabase.USER_MOBILE);
    threat_level = await LocalDatabase.getString(LocalDatabase.THREAT_LEVEL);

    if (Platform.isAndroid) {
      deviceType = 'Android';
    } else if (Platform.isIOS) {
      deviceType = 'IOS';
    }
    print(
        'after login detail is here  $officeName  \n $gard_id      \n   $password   ');
    Provider.of<GuardStatus>(context, listen: false)
        .changeStatus(await LocalDatabase.isAvailable() ?? false);
    DateTime now = DateTime.now();
    //print('day is ${DateFormat('EEEE').format(now)}');

    month = DateFormat.MMMM().format(now);
    date = DateFormat('dd').format(now);
    day = DateFormat('EEEE').format(now);
    getDashboardData(); //it has setState
    await Helper.determineCurrentPosition();
  }

  void getDashboardData() async {
    try {
      final parameters = {
        'type': Constants.DASHBOARD_TYPE,
        'office_name': officeName,
        'guard_id': gard_id,
        'password': password,
      };

      final respoce = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);
      print(
          'dashboard responce is hereeee.         $respoce   mmmmmmmm  ${respoce.data['DATA'][0]}');

      if (respoce.data['RESULT'] == 'OK' && respoce.data['msg'] == 'success') {
        total_jobs = respoce.data['DATA'][0]['total_jobs'];
        total_accepted_jobs = respoce.data['DATA'][0]['total_accepted_jobs'];
        total__new_jobs = respoce.data['DATA'][0]['total_jobs_new'];
        total_no_of_hours = respoce.data['DATA'][0]['total_no_of_hours'];
      } else {
        print("api not working... " + respoce.data['msg']);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
    }
  }

  void sendviaSms() async {
    await Helper.determineCurrentPosition();
    final parameters = {
      'type': Constants.RETURN_LINK,
      'office_name': officeName,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    print('link retrun is here...  $respoce');
    if (respoce.data['msg'] == 'success') {
      Helper.textviaSim(office_phone, respoce.data['DATA']['link']);
    }
  }

  void sendviaSystem() async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    try {
      final parameters = {
        'type': Constants.UPDATE_DRIVER_DOC,
        'office_name': officeName,
        'guard_id': gard_id,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.longitude.toString(),
      };
      final respoce = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      print('location update via system, respoce is here...  $respoce');
      if (respoce.data['msg'] == 'Current Location Updated') {
        Helper.Toast('Location updated', Constants.toast_grey);
      } else {
        Helper.Toast(
            'Can\'t update Location, please try again', Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void loadCheckCallsOfStartedJob(
    String job_id,
  ) async {
    print('etting check points');
    await Helper.determineCurrentPosition();

    final parameters = {
      'type': Constants.CHECK_POINTS,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_id': job_id,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    print(
        'response is here of check calls on home page is here  ${respoce.data} ');
    if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
      respoce.data['DATA'].forEach((value) {
        /*chkPoint_list.add(CheckPoint(
            barcode: respoce.data['DATA'][i]['barcode'],
            check_point_id: respoce.data['DATA'][i]['check_point_id'],
            guard_id: respoce.data['DATA'][i]['guard_id'],
            job_id: respoce.data['DATA'][i]['job_id'],
            name: respoce.data['DATA'][i]['name'],
            status: respoce.data['DATA'][i]['status'],
            time: respoce.data['DATA'][i]['time']));*/

        print('check point 1 is  ${value['status']}');
        if (value['status'] == '0') {
          //its upcoming check point
          print('check point alarm time is  ${value['time']}');
          DateTime tempTimeOfCheckPoint =
              DateFormat("dd-MM-yyyy hh:m:ss").parse(value['time']);

          print(
              'time ${tempTimeOfCheckPoint}, difference of  ${value['check_point_id']} is...   ${tempTimeOfCheckPoint.difference(Helper.getCurrentTime())}');
          if (!tempTimeOfCheckPoint
              .difference(Helper.getCurrentTime())
              .isNegative) {
            //check point is coming...
            localNotificationService.scheduleNotification(
                'Dear user Tap here ',
                'To check your job point',
                tempTimeOfCheckPoint.subtract(Duration(minutes: 15)),
                int.parse(value['check_point_id']));
          }
        }
      });
    }
    //print('check point 1 is  }');
  }

  void checkHaveStartedJob() async {
    //57440 start this job recently
    //await LocalDatabase.saveString(LocalDatabase.STARTED_JOB, '57440');
    String id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);

    print('id is  $id ');
    if (id != 'null') {
      //have start job
      loadCheckCallsOfStartedJob(id);
      Helper.checkJobAndTrack();
    }
  }

  void rountNext() async{
    String nextScreen = await LocalDatabase.getString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION);
    print('nextscreen:  $nextScreen}');
    if (nextScreen == Constants.NEXT_SCREEN_CURRENTJOBS) {
      Navigator.of(context).pushNamed(CurrentJobs.routeName);
    } else if (nextScreen == Constants.NEXT_SCREEN_MESSAGE) {
      Navigator.of(context).pushNamed(MessageScreen.routeName);
    } else {
      //remain here...
    }
    LocalDatabase.saveString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION, Constants.NEXT_SCREEN_HOME);
  }
}
