import 'package:gard_msg_flutter/Screens/Camera/TakePictureScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/CurrentJobsScreen.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/SiteSchedule.dart';
import 'package:gard_msg_flutter/Screens/LoginScreen.dart';
import 'package:gard_msg_flutter/Screens/MessageScreen.dart';
import 'package:gard_msg_flutter/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'Screens/Job/FinishJobScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      OKToast(
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'CustomFont',
          primarySwatch: Colors.red,
        ),
        routes: {
          SplashScreen.routeName: (ctx) => SplashScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          CurrentJobs.routeName: (ctx) => CurrentJobs(),
          SiteSchedule.routeName: (ctx) => SiteSchedule(),
          FinishJobScreen.routeName: (ctx) => FinishJobScreen(),
          MessageScreen.routeName: (ctx) => MessageScreen(),
        },
        home: const SplashScreen(),
    ),
      );
  }
}
