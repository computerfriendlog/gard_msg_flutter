import 'package:flutter/cupertino.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Helper/LocalDatabase.dart';
import '../Screens/HomeScreen.dart';
import 'RestClient.dart';
import 'package:dio/dio.dart';

class APICalls {
  static Future sentAcknowledgement(
      BuildContext context, String job_id, String img_path) async {
    await Helper.determineCurrentPosition();
    FormData? formData;
    if (img_path != 'na') {
      String fileName = img_path.split('/').last;
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(img_path, filename: fileName),
      });
    }
    final parameters = {
      'type': Constants.MANUAL_ACK_CHECKPOINT,
      'office_name': officeName,
      'job_id': job_id,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
      'guard_id': gard_id,
      'check_point_image': img_path == 'na' ? 'Image not available' : formData,
    };

    try {
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);
      print('respose is here send check without  calls ${respoce.data} ');
      Navigator.pop(context);
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Check point Acknowledgement sent', Constants.toast_grey);
        Navigator.pushNamed(context, HomeScreen.routeName);
      } else {
        Helper.Toast(
            'Can\'t send Acknowledgement, try again', Constants.toast_red);
      }
    } catch (e) {
      print('jjjjjjjjjjjjjjjjjjjjjjjjjj   ${e.toString()}');
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  static Future sentPredefinedCheckPointAck(BuildContext context,
      String check_point_id, int status, String job_id, String img_path) async {
    Helper.showLoading(context);
    await Helper.determineCurrentPosition();
    FormData? formData;
    if (img_path != 'na') {
      String fileName = img_path.split('/').last;
      formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(img_path, filename: fileName),
      });
    }
    final parameters = {
      'type': Constants.SEND_ACK,
      'office_name': officeName,
      'check_point_id': check_point_id,
      'status': status,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
      'check_point_image': img_path == 'na' ? 'Image not available' : formData,
      'job_id': job_id,
      'guard_id': gard_id,
    };

    try {
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);
      print('aaaaaaaaaaaaaaaaaaaa${respoce.data} ');
      Navigator.pop(context);
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Check point Acknowledgement sent', Constants.toast_grey);
        Navigator.pushNamed(context, HomeScreen.routeName);
      } else {
        Helper.Toast(
            'Can\'t send Acknowledgement, try again', Constants.toast_red);
      }
    } catch (e) {
      print('bbbbbbbbbbbbbbbbbbbb   ${e.toString()}');
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  static Future sendSmsViaApp(BuildContext context, String msg) async {
    Helper.showLoading(context);
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    try {
      final parameters = {
        'type': Constants.MESSAGE_SEND,
        'office_name': officeName,
        'from_user_id': gard_id,
        'device_type': deviceType,
        'msg_text': msg,
      };
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);
      print('respose is here of client phone number ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Sent', Constants.toast_grey);
      } else {
        Helper.Toast("Number not found", Constants.toast_grey);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }

  static Future sendAlert(BuildContext context) async {
    Helper.showLoading(context);
    try {
      final parameters = {
        'type': Constants.PANIC_ALERT,
        'office_name': officeName,
        'guard_id': gard_id,
      };
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);

      print('alert sent, respoce is here...  $respoce');
      if (respoce.data['msg'] == 'Alert sent') {
        Helper.Toast('Alert sent', Constants.toast_grey);
      } else {
        Helper.Toast(
            'Alert can\'t send, please try again', Constants.toast_red);
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  static Future<bool> logoutCall(BuildContext context) async {
    Helper.showLoading(context);
    try {
      final parameters = {
        'type': Constants.DRIVER_LOGOUT,
        'office_name': officeName,
        'driver_id': gard_id,
        'device_type': deviceType,
      };
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);

      print('logout, respose is here...  $respoce');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Logout successfully', Constants.toast_grey);
        return true;
      } else {
        Helper.Toast('Can\'t logout, please try again', Constants.toast_red);
        return false;
      }
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      return false;
    }
  }

  static Future<bool> statusChange(BuildContext context, String status) async {
    Helper.showLoading(context);
    try {
      final parameters = {
        'type': Constants.DRIVER_STATUS_CHANGE,
        'office_name': officeName,
        'guard_id': gard_id,
        'guard_status': status,
        'device_type': deviceType,
      };
      final restClient = RestClient();
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);

      print('status changing , response is here...  $respoce');
      Navigator.pop(context);
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('Status changed', Constants.toast_grey);
        //save in local db
        return true;
      } else {
        Helper.Toast(
            'Status can\'t change, please try again', Constants.toast_red);
        return false;
      }
    } catch (e) {
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      return false;
    }
  }
}
