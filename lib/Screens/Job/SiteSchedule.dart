import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';

import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../../Widgets/CustomTextField.dart';
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

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
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: _hight * 0.5,
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
                                fontSize: 18,
                                color: Theme.of(context).primaryColor),
                          ),
                          Text(
                            this_job!.job_id.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        'Start : ${this_job!.start_time.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Text(
                        'End : ${this_job!.end_time.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black),
                      ),
                      Text(
                        '${this_job!.end_time.toString()} Hours',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                SizedBox(
                  width: _width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {
                        ///from start job
                        TextEditingController _controller_reason_of_late =
                            TextEditingController();
                        Dialog rejectDialog_with_reason = Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          //this right here
                          child: SizedBox(
                            height: _hight * 0.4,
                            width: _width * 0.6,
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
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Please add a reason to explain why you are late to start the shift',
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
                                      top: 10, bottom: 5, right: 10, left: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(5),
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
                                                  Helper.Toast('Invalid reason',
                                                      Colors.grey);
                                                } else {
                                                  Helper.showLoading(context);
                                                 double dis= Helper.distanceLatLong(
                                                      Helper.currentPositon
                                                          .latitude,
                                                      Helper.currentPositon
                                                          .longitude,
                                                      this_job!.latitude
                                                          as double,
                                                      this_job!.longitude
                                                          as double);
                                                 print('distance is ... ${dis}');
                                                 if(dis<0.5){

                                                 }else{

                                                 }
                                                  // startJob(
                                                  //     _controller_reason_of_late
                                                  //         .text
                                                  //         .trim(),
                                                  //     dis as int);
                                                }
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w100),
                                                ),
                                              )),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop(false);
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

                        /// to start job
                      },
                      child: const Text(
                        'Start Job',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      )),
                ),
              ],
            ),
          )),
    );
  }

  void startJob(String reason, int total_miles) async {
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

    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);
    Navigator.pop(context); //for loader
    //Navigator.of(context, rootNavigator: true).pop(false);
    print('job rejected, response is..... ${respose.data}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      Helper.Toast(respose.data['msg'], Constants.toast_grey);
      Navigator.of(context).pushNamed(HomeScreen.routeName);
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
