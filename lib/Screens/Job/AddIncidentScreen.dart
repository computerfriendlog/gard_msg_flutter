import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Providers/ImagesArray.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:signature/signature.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../../Widgets/CustomTextField.dart';
import '../Camera/TakePictureInArray.dart';
import '../HomeScreen.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'IncedentShowSceen.dart';

class AddIncidentScreen extends StatefulWidget {
  static const routeName = '/AddIncidentScreen';

  const AddIncidentScreen({Key? key}) : super(key: key);

  @override
  State<AddIncidentScreen> createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final restClient = RestClient();
  TextEditingController _controller_msg = TextEditingController();
  final SignatureController _controller_signature = SignatureController(
    penStrokeWidth: 8,
    penColor: Colors.white,
    exportBackgroundColor: Colors.grey[800],
  );

  //List<Map<String, dynamic>> incident_list = [];
  final List<String> incident_list = [];
  String? selected_indedent;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incidents',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          width: width,
          height: hight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /*Text(
                      incident_list.isNotEmpty ? incident_list[0] : '',
                      style: const TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 14),
                    ),*/
                    DropdownButton(
                      focusColor: Colors.white,
                      underline: SizedBox(),
                      elevation: 5,
                      hint: Text('Select incident'),
                      value: selected_indedent,
                      onChanged: (newValue) {
                        setState(() {
                          selected_indedent = newValue.toString();
                        });
                      },
                      items: incident_list != null || incident_list.isNotEmpty
                          ? incident_list.map((thislocation) {
                              print('texcty calue is  $thislocation');
                              return DropdownMenuItem(
                                child: Text(thislocation),
                                value: thislocation,
                              );
                            }).toList()
                          : ['Select'].map((thislocation) {
                              return DropdownMenuItem(
                                value: thislocation,
                                child: Text(thislocation),
                              );
                            }).toList(),
                    ),
                    Image.asset(
                        height: 30, width: 30, 'assets/images/ic_spinner.png'),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: TextFormField(
                  cursorColor: Colors.white,
                  controller: _controller_msg,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white.withOpacity(0.1),
                      filled: true,
                      contentPadding: const EdgeInsets.all(0),
                      hintText: 'Write Message Here',
                      hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.8),
                          fontWeight: FontWeight.w300)
                      //labelText: hint,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Write your signature below',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _controller_signature.clear();
                      },
                      child: const Text('Clear',
                          style: TextStyle(fontWeight: FontWeight.w500))),
                ],
              ),
              Signature(
                controller: _controller_signature,
                width: width * 0.9,
                height: hight * 0.2,
                backgroundColor: Colors.grey[600]!,
              ),
              Container(
                height: 100,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () async {
                        final cameras = await availableCameras();
                        final firstCamera = cameras.first;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TakePictureInArray(
                                  camera: firstCamera,
                                )));
                      },
                      child: Image.asset(
                          width: 70,
                          height: 70,
                          'assets/images/add_images.png'),
                    ),
                    //imagePath_clicked_list.isNotEmpty
                    Provider.of<ImagesArray>(context).getImages().isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            //itemCount: imagePath_clicked_list.length,
                            itemCount: Provider.of<ImagesArray>(context)
                                .getImages()
                                .length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              print(
                                  'image are   ${Provider.of<ImagesArray>(context).getImages().length}');
                              return Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 65,
                                  width: 65,
                                  //child: Image.file(File(imagePath_clicked_list[index])));
                                  child: Image.file(File(
                                      Provider.of<ImagesArray>(context)
                                          .getImages()[index])));
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomButton('Submit', width * 0.8, () {
                if (Provider.of<ImagesArray>(context, listen: false)
                    .getImages()
                    .isEmpty) {
                  Helper.Toast("Images not found", Constants.toast_grey);
                } else if (_controller_signature.isEmpty) {
                  Helper.Toast("Please put signature", Constants.toast_grey);
                } else if (_controller_msg.text.trim().isEmpty) {
                  Helper.Toast(
                      "Please enter specific message", Constants.toast_grey);
                } else {
                  submitIncident(
                      Provider.of<ImagesArray>(context, listen: false)
                          .getImages());
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    print("getting incidents names   ");
    try {
      final parameters = {
        'type': Constants.INCIDENT_LIST,
        'office_name': officeName,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('respose is here of check incidents list  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        print('checking all incidents names ${respoce.data} ');
        incident_list.clear();
        respoce.data['DATA'].forEach((a) {
          incident_list.add(a['name']);
        });

        print('incidents are ${incident_list.length.toString()} ');
        selected_indedent = incident_list[0];
        setState(() {});
      } else {
        Helper.Toast("Cannot load incidents", Constants.toast_red);
      }
    } catch (e) {
      print('llllllllllllllllllllllllll');
      print(e);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  @override
  void dispose() {
    _controller_signature.dispose();
    super.dispose();
  }

  void submitIncident(List<String> imagesList) async {
    Helper.showLoading(context);
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    print('job id is   ${job_id}');
    //var img_file = await _controller_signature.toImage(height: 200, width: 600).asStream();
    final Uint8List? singatureImageInBytes =
        await _controller_signature.toPngBytes(height: 400, width: 1000);

    List<FormData> formData_list = [];

    if (imagesList.isNotEmpty) {
      for (int i = 0; i < imagesList.length; i++) {
        String fileName = imagesList[i].split('/').last;
        formData_list.add(FormData.fromMap({
          "file":
              await MultipartFile.fromFile(imagesList[i], filename: fileName),
        }));
      }
    }
    try {
      final parameters = {
        'type': Constants.SEND_INCIDENT,
        'office_name': officeName,
        'job_id': job_id,
        'incident_type': selected_indedent,
        'notes': _controller_msg.text.trim(),
        'logged_by': name,
        'image_name': formData_list,
        'sign_img': singatureImageInBytes,
      };
      final respoce = await restClient.post(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('response is here of check incidents list  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Provider.of<ImagesArray>(context, listen: false).removeAll();
        Helper.Toast('Incident Sent successfully', Constants.toast_grey);
        Navigator.pushNamed(context, IncedentShowScreen.routeName);
      } else {
        Helper.Toast('Incident can\'t send, Try again', Constants.toast_grey);
      }
    } catch (e) {
      print('response exception is here   ${e} ');
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }
}
