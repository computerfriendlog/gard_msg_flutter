import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:camera/camera.dart';
import 'package:gard_msg_flutter/Screens/Camera/TakePictureScreen.dart';
import 'package:gard_msg_flutter/Screens/Job/FinishJobScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../HomeScreen.dart';

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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    _hight = mediaQueryData.size.height;
    _width = mediaQueryData.size.width;

    this_job = ModalRoute.of(context)?.settings.arguments as NewJob?;
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
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    print('going to camera screen   ${firstCamera.name}');

    /// it must be on image pick screen
    ///startJobWithImage(total_miles, reason, imagePath_clicked);
    Navigator.pop(context);
    if (firstCamera != null) {
      //MaterialPageRoute(builder: (context) => TakePictureScreen(camera: firstCamera));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TakePictureScreen(
              camera: firstCamera,
              reason: reasn,
              dis: total_miles,
              job: this_job!)));

    }
  }

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
    /*double jb_lt;
    double jb_lo;
    if (this_job!.latitude == '' || this_job!.latitude == '') {
      jb_lt = 00.13212;
      jb_lo = 00.13212;
    } else {
      jb_lt = this_job!.latitude as double;
      jb_lo = this_job!.longitude as double;
    }

    double dis = Helper.distanceLatLong(Helper.currentPositon.latitude,
        Helper.currentPositon.longitude, jb_lt, jb_lo);
    print('distance is ... ${dis}');
    //clickImageByCamera(dis, 'testing');
    //startJob('on time, not late', dis);
    dis = 0;
    if (dis < 0.3) {
      ///just start shit on site location
      startJob('on time, not late', dis);
    }
    else if (dis >= 0.3 && dis < 0.5) {

      ///start job with image and reason, fare from location
      TextEditingController _controller_reason_of_late =
      TextEditingController();
      Dialog rejectDialog_with_reason = Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)),
        //this right here
        child: SizedBox(
          height: _hight * 0.5,
          width: _width * 0.7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                //width: _width * 0.6
                decoration: BoxDecoration(
                    color:
                    Theme.of(context).primaryColor,
                    borderRadius:
                    const BorderRadius.only(
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
              Container(
                padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 5,
                    right: 10,
                    left: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Container(
                          padding:
                          const EdgeInsets.only(
                              top: 20,
                              bottom: 20,
                              right: 10,
                              left: 10),
                          child: CustomTextField(
                              _width * 0.6,
                              '',
                              'Reason',
                              TextInputType.name,
                              _controller_reason_of_late),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (_controller_reason_of_late
                                  .text.isEmpty) {
                                Helper.Toast(
                                    'Invalid reason',
                                    Colors.grey);
                              } else {
                                clickImageByCamera(
                                    dis,
                                    _controller_reason_of_late
                                        .text
                                        .trim());
                              }
                            },
                            child: const Padding(
                              padding:
                              EdgeInsets.all(8.0),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight
                                        .w100),
                              ),
                            )),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context,
                                rootNavigator: true)
                                .pop(false);
                          },
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.grey[300],
                          ),
                          child: const Padding(
                            padding:
                            EdgeInsets.all(8.0),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w100),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) =>
          rejectDialog_with_reason);
    }
    else {
      //Helper.Toast("I'm afraid we cannot start your shift, Kindly call office to get shift started", Constants.toast_red);

      Navigator.pop(context);
      Dialog rejectDialog_with_reason = Dialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12.0)),
          child: Container(
            height: _hight * 0.3,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.start,
                  children: const [
                    Text(
                      "Hi!",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ],
                ),
                const Text(
                  "I'm afraid we cannot start your shift, Kindly call office to get shift started",
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 16,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                              fontWeight:
                              FontWeight.w100,
                              fontSize: 16,
                              color: Colors.black),
                        )),
                  ],
                )
              ],
            ),
          ));
      showDialog(
          context: context,
          builder: (BuildContext context) =>
          rejectDialog_with_reason);
    }*/

    if (respose.data['RESULT'] == 'OK') {
      if (false) {//respose.data['status'] == 0
        //
        Helper.Toast("Errors related to job_id, guard_id , site name",
            Constants.toast_grey);
      } else if (false) {//respose.data['status'] == 1
        //
        if (LocalDatabase.getString(LocalDatabase.STARTED_JOB) == 'null') {
          startJob('on time, not late', 0);
        } else {
          Navigator.pop(context);
          Helper.Toast('Once complete your first job', Constants.toast_grey);
        }
      } //
      else if (true) { //respose.data['status'] == 2
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
