import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/Job/CheckCallsScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/VisitorShowScreen.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../HomeScreen.dart';
import 'IncedentShowSceen.dart';
import 'UpdateProgressScreen.dart';
import 'package:intl/intl.dart';

class FinishJobScreen extends StatefulWidget {
  static const routeName = '/FinishJobScreen';

  const FinishJobScreen({Key? key}) : super(key: key);

  @override
  State<FinishJobScreen> createState() => _FinishJobScreenState();
}

class _FinishJobScreenState extends State<FinishJobScreen> {
  NewJob? job;
  final restClient = RestClient();

  String remainingTime = Constants
      .COMPLATED; // completed meas job can be end now otherwise it will carry remaining time
  DateTime? tempDate;
  NFCAvailability? nfc_available;
  var hight;
  var width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   checkNFCAvailability();
    // });
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)?.settings.arguments as NewJob?;

    checkJobRemainingTime();

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    hight = mediaQueryData.size.height;
    width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Site Schedule',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Helper.makePhoneCall(office_phone);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Constants.ic_phone,
                  size: 30,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        width: width,
        height: hight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: hight * 0.35,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          CheckCallsScreen.routeName,
                          arguments: job!);
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_check_points.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Check calls',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${job!.check_point_count.toString()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          IncedentShowScreen.routeName,
                          arguments: job!);
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_incidents.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Incidents',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${job!.incidents_count.toString()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          VisitorShowScreen.routeName,
                          arguments: job!);
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_visitor.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Visitors',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 35,
                            width: 35,
                            child: Stack(
                              children: [
                                const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${job!.visitors_log_count.toString()}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      //nfc call
                      print('nfc click');
                      nfcCall();
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_nfc.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'NFC',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                            width: 35,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          APICalls.sendAlert(context);
                        },
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_sos.png'),
                              const Text(
                                'SOS\nmsg',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, UpdateProgressScreen.routeName);
                        },
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_update_pro.png'),
                              const Text(
                                'Update\nprog',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          updateLocation();
                        },
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_scan.png'),
                              const Text(
                                'Update\nlocation',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job!.job_date.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  job!.job_id.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start : ${job!.start_time.toString()}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'End  : ${job!.end_time.toString()}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${job!.no_of_hours.toString()} Hours',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Time left $remainingTime',
                  style: const TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Constants.ic_location,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    Text(
                      '${job!.sites.toString()}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Icon(
                  Constants.ic_arrow_forword,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            SizedBox(
              width: width * 0.8,
              child: ElevatedButton(
                  onPressed: () {
                    /// finish job here
                    if (remainingTime == Constants.COMPLATED) {
                      finishJob();
                    } else {
                      Helper.msgDialog(context,
                          'Finish your job on time, Or ask your office to mark completed.',
                          () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Text(
                      'Finish Job',
                      style: TextStyle(
                          color: remainingTime == Constants.COMPLATED
                              ? Colors.white
                              : Colors.white.withOpacity(0.6),
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  void updateLocation() async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);

    try {
      final parameters = {
        'type': Constants.UPDATE_GUARD_LOCATION,
        'office_name': officeName,
        'guard_id': gard_id,
        'job_id': job_id,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.latitude.toString(),
      };
      final respoce = await restClient.post(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      print('response is here of location update  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Your office has been notified about your location',
            Constants.toast_grey);
      } else {
        Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void finishJob() async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    print('finish job ->${job_id}');
    try {
      final parameters = {
        'type': Constants.END_PATROL,
        'office_name': officeName,
        'guard_id': gard_id,
        'job_id': job_id,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.latitude.toString(),
      };
      final respoce = await restClient.post(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      print('response is here of job finishing  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        LocalDatabase.saveString(LocalDatabase.STARTED_JOB, "null");
        Navigator.pop(context);
        Navigator.pushNamed(context, HomeScreen.routeName);
        Helper.stopTracking();
        Helper.Toast('Job finished successfully', Constants.toast_grey);
      } else {
        Navigator.pop(context);
        Helper.Toast(
            "Can\'t finish job, Please try again", Constants.toast_red);
      }
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void checkJobRemainingTime() {
    try {
      tempDate = DateFormat("hh:m")
          .parse(job!.end_time!.toString()); //dd-MM-yyyy hh:m:ss
      //print('end time is ${tempDate!.hour}     ${Helper.getCurrentTime().hour}');
      if (Helper.getCurrentTime().hour >= tempDate!.hour) {
        if (Helper.getCurrentTime().minute >= (tempDate!.minute)) {
          //job can end
          remainingTime = Constants
              .COMPLATED; // completed meas job can be end now otherwise it will carry remaining time
        } else {
          remainingTime =
              '00 :  ${(tempDate!.minute - Helper.getCurrentTime().minute).toString()}';
        }
      } else {
        remainingTime = "${tempDate!.hour - Helper.getCurrentTime().hour} : 00";
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void nfcCall() async {
    nfc_available = await FlutterNfcReader.checkNFCAvailability();
    print(
        'nfc click   ${nfc_available.toString()}    ${nfc_available!.index.toString()}');
    Helper.msgDialog(context,
        'NFC info \n  ${nfc_available.toString()}  ${nfc_available!.index.toString()}',
        () {
      Navigator.pop(context);
    });
    if (nfc_available!.index.toString() == '0') {
      //NFCAvailability.not_supported
      // nfc number
      FlutterNfcReader.read(instruction: "It's reading").then((value) => {
            //print('after reading...   ${value} '),
            Helper.Toast('after reading   ${value}', Constants.toast_grey),
             Helper.msgDialog(
                 context, 'received info from nfc \n id: ${value.id} .\n status: ${value.status} .\n content: ${value.content}  \nstatusMapper: ${value.statusMapper}  \n${value.error}', () {
               Navigator.pop(context);
             }),
            nfcAPICall(value.content.toString()),
          });
    } else {
      Helper.Toast('NFC not supported', Constants.toast_grey);
    }
  }

  void nfcAPICall(String nfc_number) async {
    await Helper.determineCurrentPosition();
    try {
      final parameters = {
        'type': Constants.SAVE_NFC_RECORD,
        'office_name': officeName,
        'job_id': job!.job_id,
        'nfc_number': nfc_number,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.longitude.toString(),
      };
      final respoce = await restClient.post(Constants.BASE_URL + "",
          headers: {}, body: parameters);

      print('response is here of nfc api  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {

        Helper.Toast('NFC updated', Constants.toast_grey);
      } else {
        Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Helper.Toast('NFC exception: ${e.toString()}', Constants.toast_red);
      Navigator.pop(context);
    }
  }
}
