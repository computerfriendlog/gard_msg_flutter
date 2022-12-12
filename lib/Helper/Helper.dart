import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:oktoast/oktoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../APIs/APICalls.dart';
import '../Services/LocalNotificationService.dart';

class Helper {
  static Position currentPositon = Position(
      longitude: 33.6163723,
      latitude: 72.8059114,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 1,
      heading: 1,
      speed: 1,
      speedAccuracy: 1);
  static String currentAddress = '';

  static Future<bool> isInternetAvailble() async {
    bool _isConnectionSuccessful = false;
    try {
      final response = await InternetAddress.lookup('www.google.com');
      _isConnectionSuccessful = response.isNotEmpty;
    } on SocketException catch (e) {
      _isConnectionSuccessful = false;
    }
    return _isConnectionSuccessful;
  }

  static bool logOut() {
    print('logout is going heree.....');
    bool logout = false;
    try {
      LocalDatabase.saveString(LocalDatabase.GUARD_ID, '');
      LocalDatabase.saveString(LocalDatabase.NAME, '');
      LocalDatabase.saveString(LocalDatabase.USER_NAME, '');
      LocalDatabase.saveString(LocalDatabase.USER_EMAIL, '');
      LocalDatabase.saveString(LocalDatabase.USER_ADDRESS, '');
      LocalDatabase.saveString(LocalDatabase.USER_MOBILE, '');
      LocalDatabase.setLogined(false);
      logout = true;
    } catch (e) {
      logout = false;
    }
    return logout;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static textviaSim(String phone, String msg) async {
    if (Platform.isAndroid) {
      var uri = 'sms:$phone?body=$msg%20there';
      await launch(uri);
    } else if (Platform.isIOS) {
      // iOS
      var uri = 'sms:$phone&body=$msg%20there';
      await launch(uri);
    }
  }

  static Future<Position> determineCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    print('0.......');
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    print('1.......');

    permission = await Geolocator.checkPermission();
    print('2.......');
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    print('4.......');

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    print('5.......');
    try{
      currentPositon = await Geolocator.getCurrentPosition(timeLimit: Duration(seconds: 10));
    }catch(e){
      print('6.......');
    }
    print('7.......');

    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     currentPositon.latitude, currentPositon.longitude);
    // print('current address ');
    // print(placemarks[0].name);
    // Placemark placemark = placemarks[0];
    // currentAddress =
    //     '${placemark.street} , ${placemark.subLocality}, ${placemark.postalCode}, ${placemark.country}';
    return currentPositon;
  }

  static void Toast(String msg, Color clr) {
    showToast(
      msg,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      backgroundColor: clr,
      radius: 5.0,
      textPadding: const EdgeInsets.all(8),
      textStyle: const TextStyle(fontSize: 20.0),
    );
  }

  static showLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingAnimationWidget.inkDrop(
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static double distanceLatLong(
      double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  static Widget LoadingWidget(BuildContext context) {
    return SizedBox(
      child: LoadingAnimationWidget.inkDrop(
        color: Theme.of(context).primaryColor,
        //leftDotColor: const Color(0xFF1A1A3F),
        //rightDotColor: const Color(0xFFEA3799),
        size: 50,
      ),
    );
  }

  static DateTime getCurrentTime() {
    return DateTime.now();
  }

  static void msgDialog(BuildContext context, double _hight, String msg) {
    Dialog rejectDialog_with_reason = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: _hight,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hi! ${name}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              Text(
                msg,
                style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.black),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => rejectDialog_with_reason);
  }

  static Future<TimeOfDay> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? picked_s = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (picked_s != null) selectedTime = picked_s;
    return selectedTime;
  }

  static trackAndNotify(String lat,String long){
    LocalNotificationService localNotification = LocalNotificationService();
    localNotification.initializNotifications();
    localNotification.sendNotification('Now you are here ',
        "${lat},${long}");
    APICalls.trackLocation(lat,
        long, '57440');
  }
}
