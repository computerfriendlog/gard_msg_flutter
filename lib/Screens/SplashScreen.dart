import 'dart:io';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import '../Helper/Helper.dart';
import 'HomeScreen.dart';
import 'Job/CurrentJobsScreen.dart';
import 'LoginScreen.dart';
import 'package:permission_handler/permission_handler.dart';

import 'MessageScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  bool showBtn = false;
  String label = 'Next';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPermissionStatus();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

    return Scaffold(
      body: Container(
        width: _width,
        height: _hight,
        child: Stack(
          children: [
            Image.asset(
                width: _width,
                height: _hight,
                fit: BoxFit.fill,
                'assets/images/ic_splash.png'),
            showBtn
                ? Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomButton(label, _width * 0.9,
                          background: Colors.white, () {
                        checkPermissionStatus();
                      }),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void checkPermissionStatus() async {
    if (await Permission.locationAlways.status != PermissionStatus.granted) {
      Helper.msgDialog(context,
          'Please activate your location service to use this App: Location should be Set as All the time',
          () async {
        Navigator.pop(context);
        await Permission.locationAlways
            .request()
            .then((value) => {print('after request res is here   ${value}')});
        if (await Permission.locationAlways.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    } else if (await Permission.activityRecognition.status !=
        PermissionStatus.granted) {
      if (Platform.isAndroid) {
        Helper.msgDialog(context,
            'Please allow your physical activity service to use this App: Physical activity service should be Set as All the time',
            () async {
          Navigator.pop(context);
          if (await Permission.activityRecognition.request().isGranted) {
            checkPermissionStatus(); //recursive
          } else {
            showBtn = true;
            setState(() {});
            openAppSettings();
          }
        });
      } else if (Platform.isIOS) {
        Helper.msgDialog(
            context, 'Please allow sensors access to keep good performance.',
            () async {
          Navigator.pop(context);
          if (await Permission.sensors.request().isGranted) {
            checkPermissionStatus(); //recursive
          } else {
            showBtn = true;
            setState(() {});
            openAppSettings();
          }
        });
      }
    } else if (await Permission.camera.status != PermissionStatus.granted) {
      Helper.msgDialog(context, 'Please allow camera to take pictures',
          () async {
        Navigator.pop(context);
        if (await Permission.camera.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    } else if (await Permission.notification.status !=
        PermissionStatus.granted) {
      Helper.msgDialog(
          context, 'Please allow notifications to make it more reliable',
          () async {
        Navigator.pop(context);
        if (await Permission.notification.request().isGranted) {
          checkPermissionStatus(); //recursive
        } else {
          showBtn = true;
          setState(() {});
          openAppSettings();
        }
      });
    } else {
      //Helper.Toast('all permissions granted...', Constants.toast_grey);
      animationCall();
    }
  }

  void animationCall() {
    Helper.showLoading(context);
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    controller?.forward();
    animation?.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        //Navigator.of(context).pushNamed(LoginScreen.routeName);
        print('checking login......');
        LocalDatabase.isUserLogined().then((value) async {
          print('login.value is...$value');
          Navigator.pop(context);
          if (value) {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          } else {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          }
        });
      }
    });
    controller?.addListener(() {
      setState(() {});
    });
  }


}
