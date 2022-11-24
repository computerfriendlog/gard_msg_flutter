import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:oktoast/oktoast.dart';

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
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    currentPositon = await Geolocator.getCurrentPosition();
    // List<Placemark> placemarks = await placemarkFromCoordinates(
    //     currentPositon.latitude, currentPositon.longitude);
    // print('current address ');
    // print(placemarks[0].name);
    // Placemark placemark = placemarks[0];
    // currentAddress =
    //     '${placemark.street} , ${placemark.subLocality}, ${placemark.postalCode}, ${placemark.country}';
    return currentPositon;
  }
  static void Toast(String msg,Color clr){
    showToast(
      msg,
      duration: const Duration(seconds: 2),
      position: ToastPosition.bottom,
      backgroundColor: clr,
      radius: 3.0,
      textStyle: const TextStyle(fontSize: 14.0),
    );
  }

  static void showLoading(BuildContext context){
      AlertDialog alert=AlertDialog(
        content:  Row(
          children: [
           const  CircularProgressIndicator(),
            Container(margin: const EdgeInsets.only(left: 5),child:const Text("Loading..." )),
          ],),
      );
      showDialog(barrierDismissible: false,
        context:context,
        builder:(BuildContext context){
          return alert;
        },
      );
  }

  static double distanceLatLong(double lat1,  double lon1, double lat2,double lon2) {
  return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
}
}
