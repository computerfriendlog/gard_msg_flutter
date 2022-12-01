import 'package:gard_msg_flutter/Providers/ImagesArray.dart';
import 'package:gard_msg_flutter/Screens/Camera/TakePictureScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/CurrentJobsScreen.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/SiteSchedule.dart';
import 'package:gard_msg_flutter/Screens/LoginScreen.dart';
import 'package:gard_msg_flutter/Screens/MessageScreen.dart';
import 'package:gard_msg_flutter/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Providers/guardStatus.dart';
import 'Screens/Job/AddIncidentScreen.dart';
import 'Screens/Job/AddVisitorScreen.dart';
import 'Screens/Job/CheckCallsScreen.dart';
import 'Screens/Job/FinishJobScreen.dart';
import 'Screens/Job/IncedentShowSceen.dart';
import 'Screens/Job/UpdateProgressScreen.dart';
import 'Screens/Job/VisitorShowScreen.dart';

/// To do
// in service after each 10 minuts
//CASE : guard_location_alert
//Params : job_id , guard_id , latitude , longitude


// before starting job call
//case"job_driver_radius":
// 						$job_id = $_REQUEST['job_id'];
// 						$latitude  = $_REQUEST['latitude'];
// 						$longitude = $_REQUEST['longitude'];


// Condition of above
//  if status = 1 --> allow guard start
//  if status = 0 --> errors related to job_id, guard_id , site name etc
//  if status = 2 -- > I am afraid we cannot identify your location, kindly provide sorrounding image and a reason
//  if status = 3 -- > I am afraid we cannot identify your location, kindly call office to get shift started

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ImagesArray>( create: (context) => ImagesArray()),
          ChangeNotifierProvider<GuardStatus>( create: (context) => GuardStatus()),
        ],
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
            CheckCallsScreen.routeName: (ctx) => CheckCallsScreen(),
            IncedentShowScreen.routeName: (ctx) => IncedentShowScreen(),
            AddIncidentScreen.routeName: (ctx) => AddIncidentScreen(),
            VisitorShowScreen.routeName: (ctx) => VisitorShowScreen(),
            AddVisitorScreen.routeName: (ctx) => AddVisitorScreen(),
            UpdateProgressScreen.routeName: (ctx) => UpdateProgressScreen(),
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
