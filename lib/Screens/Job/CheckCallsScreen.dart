import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Widgets/CheckPointDesign.dart';
import 'package:camera/camera.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Models/CheckPoint.dart';
import '../Camera/TakePictureScreen.dart';
import '../HomeScreen.dart';

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
        margin: const EdgeInsets.all(10),
        width: width,
        height: hight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Helper.LoadingWidget(context),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Timer',
                    style: TextStyle(fontWeight: FontWeight.w100, fontSize: 18),
                  ),
                ),
              ],
            ),
            Container(
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
                                  //print('click oon ${index}');
                                  Dialog errorDialog = Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12.0)),
                                      //this right here
                                      child: Container());
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          errorDialog);
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
