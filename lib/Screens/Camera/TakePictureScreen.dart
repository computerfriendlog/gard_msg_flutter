import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/Job/FinishJobScreen.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/LocalDatabase.dart';
import '../HomeScreen.dart';
import 'package:dio/dio.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen(
      {super.key,
      required this.camera,
      required this.job,
      required this.dis,
      required this.reason});

  final CameraDescription camera;
  final NewJob job;
  final double dis;
  final String reason;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

String imagePath_clicked = '';

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool loading = true;
  bool imageClicked = false;
  bool loaderAPI = false;
  final restClient = RestClient();

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  void initCamera() {
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    loading = false;
    setState(() {});
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return SafeArea(
      child: Stack(
        children: [
          SizedBox(
              height: _hight,
              width: _width,
              child: loading
                  ? Helper.showLoading(context)
                  : !imageClicked
                      ? FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return CameraPreview(_controller);
                            } else {
                              // Otherwise, display a loading indicator.
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        )
                      : Image.file(File(imagePath_clicked))),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: _hight * 0.25,
                    width: _width * 0.5,
                    child: Row(
                      mainAxisAlignment: imageClicked
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        !imageClicked
                            ? FloatingActionButton(
                                onPressed: () async {
                                  Helper.showLoading(context);
                                  try {
                                    imageClicked = true;
                                    await _initializeControllerFuture;
                                    imagePath_clicked =
                                        (await _controller.takePicture()).path;
                                    print(
                                        'image picked is ${imagePath_clicked}');
                                    Navigator.pop(context);
                                    setState(() {});
                                  } catch (e) {
                                    Helper.Toast(Constants.somethingwentwrong,
                                        Constants.toast_red);
                                    print(e);
                                  }
                                },
                                child: const Icon(Icons.camera_alt),
                              )
                            : FloatingActionButton(
                                onPressed: () async {
                                  imageClicked = false;
                                  imagePath_clicked = '';
                                  setState(() {});
                                },
                                child: const Icon(Icons.cancel),
                              ),
                        imageClicked
                            ? FloatingActionButton(
                                onPressed: () async {
                                  ///call API
                                  try {
                                    Helper.showLoading(context);

                                    //File(imagePath_clicked).readAsBytesSync();
                                    if (widget.job.job_status != null) {
                                      //its for starting job
                                      startJobWithImage(
                                          widget.dis,
                                          widget.reason,
                                          File(imagePath_clicked));
                                    } else if (widget.reason
                                        .trim()
                                        .isNotEmpty) {
                                      //its predefined checkpoint
                                      APICalls.sentPredefinedCheckPointAck(
                                          context,
                                          widget.reason,
                                          1,
                                          widget.job.job_id!,
                                          imagePath_clicked);
                                    } else {
                                      //its manual check point
                                      print(
                                          'send acknowledgement... with image');
                                      APICalls.sentAcknowledgement(
                                          context,
                                          widget.job.job_id!,
                                          imagePath_clicked);
                                    }
                                  } catch (e) {
                                    print(
                                        'send acknowledgement... with image    exceptrion   ${e.toString()}');
                                    Helper.Toast(Constants.somethingwentwrong,
                                        Constants.toast_red);
                                    print(e);
                                  }
                                },
                                child: Icon(
                                  Constants.ic_tik,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  void startJobWithImage(
      double total_miles, String reason, File img_file) async {
    print('start with image ');
    String fileName = img_file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(img_file.path, filename: fileName),
    });
    final parameters = {
      'type': Constants.START_PATROL_WITH_PICTURE,
      'office_name': officeName,
      'job_id': widget.job.job_id.toString(),
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'reason': reason,
      'total_miles': total_miles,
      'start_patrol_image': formData //img_file.readAsBytesSync()
    };

    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
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
            LocalDatabase.STARTED_JOB, widget.job.job_id.toString());
        Navigator.of(context)
            .pushNamed(FinishJobScreen.routeName, arguments: widget.job);
      } else {
        Helper.Toast(
            'Cannot start shift, Kindly call office to get shift started',
            Constants.toast_red);
      }
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
