import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Providers/CurrentJobsProvider.dart';
import 'package:gard_msg_flutter/Providers/DatePicked.dart';
import 'package:gard_msg_flutter/Providers/ImagesArray.dart';
import 'package:gard_msg_flutter/Screens/Job/CurrentJobsScreen.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/SiteSchedule.dart';
import 'package:gard_msg_flutter/Screens/LoginScreen.dart';
import 'package:gard_msg_flutter/Screens/MessageScreen.dart';
import 'package:gard_msg_flutter/Screens/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'Helper/Constants.dart';
import 'Helper/Helper.dart';
import 'Providers/guardStatus.dart';
import 'Screens/AvailabilityScreen.dart';
import 'Screens/CalenderScreen.dart';
import 'Screens/HistoryScreen.dart';
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
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_notifications_handler/firebase_notifications_handler.dart';

/// To do

final LocalNotificationService localNotificationService =
    LocalNotificationService();

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void printHello() {
  final int isolateId = Isolate.current.hashCode;
  print(" Hello, world! isolate=${isolateId} ");
  final LocalNotificationService localNotification = LocalNotificationService();
  localNotification.initializNotifications();
  localNotification.sendNotification('Alarm...', 'Check your job point');
}

/// Receives all events from BackgroundGeolocation while app is terminated:
/// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
void headlessTask(bg.HeadlessEvent headlessEvent) async {
  print('[HeadlessTask]: ${headlessEvent}');
  // Implement a `case` for only those events you're interested in.
  switch (headlessEvent.name) {
    case bg.Event.TERMINATE:
      bg.State state = headlessEvent.event;
      print('- State: ${state}');
      break;
    case bg.Event.HEARTBEAT:
      //bg.HeartbeatEvent event = headlessEvent.event;
      //print('- HeartbeatEvent: ${event}');
      break;
    case bg.Event.LOCATION:
      {
        bg.Location location = headlessEvent.event;
        print('- Location: ${location}');
        Helper.trackAndNotify(location.coords.latitude.toString(),
            location.coords.longitude.toString());
      }
      break;
    case bg.Event.MOTIONCHANGE:
      bg.Location location = headlessEvent.event;
      print('- Location: ${location}');
      Helper.trackAndNotify(location.coords.latitude.toString(),
          location.coords.longitude.toString());
      break;
    case bg.Event.GEOFENCE:
      //bg.GeofenceEvent geofenceEvent = headlessEvent.event;
      //print('- GeofenceEvent: ${geofenceEvent}');
      break;
    case bg.Event.GEOFENCESCHANGE:
      //bg.GeofencesChangeEvent event = headlessEvent.event;
      //print('- GeofencesChangeEvent: ${event}');
      break;
    case bg.Event.SCHEDULE:
      //bg.State state = headlessEvent.event;
      //print('- State: ${state}');
      break;
    case bg.Event.ACTIVITYCHANGE:
      //bg.ActivityChangeEvent event = headlessEvent.event;
      //print('ActivityChangeEvent: ${event}');
      break;
    case bg.Event.HTTP:
      //bg.HttpEvent response = headlessEvent.event;
      //print('HttpEvent: ${response}');
      break;
    case bg.Event.POWERSAVECHANGE:
      //bool enabled = headlessEvent.event;
      //print('ProviderChangeEvent: ${enabled}');
      break;
    case bg.Event.CONNECTIVITYCHANGE:
      //bg.ConnectivityChangeEvent event = headlessEvent.event;
      //print('ConnectivityChangeEvent: ${event}');
      break;
    case bg.Event.ENABLEDCHANGE:
      //bool enabled = headlessEvent.event;
      //print('EnabledChangeEvent: ${enabled}');
      break;
  }
}

@pragma('vm:enry-point')
void notificationTap(navigatorState, appState, payload) async {
  Helper.Toast('appState: ', Constants.toast_grey);
  //showSnackBar('appState: $appState\npayload: $payload');
  print(
      " msg: Notification tapped with $appState & payload $payload % navigationState: $navigatorState");
  if (appState == "AppState.open") {
    //Navigator.pushNamed(context, CurrentJobs.routeName);
  } else {
    //app is closed
    if (payload != null) {
      String action = payload['action'];
      print('Action: $action');
      if (action == 'new_job') {
        //Navigator.pushNamed(context, CurrentJobs.routeName);
        // Future.delayed(Duration(
        //   seconds: 4,
        // )).then((value) async {selectedScreen=1; });
        LocalDatabase.saveString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION, Constants.NEXT_SCREEN_CURRENTJOBS);
      } else if (action == 'update_job') {
        LocalDatabase.saveString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION, Constants.NEXT_SCREEN_CURRENTJOBS);
      } else if (action == 'message') {
        LocalDatabase.saveString(LocalDatabase.SCREEN_OPEN_ON_NOTIFICATION, Constants.NEXT_SCREEN_MESSAGE);
      }
    }
  }
}

@pragma('vm:enry-point')
void notificationArrived(_, payload) {
  //Helper.Toast('arrived..fffffffffffffffffffffffffffffffffffff', Constants.toast_red);
  print(
    "msg: Notification received while app is open with payload $payload   and $_",
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  localNotificationService.initializNotifications();
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
  await AndroidAlarmManager.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FirebaseNotificationsHandler(
      onFCMTokenInitialize: (_, token) async {
        await LocalDatabase.saveString(
            LocalDatabase.FIREBASE_MSG_TOKEN, token!);
      },
      //=> fcmToken = token!
      onFCMTokenUpdate: (_, token) async {
        await LocalDatabase.saveString(
            LocalDatabase.FIREBASE_MSG_TOKEN, token!);
      },
      //defaultNavigatorKey: Globals.navigatorKey,
      onOpenNotificationArrive: notificationArrived,
      onTap: notificationTap,
      customSound: 'check_sound',
      channelId: 'sms_guard_chennalId',//should be same as in minifest


      child: OKToast(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<ImagesArray>(
                create: (context) => ImagesArray()),
            ChangeNotifierProvider<CurrentJobsProvider>(
                create: (context) => CurrentJobsProvider()),
            ChangeNotifierProvider<GuardStatus>(
                create: (context) => GuardStatus()),
            ChangeNotifierProvider<DatePicked>(
                create: (context) => DatePicked()),
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
              HistoryScreen.routeName: (ctx) => HistoryScreen(),
            },
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
