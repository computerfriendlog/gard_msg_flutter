import 'package:flutter/cupertino.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
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
}
