import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  ///Strings
  static String BASE_URL = 'https://guardapps.tbmslive.com/taxi_app/WebServices/';
  static String noInternetConnection = 'Check your internet connection';
  static String LOGIN_TYPE = "guard_login";
  static String DASHBOARD_TYPE = "dashboard";
  static String RETURN_LINK = "return_link";
  static String UPDATE_DRIVER_DOC = "update_driver_loc";
  static String PANIC_ALERT = "panic_alert";
  static String PATROL_LISTING = "patrol_schedule_listing";
  static String TYPE_NEW_JOBS = "new_job";
  static String REJECT_GUARD = "guard_reject_job";
  static String START_PATROL = "start_patroling";
  static String ACCEPT_GUARD = "guard_accept_job";
  static String TYPE_ACCEPTED_JOBS = "Accepted";
  static String somethingwentwrong = "Something went wrong";

  ///icons
  static IconData ic_calender=Icons.calendar_month_outlined;
  static IconData ic_location=Icons.location_on_outlined;
  static IconData ic_arrow_forword=Icons.arrow_forward_ios_rounded;

  ///colors
  static Color toast_grey = Colors.grey;
  static Color toast_red = Colors.red;
  static Color grey = Colors.grey;
  static Color redAccent =
      Colors.redAccent.withOpacity(0.8) ?? Colors.redAccent;

}
