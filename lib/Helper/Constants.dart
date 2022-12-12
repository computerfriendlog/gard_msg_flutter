import 'dart:ui';
import 'package:flutter/material.dart';

class Constants {
  ///Strings
  static String BASE_URL =
      'https://guardapps.tbmslive.com/taxi_app/WebServices/';
  static String noInternetConnection = 'Check your internet connection';
  static String COMPLATED = "completed";
  static String DRIVER_STATUS_CHANGE = "driver_status_change";
  static String DRIVER_LOCATION_CHANGE = "save_driver_location";
  static String LOGIN_TYPE = "guard_login";
  static String DASHBOARD_TYPE = "dashboard";
  static String DRIVER_ATTENDANCE = "get_driver_attendance";
  static String RETURN_LINK = "return_link";
  static String AVAILABILITY_STORE = "available_store";
  static String HOLIDAY_STORE = "holiday_store";
  static String REQUEST_TIME_OFF = "request_time_off_store";
  static String UPDATE_DRIVER_DOC = "update_driver_loc";
  static String PANIC_ALERT = "panic_alert";
  static String DRIVER_LOGOUT = "driver_logout";
  static String END_PATROL = "end_patroling";
  static String PATROL_LISTING = "patrol_schedule_listing";
  static String TYPE_NEW_JOBS = "new_job";
  static String REJECT_GUARD = "guard_reject_job";
  static String START_PATROL = "start_patroling";
  static String JOB_DRIVER_RADIUS = "job_driver_radius";
  static String MESSAGE_LIST = "msg_transaction_list_driver";
  static String MESSAGE_SEND = "msg_transaction_to_operator";
  static String START_PATROL_WITH_PICTURE = "start_patroling_with_image";
  static String ACCEPT_GUARD = "guard_accept_job";
  static String TYPE_ACCEPTED_JOBS = "Accepted";
  static String CHECK_POINTS = "get_jobs_check_points";
  static String SAVE_NFC_RECORD = "save_nfc_record";
  static String SEND_INCIDENT = "save_job_incident";
  static String SAVE_VISITORS = "save_visitors_log";
  static String UPDATE_GUARD_LOCATION = "update_driver_loc";
  static String SAVE_GUARD_LOCATION = "save_driver_location";
  static String job_incidents_list = "job_incidents_list";
  static String CALL_CLIENT = "get_client_number";
  static String FETCH_VISITORS = "fetch_job_visitor_logs";
  static String INCIDENT_LIST = "incident_type_list";
  static String SEND_SIGNATURE = "save_job_signature";
  static String MANUAL_ACK_CHECKPOINT = "manual_acknowledge_check_points";
  static String SEND_ACK = "acknowledge_check_points";
  static String LOCATION_TRACK_TYPE_NORMAL = "normal";
  static String somethingwentwrong = "Something went wrong";

  ///icons
  static IconData ic_calender = Icons.calendar_month_outlined;
  static IconData ic_location = Icons.location_on_outlined;
  static IconData ic_arrow_forword = Icons.arrow_forward_ios_rounded;
  static IconData ic_phone = Icons.phone;
  static IconData ic_tik = Icons.done;
  static IconData ic_add = Icons.add;
  static IconData ic_cross = Icons.cancel_outlined;
  static IconData ic_camera = Icons.camera_alt;

  ///colors
  static Color toast_grey = Colors.grey;
  static Color toast_red = Colors.red;
  static Color grey = Colors.grey;
  static Color redAccent =
      Colors.redAccent.withOpacity(0.8) ?? Colors.redAccent;
}
