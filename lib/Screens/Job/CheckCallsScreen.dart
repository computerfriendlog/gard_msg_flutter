import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Widgets/CheckPointDesign.dart';
import 'package:camera/camera.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Models/CheckPoint.dart';
import '../../Widgets/CustomButton.dart';
import '../Camera/TakePictureScreen.dart';
import '../HomeScreen.dart';
import 'package:intl/intl.dart';

class CheckCallsScreen extends StatefulWidget {
  static const routeName = '/CheckCallsScreen';

  const CheckCallsScreen({Key? key}) : super(key: key);

  @override
  State<CheckCallsScreen> createState() => _CheckCallsScreenState();
}

class _CheckCallsScreenState extends State<CheckCallsScreen> {
  bool isLoading = true;
  final restClient = RestClient();
  NewJob? job;
  List<CheckPoint> chkPoint_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCheckCalls();
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)?.settings.arguments as NewJob?;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check calls',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 18),
        ),
        actions: [
          InkWell(
              onTap: () {
                ///open dialog to confirm and send checkpoint
                Dialog errorDialog = Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  //this right here
                  child: SizedBox(
                    height: hight * 0.35,
                    width: width * 0.6,
                    child: Column(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_confirmation.png'),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Confirmation',
                                  style: TextStyle(
                                      color: Colors.white,
                                      //Theme.of(context).cardColor
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: hight * 0.2,
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 5, right: 10, left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Do you want to upload picture with check point?',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100),
                              ),
                              //const SizedBox(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        ///  check point with image
                                        //TakePictureScreen
                                        final cameras =
                                            await availableCameras();
                                        final firstCamera = cameras.first;
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TakePictureScreen(
                                                        camera: firstCamera,
                                                        reason: '',
                                                        dis: 0.0,
                                                        job: NewJob(
                                                            job_id:
                                                                job!.job_id))));
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w100),
                                        ),
                                      )),
                                  ElevatedButton(
                                    onPressed: () {
                                      /// no simple check point
                                      //sendSimpleCheckPoint();
                                      APICalls.sentAcknowledgement(context,
                                          job!.job_id.toString(), 'na');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[300],
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                showDialog(
                    context: context,
                    builder: (BuildContext context) => errorDialog);
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text(
                    'Manual check point',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w100,
                        fontSize: 12),
                  ),
                ),
              )),
        ],
      ),
      body: Container(
        width: width,
        height: hight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Helper.LoadingWidget(context),
            SizedBox(
              height: hight * 0.75,
              child: !isLoading
                  ? chkPoint_list.isNotEmpty
                      ? ListView.builder(
                          //scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: chkPoint_list.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return CheckPointDesign(
                                width: width * 0.9,
                                checkPoint: chkPoint_list[index],
                                function_handle: () {
                                  //doing here
                                  DateTime tempDate = DateFormat("dd-MM-yyyy hh:m:ss").parse(chkPoint_list[index].time!.toString());

                                  //print('time is ${chkPoint_list[index].time}       ${tempDate.toString()}        ');
                                  //print('difference in minuts   ${Helper.getCurrentTime().difference(tempDate).inMinutes}   ${tempDate.difference(Helper.getCurrentTime()).inMinutes}');
                                  if (chkPoint_list[index].status == '0') {
                                    if (Helper.getCurrentTime().day ==
                                        tempDate.day) {
                                      int dif_min = Helper.getCurrentTime()
                                          .difference(tempDate)
                                          .inMinutes;
                                      if (dif_min < 0) {
                                        dif_min = -(dif_min);
                                      }

                                      if (dif_min < 15) {
                                        /// allow to check
                                        Dialog checkPointSubmitDialog = Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12.0)),
                                          //this right here
                                          child: SizedBox(
                                            height: hight * 0.35,
                                            width: width * 0.6,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(7),
                                                  //width: _width * 0.6
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      )),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image.asset(
                                                          height: 30,
                                                          width: 30,
                                                          'assets/images/ic_confirmation.png'),
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text(
                                                          'Confirmation',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              //Theme.of(context).cardColor
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: hight * 0.2,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10,
                                                          bottom: 5,
                                                          right: 10,
                                                          left: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Do you want to upload picture with check point?',
                                                        overflow:
                                                            TextOverflow.clip,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w100),
                                                      ),
                                                      //const SizedBox(),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          CustomButton('Yes',
                                                              width * 0.3,
                                                              () async {
                                                            /// predefined check point with image
                                                            //TakePictureScreen
                                                            final cameras =
                                                                await availableCameras();
                                                            final firstCamera =
                                                                cameras.first;
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (context) => TakePictureScreen(
                                                                    camera:
                                                                        firstCamera,
                                                                    reason:
                                                                        '${chkPoint_list[index].check_point_id}}',
                                                                    dis: 0.0,
                                                                    job: NewJob(
                                                                        job_id:
                                                                            job!.job_id))));
                                                          }),
                                                          CustomButton(
                                                              background:
                                                                  Constants
                                                                      .grey,
                                                              'No',
                                                              width * 0.3, () {
                                                            /// predefined simple check point
                                                            //sendSimpleCheckPoint();
                                                            APICalls.sentPredefinedCheckPointAck(
                                                                context,
                                                                chkPoint_list[
                                                                        index]
                                                                    .check_point_id!,
                                                                1,
                                                                chkPoint_list[
                                                                        index]
                                                                    .job_id!,
                                                                'na');
                                                          }),
                                                        ],
                                                      ),
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
                                                checkPointSubmitDialog);
                                      } else {
                                        Helper.Toast('Please check-in on time',
                                            Constants.toast_grey);
                                      }
                                    } else {
                                      Helper.Toast('Please check-in on time',
                                          Constants.toast_grey);
                                    }
                                  } else {
                                    Helper.Toast('already checked-in',
                                        Constants.toast_red);
                                  }
                                });
                          },
                        )
                      : const Center(
                          child: Text(
                            'Check Points not found',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        )
                  : Center(child: Helper.LoadingWidget(context)),
            ),
          ],
        ),
      ),
    ));
  }

  void loadCheckCalls() async {
    await Helper.determineCurrentPosition();

    final parameters = {
      'type': Constants.CHECK_POINTS,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_id': job!.job_id,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
    };
    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('respose is here of check calls ${respoce.data} ');
    if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
      int? size = job!.check_point_count?.toInt();
      for (int i = 0; i < size!; i++) {
        chkPoint_list.add(CheckPoint(
            barcode: respoce.data['DATA'][i]['barcode'],
            check_point_id: respoce.data['DATA'][i]['check_point_id'],
            guard_id: respoce.data['DATA'][i]['guard_id'],
            job_id: respoce.data['DATA'][i]['job_id'],
            name: respoce.data['DATA'][i]['name'],
            status: respoce.data['DATA'][i]['status'],
            time: respoce.data['DATA'][i]['time']));
      }
    }
    isLoading = false;
    setState(() {});
    print('check point 1 is   ${chkPoint_list[0].job_id}');
  }

  void sendSimpleCheckPoint() async {
    await Helper.determineCurrentPosition();
    final parameters = {
      'type': Constants.MANUAL_ACK_CHECKPOINT,
      'office_name': officeName,
      'job_id': job!.job_id,
      'latitude': Helper.currentPositon.latitude,
      'longitude': Helper.currentPositon.longitude,
      'guard_id': gard_id,
      'check_point_image': 'withoutImage',
    };

    try {
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
      Navigator.pop(context);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
