import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/Job/SiteSchedule.dart';
import 'package:gard_msg_flutter/Widgets/JobsDesign.dart';
import 'package:flutter/material.dart';
import '../../APIs/RestClient.dart';
import '../../Widgets/CustomTextField.dart';
import '../HomeScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CurrentJobs extends StatefulWidget {
  static const routeName = '/CurrentJobs';

  const CurrentJobs({Key? key}) : super(key: key);

  @override
  State<CurrentJobs> createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs>
    with SingleTickerProviderStateMixin {
  final restClient = RestClient();
  TabController? _tabController;
  List<NewJob> _newJobs = [];
  List<NewJob> _acceptedJobs = [];
  int tab_bar_index = 0;
  int new_jobs = 0;
  int accepted_jobs = 0;
  bool isloading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Site Schedule',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: _width,
          height: _hight,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TabBar(
                labelColor: Colors.redAccent,
                unselectedLabelColor: Constants.grey,
                controller: _tabController,
                onTap: (index) {
                  setState(() {
                    tab_bar_index = index;
                    print('tab bar index  $tab_bar_index');
                  });
                },
                tabs: [
                  Tab(
                    text: 'New (${new_jobs})',
                  ),
                  Tab(
                    text: 'Accepted (${accepted_jobs})',
                  ),
                ],
              ),
              Container(height: _hight*0.80,
              child:!isloading
                  ? tab_bar_index == 0
                  ? _newJobs.isNotEmpty
                  ? ListView.builder(
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: _newJobs.length,
                physics: const ScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return JobsDesign(
                      width: _width * 0.8,
                      newJob_detail: _newJobs[index],
                      function_handle: () {
                        //print('click oon ${index}');
                        Dialog errorDialog = Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                  12.0)),
                          //this right here
                          child: SizedBox(
                            // padding: const EdgeInsets.only(
                            //     right: 10,
                            //     left: 10,
                            //     bottom: 10),
                            height: _hight * 0.5,
                            width: _width * 0.6,
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding:
                                  const EdgeInsets.all(
                                      7),
                                  //width: _width * 0.6
                                  decoration: BoxDecoration(
                                      color:
                                      Theme.of(context)
                                          .primaryColor,
                                      borderRadius:
                                      const BorderRadius
                                          .only(
                                        topLeft:
                                        Radius.circular(
                                            12),
                                        topRight:
                                        Radius.circular(
                                            12),
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
                                        EdgeInsets.all(
                                            8.0),
                                        child: Text(
                                          'Confirmation',
                                          style: TextStyle(
                                              color: Colors
                                                  .white,
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
                                  padding:
                                  const EdgeInsets.only(
                                      top: 10,
                                      bottom: 5,
                                      right: 10,
                                      left: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          Container(
                                            padding:
                                            EdgeInsets
                                                .all(5),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors
                                                        .white,
                                                    width:
                                                    3.0),
                                                borderRadius: const BorderRadius
                                                    .all(
                                                    Radius.circular(
                                                        7.0)),
                                                color: Colors
                                                    .grey
                                                    .withOpacity(
                                                    0.1)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  size: 30,
                                                  Constants
                                                      .ic_calender,
                                                  color: Theme.of(
                                                      context)
                                                      .primaryColor,
                                                ),
                                                Text(
                                                  '${_newJobs[index].job_date}',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize:
                                                      16,
                                                      fontWeight:
                                                      FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Text(
                                            'Hours : ${_newJobs[index].no_of_hours}',
                                            style: const TextStyle(
                                                color: Colors
                                                    .black,
                                                fontSize:
                                                16,
                                                fontWeight:
                                                FontWeight
                                                    .w100),
                                          ),
                                          Container(
                                            color:
                                            Colors.grey,
                                            width: 0.5,
                                            height: 25,
                                          ),
                                          Text(
                                            '  ${_newJobs[index].job_id}',
                                            style: TextStyle(
                                                color: Theme.of(
                                                    context)
                                                    .primaryColor,
                                                fontSize:
                                                16,
                                                fontWeight:
                                                FontWeight
                                                    .w100),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Text(
                                            'Start : ${_newJobs[index].start_time}',
                                            style: const TextStyle(
                                                color: Colors
                                                    .black,
                                                fontSize:
                                                14,
                                                fontWeight:
                                                FontWeight
                                                    .w100),
                                          ),
                                          Container(
                                            color:
                                            Colors.grey,
                                            width: 0.5,
                                            height: 25,
                                          ),
                                          Text(
                                            ' End : ${_newJobs[index].end_time}',
                                            style: const TextStyle(
                                                color: Colors
                                                    .black,
                                                fontSize:
                                                14,
                                                fontWeight:
                                                FontWeight
                                                    .w100),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            size: 25,
                                            Constants
                                                .ic_calender,
                                            color: Colors
                                                .black,
                                          ),
                                          Text(
                                            ' ${_newJobs[index].sites}',
                                            style: TextStyle(
                                                color: Theme.of(
                                                    context)
                                                    .primaryColor,
                                                fontSize:
                                                16,
                                                fontWeight:
                                                FontWeight
                                                    .w100),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed:
                                                  () {
                                                acceptJob(
                                                    _newJobs[
                                                    index]);
                                              },
                                              child:
                                              const Text(
                                                'Accept',
                                                style: TextStyle(
                                                    color: Colors
                                                        .white,
                                                    fontSize:
                                                    14,
                                                    fontWeight:
                                                    FontWeight.w100),
                                              )),
                                          ElevatedButton(
                                            onPressed: () {
                                              ///from reject
                                              TextEditingController
                                              _controller_reason_of_rejection =
                                              TextEditingController();
                                              Dialog
                                              rejectDialog_with_reason =
                                              Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(12.0)),
                                                //this right here
                                                child:
                                                Container(
                                                  height:
                                                  _hight *
                                                      0.4,
                                                  width:
                                                  _width *
                                                      0.6,
                                                  child:
                                                  Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        padding:
                                                        const EdgeInsets.all(7),
                                                        //width: _width * 0.6
                                                        decoration: BoxDecoration(
                                                            color: Theme.of(context).primaryColor,
                                                            borderRadius: const BorderRadius.only(
                                                              topLeft: Radius.circular(12),
                                                              topRight: Radius.circular(12),
                                                            )),
                                                        child:
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Image.asset(height: 30, width: 30, 'assets/images/ic_forget.png'),
                                                            const Padding(
                                                              padding: EdgeInsets.all(8.0),
                                                              child: Text(
                                                                'Reject job',
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
                                                        height:
                                                        20,
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 5,
                                                            right: 10,
                                                            left: 10),
                                                        child:
                                                        Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets.all(5),
                                                                  child: CustomTextField(_width * 0.6, 'Reason to reject job', '', TextInputType.name, _controller_reason_of_rejection),
                                                                )
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 15,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                ElevatedButton(
                                                                    onPressed: () {
                                                                      if (_controller_reason_of_rejection.text.isEmpty) {
                                                                        Helper.Toast('Invalid reason', Colors.grey);
                                                                      } else {
                                                                        Helper.showLoading(context);
                                                                        rejectJob(_newJobs[index], _controller_reason_of_rejection.text.trim());
                                                                      }
                                                                    },
                                                                    child: const Padding(
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Text(
                                                                        'Submit',
                                                                        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w100),
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
                                                                      style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w100),
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
                                                  context:
                                                  context,
                                                  builder: (BuildContext
                                                  context) =>
                                                  rejectDialog_with_reason);

                                              /// to reject
                                            },
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                              Colors.grey[
                                              300],
                                            ),
                                            child:
                                            const Text(
                                              'Reject',
                                              style: TextStyle(
                                                  color: Colors
                                                      .black,
                                                  fontSize:
                                                  14,
                                                  fontWeight:
                                                  FontWeight
                                                      .w100),
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
                            builder:
                                (BuildContext context) =>
                            errorDialog);
                      });
                },
              )
                  : SizedBox(
                height: _hight * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Jobs not found',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: Constants.grey),
                    ),
                  ],
                ),
              )
                  : Container(
                child: _acceptedJobs.isNotEmpty
                    ? Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _acceptedJobs.length,
                    itemBuilder: (ctx, index) {
                      return JobsDesign(
                          width: _width * 0.8,
                          newJob_detail:
                          _acceptedJobs[index],
                          function_handle: () {
                            Navigator.of(context).pushNamed(
                                SiteSchedule.routeName,
                                arguments:
                                _acceptedJobs[index]);
                            print('click oon ${index}');
                          });
                    },
                  ),
                )
                    : SizedBox(
                  height: _hight * 0.7,
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        'Jobs not found',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Constants.grey),
                      ),
                    ],
                  ),
                ),
              )
              //loading...
                  : SizedBox(
                height: _hight * 0.8,
                child: LoadingAnimationWidget.inkDrop(
                  color: Theme.of(context).primaryColor,
                  //leftDotColor: const Color(0xFF1A1A3F),
                  //rightDotColor: const Color(0xFFEA3799),
                  size: 50,
                ),
              ) ,),

            ],
          ),
        ),
      ),
    );
  }

  void loadData() async {
    loadNewJobs(Constants.TYPE_ACCEPTED_JOBS);
    loadNewJobs(Constants.TYPE_NEW_JOBS);
    await Helper.determineCurrentPosition();
  }

  void loadNewJobs(String job_type) async {
    final parameters = {
      'type': Constants.PATROL_LISTING,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_type': job_type,
      'offset': 0, //from start to all
    };
    final respoce = await restClient.get(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('respoce is here of new jobs ${respoce.data} ');
    if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
      new_jobs = respoce.data['job_count'];
      accepted_jobs = respoce.data['accepted_count'];
      if (job_type == Constants.TYPE_NEW_JOBS) {
        for (int i = 0; i < new_jobs; i++) {
          _newJobs.add(NewJob(
              check_point_count: respoce.data['DATA'][i]['check_point_count'],
              customer_id: respoce.data['DATA'][i]['customer_id'],
              end_time: respoce.data['DATA'][i]['end_time'],
              fare: respoce.data['DATA'][i]['fare'],
              incidents_count: respoce.data['DATA'][i]['incidents_count'],
              job_date: respoce.data['DATA'][i]['job_date'],
              job_end_date: respoce.data['DATA'][i]['job_end_date'],
              job_id: respoce.data['DATA'][i]['job_id'],
              job_status: respoce.data['DATA'][i]['job_status'],
              latitude: respoce.data['DATA'][i]['latitude'],
              longitude: respoce.data['DATA'][i]['longitude'],
              mobile: respoce.data['DATA'][i]['mobile'],
              name: respoce.data['DATA'][i]['name'],
              no_of_hours: respoce.data['DATA'][i]['no_of_hours'],
              restriction_check: respoce.data['DATA'][i]['restriction_check'],
              sites: respoce.data['DATA'][i]['sites'],
              start_time: respoce.data['DATA'][i]['start_time'],
              time_check: respoce.data['DATA'][i]['time_check'],
              visitors_log_count: respoce.data['DATA'][i]
                  ['visitors_log_count']));
        }
      } else if (job_type == Constants.TYPE_ACCEPTED_JOBS) {
        for (int i = 0; i < new_jobs; i++) {
          _acceptedJobs.add(NewJob(
              check_point_count: respoce.data['DATA'][i]['check_point_count'],
              customer_id: respoce.data['DATA'][i]['customer_id'],
              end_time: respoce.data['DATA'][i]['end_time'],
              fare: respoce.data['DATA'][i]['fare'],
              incidents_count: respoce.data['DATA'][i]['incidents_count'],
              job_date: respoce.data['DATA'][i]['job_date'],
              job_end_date: respoce.data['DATA'][i]['job_end_date'],
              job_id: respoce.data['DATA'][i]['job_id'],
              job_status: respoce.data['DATA'][i]['job_status'],
              latitude: respoce.data['DATA'][i]['latitude'],
              longitude: respoce.data['DATA'][i]['longitude'],
              mobile: respoce.data['DATA'][i]['mobile'],
              name: respoce.data['DATA'][i]['name'],
              no_of_hours: respoce.data['DATA'][i]['no_of_hours'],
              restriction_check: respoce.data['DATA'][i]['restriction_check'],
              sites: respoce.data['DATA'][i]['sites'],
              start_time: respoce.data['DATA'][i]['start_time'],
              time_check: respoce.data['DATA'][i]['time_check'],
              visitors_log_count: respoce.data['DATA'][i]
                  ['visitors_log_count']));
        }
      }
      isloading = false;
      setState(() {});
    }
  }

  void acceptJob(NewJob job) async {
    final parameters = {
      'type': Constants.ACCEPT_GUARD,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_id': job.job_id.toString(),
      'latitude': Helper.currentPositon.latitude.toString(),
      //from start to all
      'longitude': Helper.currentPositon.longitude.toString(),
      //from start to all
    };
    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);

    print('job accepted, response is..... ${respose.data}');
    Navigator.of(context, rootNavigator: true).pop(false);

    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      Helper.Toast(respose.data['msg'], Constants.toast_grey);
      Navigator.of(context).pushNamed(SiteSchedule.routeName, arguments: job);
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void rejectJob(NewJob job, String reason) async {
    print(
        'location while rejecting is ${Helper.currentPositon.latitude.toString()}     ${Helper.currentPositon.longitude.toString()}');
    final parameters = {
      'type': Constants.REJECT_GUARD,
      'office_name': officeName,
      'job_id': job.job_id.toString(),
      'guard_id': gard_id,
      'latitude': Helper.currentPositon.latitude.toString(),
      'longitude': Helper.currentPositon.longitude.toString(),
      'comments': reason,
    };

    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);
    Navigator.pop(context); //for loader
    Navigator.of(context, rootNavigator: true).pop(false);
    print('job rejected, response is..... ${respose.data}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      Helper.Toast(respose.data['msg'], Constants.toast_grey);
      Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: job);
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
