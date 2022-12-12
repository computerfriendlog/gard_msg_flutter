import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:gard_msg_flutter/Providers/DatePicked.dart';
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
import 'Helper/Helper.dart';
import 'Providers/guardStatus.dart';
import 'Screens/AvailabilityScreen.dart';
import 'Screens/CalenderScreen.dart';
import 'Screens/Job/AddIncidentScreen.dart';
import 'Screens/Job/AddVisitorScreen.dart';
import 'Screens/Job/CheckCallsScreen.dart';
import 'Screens/Job/FinishJobScreen.dart';
import 'Screens/Job/IncedentShowSceen.dart';
import 'Screens/Job/UpdateProgressScreen.dart';
import 'Screens/Job/VisitorShowScreen.dart';
import 'Services/LocalNotificationService.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
as bg;
/// To do
// in service after each 10 minuts
//CASE : guard_location_alert
//Params : job_id , guard_id , latitude , longitude

final LocalNotificationService localNotificationService =
    LocalNotificationService();

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void printHello() {

  final int isolateId = Isolate.current.hashCode;
  print(" Hello, world! isolate=${isolateId} ");
  final LocalNotificationService localNotification = LocalNotificationService();
  localNotification.initializNotifications();
  localNotification.sendNotification('By alarm...', ' body of alarm');
}
/// Receives all events from BackgroundGeolocation while app is terminated:
/// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('[HeadlessTask]: ${headlessEvent}');

  // Implement a `case` for only those events you're interested in.
  switch(headlessEvent.name) {
    case bg.Event.TERMINATE:
      bg.State state = headlessEvent.event;
      print('- State: ${state}');
      break;
    case bg.Event.HEARTBEAT:
      bg.HeartbeatEvent event = headlessEvent.event;
      print('- HeartbeatEvent: ${event}');
      break;
    case bg.Event.LOCATION:
      {
        bg.Location location = headlessEvent.event;
        print('- Location: ${location}');
        Helper.trackAndNotify(location.coords.latitude.toString(),location.coords.longitude.toString());
      }
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print('- Location: ${location}');
      break;
    case bg.Event.GEOFENCE:
      bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      print('- GeofenceEvent: ${geofenceEvent}');
      break;
    case bg.Event.GEOFENCESCHANGE:
      bg.GeofencesChangeEvent event = headlessEvent.event;
      print('- GeofencesChangeEvent: ${event}');
      break;
    case bg.Event.SCHEDULE:
      bg.State state = headlessEvent.event;
      print('- State: ${state}');
      break;
    case bg.Event.ACTIVITYCHANGE:
      bg.ActivityChangeEvent event = headlessEvent.event;
      print('ActivityChangeEvent: ${event}');
      break;
    case bg.Event.HTTP:
      bg.HttpEvent response = headlessEvent.event;
      print('HttpEvent: ${response}');
      break;
    case bg.Event.POWERSAVECHANGE:
      bool enabled = headlessEvent.event;
      print('ProviderChangeEvent: ${enabled}');
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      bg.ConnectivityChangeEvent event = headlessEvent.event;
      print('ConnectivityChangeEvent: ${event}');
      break;
    case bg.Event.ENABLEDCHANGE:
      bool enabled = headlessEvent.event;
      print('EnabledChangeEvent: ${enabled}');
      break;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localNotificationService.initializNotifications();
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ImagesArray>(
              create: (context) => ImagesArray()),
          ChangeNotifierProvider<GuardStatus>(
              create: (context) => GuardStatus()),
          ChangeNotifierProvider<DatePicked>(create: (context) => DatePicked()),
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
            CalenderScreen.routeName: (ctx) => CalenderScreen(),
            AvailabilityScreen.routeName: (ctx) => AvailabilityScreen(),
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
