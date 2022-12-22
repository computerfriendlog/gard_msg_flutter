import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:camera/camera.dart';
import 'package:gard_msg_flutter/Screens/Job/FinishJobScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../HomeScreen.dart';
import 'package:image_picker/image_picker.dart';

class SiteSchedule extends StatefulWidget {
  static const routeName = '/SiteSchedule';

  const SiteSchedule({Key? key}) : super(key: key);

  @override
  State<SiteSchedule> createState() => _SiteScheduleState();
}

class _SiteScheduleState extends State<SiteSchedule> {
  NewJob? this_job;
  final restClient = RestClient();
  var _hight;
  var _width;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    _hight = mediaQueryData.size.height;
    _width = mediaQueryData.size.width;

    if (firstTime) {
      this_job = ModalRoute.of(context)?.settings.arguments as NewJob?;
      firstTime = false;
    }

    print('job is    ${this_job!.job_id.toString()}');
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Site Schedule',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.white),
            ),
          ),
          body: ListView(
            children: [
              Container(
                height: _hight * 0.87,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: _hight * 0.6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                this_job!.job_date.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                this_job!.job_id.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Text(
                            'Start : ${this_job!.start_time.toString()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Text(
                            'End : ${this_job!.end_time.toString()}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                          Text(
                            '${this_job!.end_time.toString()} Hours',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.black.withOpacity(0.7)),
                          ),
                          Container(
                            width: _width * 0.6,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                shape: BoxShape.rectangle),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                    height: 30,
                                    width: 30,
                                    'assets/images/ic_check_points.png'),
                                const Text(
                                  'Check calls',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Stack(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '${this_job!.check_point_count.toString()}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    size: 20,
                                    Constants.ic_location,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    this_job!.sites.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.white,
                              ),
                              Icon(
                                size: 20,
                                Constants.ic_arrow_forword,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomButton('Start Job', _width * 0.8, () {
                      Helper.showLoading(context);
                      checkAvailability();

                      ///for testing only
                      //startJob('on time, not late', 0);
                    }),
                    /* SizedBox(
                      width: _width * 0.8,
                      child: ElevatedButton(
                          onPressed: () {
                            Helper.showLoading(context);
                            checkAvailability();
                            ///for testing only
                            //startJob('on time, not late', 0);
                          },
                          child: const Text(
                            'Start Job',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                color: Colors.white),
                          )),
                    ),*/
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void startJob(String reason, double total_miles) async {
    print('starting job here');
    print(
        'location while starting is ${Helper.currentPositon.latitude.toString()}     ${Helper.currentPositon.longitude.toString()}');
    final parameters = {
      'type': Constants.START_PATROL,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_id': this_job!.job_id.toString(),
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'reason': reason,
      'total_miles': total_miles,
    };

    final respose = await restClient.post(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    Navigator.pop(context); //for loader
    //Navigator.of(context, rootNavigator: true).pop(false);
    print('job started, response is..... ${respose.data['msg']}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      LocalDatabase.saveString(
          LocalDatabase.STARTED_JOB, this_job!.job_id.toString());
      Helper.Toast('Your shift started successfully', Constants.toast_grey);
      Helper.checkJobAndTrack();
      Navigator.of(context)
          .pushNamed(FinishJobScreen.routeName, arguments: this_job!);
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void clickImageByCamera(double total_miles, String reasn) async {
    //final cameras = await availableCameras();
    //final firstCamera = cameras.first;
    //print('going to camera screen   ${firstCamera.name}');

    /// it must be on image pick screen
    ///startJobWithImage(total_miles, reason, imagePath_clicked);
    Navigator.pop(context);
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      startJobWithImage(total_miles, reasn, File(photo!.path));
    } catch (e) {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }



  void startJobWithImage(
      double total_miles, String reason, File img_file) async {
    print('start with image ');
    String fileName = img_file.path.split('/').last;
    FormData formData = FormData.fromMap({
      'type': Constants.START_PATROL_WITH_PICTURE,
      'office_name': officeName,
      'job_id': this_job!.job_id,
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'reason': reason,
      'total_miles': total_miles,
      "start_patrol_image": await MultipartFile.fromFile(img_file.path, filename: fileName),
    });
    /*final parameters = {
      'type': Constants.START_PATROL_WITH_PICTURE,
      'office_name': officeName,
      'job_id': this_job!.job_id,
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'reason': reason,
      'total_miles': total_miles,
      'start_patrol_image': formData //img_file.readAsBytesSync()
    };*/

    final respose = await restClient.post(Constants.BASE_URL + "",
        headers: {}, data: formData, body: {});
    Navigator.pop(context);
    print('start with image respose is here${respose.data['msg']}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      if (respose.data['msg']
          .toString()
          .toLowerCase()
          .contains('shift started successfully')) {
        Helper.Toast('Your shift started successfully', Constants.toast_grey);
        LocalDatabase.saveString(
            LocalDatabase.STARTED_JOB, this_job!.job_id.toString());
        Navigator.pop(context); //to remove current activity from context, ta k next activity say back is py na ay
        Navigator.of(context).pushNamed(FinishJobScreen.routeName, arguments: this_job);
      } else {
        Helper.Toast(
            'Cannot start shift, Kindly call office to get shift started',
            Constants.toast_red);
      }
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

 /* void startJobWithImagePreviousConfromWorkingWithImageIssue(
      double total_miles, String reason, File img_file) async {
    print('start with image ');
    String fileName = img_file.path.split('/').last;
    FormData formData = FormData.fromMap({

      "start_patrol_image": await MultipartFile.fromFile(img_file.path, filename: fileName),
    });
    final parameters = {
      'type': Constants.START_PATROL_WITH_PICTURE,
      'office_name': officeName,
      'job_id': this_job!.job_id,
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'reason': reason,
      'total_miles': total_miles,
      'start_patrol_image': formData //img_file.readAsBytesSync()
    };

    final respose = await restClient.put(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    Navigator.pop(context);
    print('start with image respose is here${respose.data['msg']}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      if (respose.data['msg']
          .toString()
          .toLowerCase()
          .contains('shift started successfully')) {
        Helper.Toast('Your shift started successfully', Constants.toast_grey);
        LocalDatabase.saveString(
            LocalDatabase.STARTED_JOB, this_job!.job_id.toString());
        Navigator.pop(context); //to remove current activity from context, ta k next activity say back is py na ay
        Navigator.of(context).pushNamed(FinishJobScreen.routeName, arguments: this_job);
      } else {
        Helper.Toast(
            'Cannot start shift, Kindly call office to get shift started',
            Constants.toast_red);
      }
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }*/

  void checkAvailability() async {
    await Helper.determineCurrentPosition();
    final parameters = {
      'type': Constants.JOB_DRIVER_RADIUS,
      'office_name': officeName,
      'job_id': this_job!.job_id.toString(),
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
    };

    final respose = await restClient.post(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    print('response of checking radius is here  $respose  ');

    if (respose.data['RESULT'] == 'OK') {
      if (false) {
        //respose.data['status'] == 0
        //
        Helper.Toast("Errors related to job_id, guard_id , site name",
            Constants.toast_grey);
      } else if (false) {
        //respose.data['status'] == 1
        //
        if (LocalDatabase.getString(LocalDatabase.STARTED_JOB) == 'null') {
          startJob('on time, not late', 0);
        } else {
          Navigator.pop(context);
          Helper.Toast('Once complete your first job', Constants.toast_grey);
        }
      } //
      else if (true) {//respose.data['status'] == 2
        //
        ///start job with image and reason, fare from location
        TextEditingController _controller_reason_of_late =
            TextEditingController();
        Dialog rejectDialog_with_reason = Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          //this right here
          child: SizedBox(
            //height: _hight * 0.5,
            width: _width * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  //width: _width * 0.6
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      )),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'I\'m afraid we cannot identify your location, kindly provide surrounding image and a reason ',
                      style: TextStyle(
                          color: Colors.white,
                          //Theme.of(context).cardColor
                          fontSize: 12,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Helper.reasonTextField(_controller_reason_of_late),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_controller_reason_of_late.text.isEmpty) {
                            Helper.Toast('Invalid reason', Colors.grey);
                          } else {
                            clickImageByCamera(
                                0, _controller_reason_of_late.text.trim());
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w100),
                          ),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop(false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w100),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
        showDialog(
            context: context,
            builder: (BuildContext context) => rejectDialog_with_reason);
      } else if (respose.data['status'] == 3) {
        Navigator.pop(context);
        Helper.msgDialog(context,
            'I\'m afraid we cannot start your shift, Kindly call office to get shift started',
            () {
          Navigator.pop(context);
        });
      } else if (respose.data['status'] == 4) {
        Navigator.pop(context);
        Helper.msgDialog(context,
            'I can\'t start job due to time difference, Please ask your office to start it.',
            () {
          Navigator.pop(context);
        });
      }
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }
}
