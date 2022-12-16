import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/FinishJobScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:signature/signature.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';

class UpdateProgressScreen extends StatefulWidget {
  static const routeName = '/UpdateProgressScreen';

  const UpdateProgressScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProgressScreen> createState() => _UpdateProgressScreenState();
}

class _UpdateProgressScreenState extends State<UpdateProgressScreen> {
  final restClient = RestClient();
  bool sendDetailsThroughApp = true;
  TextEditingController _controller_msg = TextEditingController();
  final SignatureController _controller_signature = SignatureController(
    penStrokeWidth: 8,
    penColor: Colors.white,
    exportBackgroundColor: Colors.grey[800],
  );

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Update progress',
                style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
              ),
              actions: [
                InkWell(
                    onTap: () {
                      ///update location
                      updateLocation();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      margin: const EdgeInsets.all(10),
                      /* decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),*/
                      child: Icon(
                        Constants.ic_location,
                        color: Colors.white,
                        size: 35,
                      ),
                    )),
              ],
            ),
            body: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              width: width,
              height: hight,
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Helper.makePhoneCall(office_phone);
                            },
                            child: Container(
                              width: width * 0.4,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.grey[300]),
                              child: const Center(
                                  child: Text(
                                'Call office',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w100),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              callClient();
                            },
                            child: Container(
                              width: width * 0.4,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.grey[300]),
                              child: const Center(
                                  child: Text(
                                'Call Client',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w100),
                              )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              // select sms
                              sendDetailsThroughApp = false;
                              setState(() {});
                            },
                            child: Container(
                              width: width * 0.4,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: !sendDetailsThroughApp
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]),
                              child: Center(
                                  child: Text(
                                'SMS',
                                style: TextStyle(
                                    color: !sendDetailsThroughApp
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100),
                              )),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // set app
                              sendDetailsThroughApp = true;
                              setState(() {});
                            },
                            child: Container(
                              width: width * 0.4,
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: sendDetailsThroughApp
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[300]),
                              child: Center(
                                  child: Text(
                                'App',
                                style: TextStyle(
                                    color: sendDetailsThroughApp
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w100),
                              )),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: TextFormField(
                          cursorColor: Colors.white,
                          controller: _controller_msg,
                          keyboardType: TextInputType.text,
                          maxLines: 5,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white.withOpacity(0.1),
                              filled: true,
                              contentPadding: const EdgeInsets.all(0),
                              hintText: 'Write Message Here',
                              hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.8),
                                  fontWeight: FontWeight.w300)
                              //labelText: hint,
                              ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Write your signature below',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _controller_signature.clear();
                              },
                              child: const Text('Clear',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500))),
                        ],
                      ),
                      Signature(
                        controller: _controller_signature,
                        width: width * 0.9,
                        height: hight * 0.2,
                        backgroundColor: Colors.grey[600]!,
                      ),
                      CustomButton('Send', width * 0.8, () async {
                        //submit progress
                        if (_controller_msg.text.isEmpty) {
                          Helper.Toast('Message required', Constants.toast_red);
                        } else if (_controller_signature.isEmpty) {
                          Helper.Toast(
                              'Signature required', Constants.toast_red);
                        } else {
                          if (sendDetailsThroughApp) {
                            //submitProgress();
                            sendSignatureThenMsg();
                          } else {
                            Helper.textviaSim(
                                office_phone, _controller_msg.text.toString());
                          }
                        }
                      }),
                    ],
                  ),
                ],
              ),
            )));
  }

  void callClient() async {
    Helper.showLoading(context);
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    try {
      final parameters = {
        'type': Constants.CALL_CLIENT,
        'office_name': officeName,
        'job_id': job_id,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('respose is here of client phone number ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.makePhoneCall(respoce.data['DATA'][0]['client_number']);
      } else {
        Helper.Toast("Number not found", Constants.toast_grey);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }

  void updateLocation() async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);

    try {
      final parameters = {
        'type': Constants.SAVE_GUARD_LOCATION,
        'office_name': officeName,
        'guard_id': gard_id,
        'job_id': job_id,
        'latitude': Helper.currentPositon.latitude.toString(),
        'longitude': Helper.currentPositon.latitude.toString(),
        'track_type': Constants.LOCATION_TRACK_TYPE_NORMAL,
      };
      final respoce = await restClient.post(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);

      print('response is here of location update  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast(
            'Guard location updated successfully', Constants.toast_grey);
      } else {
        Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

/*  void submitProgress() async {
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    try {
      final parameters = {
        'type': Constants.CALL_CLIENT,
        'office_name': officeName,
        'job_id': job_id,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('respose is here of client phone number ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
        Navigator.pushNamed(context, FinishJobScreen.routeName);
      } else {
        Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }*/

  void sendSignatureThenMsg() async {
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    try {
      final Uint8List? singatureImageInBytes =
          await _controller_signature.toPngBytes(height: 400, width: 1000);
      final parameters = {
        'type': Constants.SEND_SIGNATURE,
        'office_name': officeName,
        'job_id': job_id,
        'sign_img': singatureImageInBytes,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('respose is here of client signature sent${respoce.data} ');
      Navigator.pop(context);
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        await APICalls.sendSmsViaApp(context,
            _controller_msg.text.trim()); // add signature url also in msg
        Navigator.pushNamed(context, FinishJobScreen.routeName);
      } else {
        Helper.Toast(Constants.somethingwentwrong + ' Please through app',
            Constants.toast_grey);
      }
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong + ' Please through app',
          Constants.toast_red);
    }
  }
}
