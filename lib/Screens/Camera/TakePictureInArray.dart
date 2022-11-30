import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gard_msg_flutter/APIs/APICalls.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Providers/ImagesArray.dart';
import 'package:gard_msg_flutter/Screens/Job/FinishJobScreen.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/LocalDatabase.dart';
import '../HomeScreen.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureInArray extends StatefulWidget {
  const TakePictureInArray({
    super.key,
    required this.camera,
    //required this.job,
    //required this.dis,
    //required this.reason
  });

  final CameraDescription camera;

  //final NewJob job;
  //final double dis;
  //final String reason;

  @override
  TakePictureInArrayState createState() => TakePictureInArrayState();
}

//List<String> imagePath_clicked_list = [];

class TakePictureInArrayState extends State<TakePictureInArray> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool loading = true;
  bool imageClicked = false;
  bool loaderAPI = false;
  final restClient = RestClient();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.low,
    );
    // Next, initialize the controller. This returns a Future.
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
                  : FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          return CameraPreview(_controller);
                        } else {
                          // Otherwise, display a loading indicator.
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ) /*: Image.file(File(imagePath_clicked[im])) ),*/),
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
                                    Provider.of<ImagesArray>(context,listen: false).add((await _controller.takePicture()).path);
                                    //imagePath_clicked_list.add((await _controller.takePicture()).path);
                                    //print('image picked is ${Provider.of<ImagesArray>(context).getImages().first}');
                                    Navigator.pop(context);
                                    setState(() {});
                                  } catch (e) {
                                    Helper.Toast(Constants.somethingwentwrong,
                                        Constants.toast_red);
                                    print('image clicked exception $e');
                                  }
                                },
                                child: const Icon(Icons.camera_alt),
                              )
                            : FloatingActionButton(
                                onPressed: () async {
                                  imageClicked = false;
                                  //imagePath_clicked_list = [];
                                  Provider.of<ImagesArray>(context,
                                          listen: false)
                                      .removeAll();
                                  setState(() {});
                                },
                                child: const Icon(Icons.cancel),
                              ),
                        imageClicked
                            ? FloatingActionButton(
                                onPressed: () async {
                                  ///add next image
                                  Helper.showLoading(context);
                                  try {
                                    imageClicked = true;
                                    await _initializeControllerFuture;
                                    Provider.of<ImagesArray>(context,
                                            listen: false)
                                        .add((await _controller.takePicture())
                                            .path);
                                    //imagePath_clicked_list.add((await _controller.takePicture()).path);
                                    //print('image picked is ${imagePath_clicked_list[0]}');
                                    Navigator.pop(context);
                                    setState(() {});
                                  } catch (e) {
                                    Helper.Toast(Constants.somethingwentwrong,
                                        Constants.toast_red);
                                    print(e);
                                  }
                                },
                                child: Icon(
                                  Constants.ic_camera,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                        imageClicked
                            ? FloatingActionButton(
                                onPressed: () async {
                                  ///call API
                                  try {
                                    // Helper.showLoading(context);
                                    // Navigator.pop(context);
                                    Navigator.pop(context);

                                    /// call API or go back
                                  } catch (e) {
                                    print(
                                        'incidents with image  exception   ${e.toString()}');
                                    Helper.Toast(Constants.somethingwentwrong,
                                        Constants.toast_red);
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      //imagePath_clicked_list.length.toString(),
                                      Provider.of<ImagesArray>(context,
                                              listen: false)
                                          .getImages()
                                          .length
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Constants.ic_tik,
                                      color: Colors.white,
                                    ),
                                  ],
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

  void startJobWithImage() async {}
}
