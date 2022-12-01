import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Screens/Job/VisitorShowScreen.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:gard_msg_flutter/Widgets/CustomTextField.dart';
import 'package:camera/camera.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../../Helper/LocalDatabase.dart';
import '../../Providers/ImagesArray.dart';
import '../Camera/TakePictureInArray.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../HomeScreen.dart';

class AddVisitorScreen extends StatefulWidget {
  static const routeName = '/AddVisitorScreen';

  const AddVisitorScreen({Key? key}) : super(key: key);

  @override
  State<AddVisitorScreen> createState() => _AddVisitorScreenState();
}

class _AddVisitorScreenState extends State<AddVisitorScreen> {
  final restClient = RestClient();
  TextEditingController _controller_name = TextEditingController();
  TextEditingController _controller_company = TextEditingController();
  TextEditingController _controller_vehicle = TextEditingController();
  TextEditingController _controller_purpose = TextEditingController();
  TextEditingController _controller_time_in = TextEditingController();
  TextEditingController _controller_time_out = TextEditingController();

  bool isLoading = true;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller_time_in.text = '${selectedTime.hour}:${selectedTime.minute}';
    _controller_time_out.text = '${selectedTime.hour}:${selectedTime.minute}';
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visitors',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
      ),
      body: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          width: width,
          height: hight,
          child: ListView(
            children: [
              Column(
                children: [
                  CustomTextField(width * 0.9, 'Enter visitor name', 'Name',
                      TextInputType.name, _controller_name),
                  CustomTextField(width * 0.9, 'Enter company name', 'Company',
                      TextInputType.name, _controller_company),
                  CustomTextField(width * 0.9, 'Enter vehicle registration',
                      'Vehicle', TextInputType.name, _controller_vehicle),
                  CustomTextField(width * 0.9, 'Enter Purpose', 'Purpose',
                      TextInputType.name, _controller_purpose),
                  InkWell(
                    onTap: () async {
                      await getTime();
                      _controller_time_in.text =
                          '${selectedTime.hour}:${selectedTime.minute}';
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Check-in time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 13,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            width: width * 0.9,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 12, bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              _controller_time_in.text.trim(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await getTime();
                      _controller_time_out.text =
                          '${selectedTime.hour}:${selectedTime.minute}';
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: width * 0.9,
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Text(
                                "Check-out time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 13,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          Container(
                            width: width * 0.9,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 12, bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                                border: Border.all(color: Colors.grey)),
                            child: Text(
                              _controller_time_out.text.trim(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 15,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                  CustomButton('Save', width * 0.6, () {
                    saveVisitor(Provider.of<ImagesArray>(context, listen: false)
                        .getImages());
                  })
                ],
              ),
            ],
          )),
    ));
  }

  Future<void> getTime() async {
    final TimeOfDay? picked_s =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked_s != null && picked_s != selectedTime) {
      selectedTime = picked_s;
    }
  }

  void saveVisitor(List<String> imagesList) async {
    Helper.showLoading(context);
    String job_id = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    print('job id is   ${job_id}');

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
        'type': Constants.SAVE_VISITORS,
        'office_name': officeName,
        'guard_id': gard_id,
        'job_id': job_id,
        'name': _controller_name.text.trim(),
        'company': _controller_company.text.trim(),
        'vehicle_reg': _controller_vehicle.text.trim(),
        'visit_purpose': _controller_purpose.text.trim(),
        'time_in': _controller_time_in.text.trim(),
        'time_out': _controller_time_out.text.trim(),
        'image_name': formData_list,
      };
      final respoce = await restClient.post(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);

      print('response is here of check visitor added  ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        Helper.Toast('visitor Sent successfully', Constants.toast_grey);
        Provider.of<ImagesArray>(context, listen: false).removeAll();
        Navigator.pop(context);
        Navigator.pushNamed(context, VisitorShowScreen.routeName);
      } else {
        Navigator.pop(context);
        Helper.Toast(
            'visitor can\'t added, Please try again', Constants.toast_grey);
      }
    } catch (e) {
      Navigator.pop(context);
      print('response exception is here   ${e} ');
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_grey);
    }
  }
}
