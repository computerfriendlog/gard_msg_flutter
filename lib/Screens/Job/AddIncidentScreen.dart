import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  String selected_indedent = 'Select please';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loadData();
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
                    imagePath_clicked_list.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: imagePath_clicked_list.length,
                            physics: const ScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: Image.file(
                                      File(imagePath_clicked_list[index])));
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton('Submit', width * 0.8, () {
                submitIncident();
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
          Constants.BASE_URL + "guardappv4.php",
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
        //setState(() {});
      } else {
        Helper.Toast("Cannot load incidents", Constants.toast_red);
      }
    } catch (e) {
      print('llllllllllllllllllllllllll');
      print(e);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void submitIncident() async {
    //uploadDriverDocs

    var img_file = await _controller_signature.toImage(height: 200, width: 600).asStream();

    // String fileName = img_file.path
    //     .split('/')
    //     .last;
    //  FormData formData = FormData.fromMap({
    //    //"file": await MultipartFile.fromFile(img_file.path, filename: fileName),
    //    "file": await MultipartFile.fromBytes(img_file),
    //  });

    //print("sending incidents   ${img_file.width}");

    try {
      final parameters = {
        'type': Constants.INCIDENT_LIST,
        'office_name': officeName,
        'job_id': '0',
        'incident_type': selected_indedent,
        'notes': _controller_msg.text.trim(),
        'logged_by': name,
        'image_name': officeName,
        'sign_img': officeName,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);
      print('respose is here of check incidents list  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {}
    } catch (e) {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }
}
