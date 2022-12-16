import 'dart:async';

import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Providers/CurrentJobsProvider.dart';
import 'package:gard_msg_flutter/Screens/Job/SiteSchedule.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:gard_msg_flutter/Widgets/JobsDesign.dart';
import 'package:flutter/material.dart';
import '../../APIs/RestClient.dart';
import '../../Widgets/CustomTextField.dart';
import '../HomeScreen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'FinishJobScreen.dart';
import 'package:provider/provider.dart';

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

  //List<NewJob> _newJobs = [];
  List<NewJob> _acceptedJobs = [];
  int tab_bar_index = 0;
  int new_jobs = 0;
  int accepted_jobs = 0;
  //bool isloading = false; //true
  bool firstTimeOpenScreen = true;
  Timer? _timer;

  StreamController<NewJob> streamController_jobs = StreamController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadData();
    getLoc();
  }

  getLoc() async {
    await Helper.determineCurrentPosition();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamController_jobs.close();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    /*if (firstTimeOpenScreen) {
      print('curret screen build.....running////');
      _timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
        loadData();
      });
      getLoc();
    }*/

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

    return SafeArea(
      child: Scaffold(
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
              mainAxisSize: MainAxisSize.max,
              children: [
                TabBar(
                  labelColor: Colors.redAccent,
                  unselectedLabelColor: Constants.grey,
                  controller: _tabController,
                  onTap: (index) {
                    print('previous index ${_tabController!.index}    new is ${index}'   );
                      setState(() {
                        //tab_bar_index = index;
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
                SizedBox(
                  height: _hight * 0.80,
                  child:
                       //tab_bar_index == 0
                       _tabController?.index == 0
                          //? _newJobs.isNotEmpty
                          ?  Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs().isNotEmpty
                              ? ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  //itemCount: _newJobs.length,
                                  itemCount: Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs().length,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (ctx, index) {
                                    return JobsDesign(
                                        width: _width * 0.8,
                                        //newJob_detail: _newJobs[index],
                                        newJob_detail: Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index],
                                        function_handle: () {
                                          //print('click oon ${index}');
                                          Dialog errorDialog = Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0)),
                                            //this right here
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
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
                                                          const BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(12),
                                                        topRight:
                                                            Radius.circular(12),
                                                      )),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
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
                                                              color: Colors.white,
                                                              //Theme.of(context).cardColor
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 5,
                                                  ),
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            padding:
                                                                EdgeInsets.all(5),
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 3.0),
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            7.0)),
                                                                color: Colors.grey
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
                                                                  //'${_newJobs[index].job_date}',
                                                                  '${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].job_date}',
                                                                  style: TextStyle(
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
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
                                                            //'Hours : ${_newJobs[index].no_of_hours}',
                                                            'Hours : ${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].no_of_hours}',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100),
                                                          ),
                                                          Container(
                                                            color: Colors.grey,
                                                            width: 0.5,
                                                            height: 25,
                                                          ),
                                                          Text(
                                                            //'  ${_newJobs[index].job_id}',
                                                            '  ${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].job_id}',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 18,
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
                                                            //'Start : ${_newJobs[index].start_time}',
                                                            'Start : ${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].start_time}',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100),
                                                          ),
                                                          Container(
                                                            color: Colors.grey,
                                                            width: 0.5,
                                                            height: 25,
                                                          ),
                                                          Text(
                                                            //' End : ${_newJobs[index].end_time}',
                                                            ' End : ${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].end_time}',
                                                            style: const TextStyle(
                                                                color:
                                                                    Colors.black,
                                                                fontSize: 20,
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
                                                            Constants.ic_calender,
                                                            color: Colors.black,
                                                          ),
                                                          Text(
                                                            //' ${_newJobs[index].sites}',
                                                            ' ${Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index].sites}',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                fontSize: 16,
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
                                                          CustomButton('Accept',
                                                              _width * 0.3, () {
                                                            //acceptJob(_newJobs[index]);
                                                            acceptJob(Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index]);
                                                          }),
                                                          CustomButton('Reject',
                                                              _width * 0.3,
                                                              background: Colors
                                                                  .grey[100], () {
                                                            ///from reject
                                                            TextEditingController
                                                                _controller_reason_of_rejection =
                                                                TextEditingController();
                                                            Dialog
                                                                rejectDialog_with_reason =
                                                                Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12.0)),
                                                              //this right here
                                                              child: Container(
                                                                //height: _hight * 0.4,
                                                                width:
                                                                    _width * 0.9,
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(7),
                                                                      //width: _width * 0.6
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              color:
                                                                                  Theme.of(context).primaryColor,
                                                                              borderRadius: const BorderRadius.only(
                                                                                topLeft: Radius.circular(12),
                                                                                topRight: Radius.circular(12),
                                                                              )),
                                                                      child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: [
                                                                          Image.asset(
                                                                              height:
                                                                                  30,
                                                                              width:
                                                                                  30,
                                                                              'assets/images/ic_forget.png'),
                                                                          const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text(
                                                                              'Reject job',
                                                                              style: TextStyle(
                                                                                  color: Colors.white,
                                                                                  //Theme.of(context).cardColor
                                                                                  fontSize: 20,
                                                                                  fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const SizedBox(
                                                                      height: 20,
                                                                    ),
                                                                    Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top: 10,
                                                                          bottom:
                                                                              5,
                                                                          right:
                                                                              10,
                                                                          left:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                padding: const EdgeInsets.all(5),
                                                                                child: CustomTextField(_width * 0.6, 'Reason to reject job', '', TextInputType.name, _controller_reason_of_rejection),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              CustomButton('Submit',
                                                                                  _width * 0.3,
                                                                                  () {
                                                                                if (_controller_reason_of_rejection.text.isEmpty) {
                                                                                  Helper.Toast('Invalid reason', Colors.grey);
                                                                                } else {
                                                                                  Helper.showLoading(context);
                                                                                  //rejectJob(_newJobs[index], _controller_reason_of_rejection.text.trim());
                                                                                  rejectJob(Provider.of<CurrentJobsProvider>(context,listen: false).getAllNewJobs()[index], _controller_reason_of_rejection.text.trim());
                                                                                }
                                                                              }),
                                                                              CustomButton('Cancel',
                                                                                  _width * 0.3,
                                                                                  background: Colors.grey[100],
                                                                                  () {
                                                                                Navigator.of(context, rootNavigator: true).pop(false);
                                                                              }),
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
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    rejectDialog_with_reason);

                                                            /// to reject
                                                          }),

                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
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
                          /*StreamBuilder<NewJob>(
                              stream: streamController_jobs.stream,
                              builder: (context, newJob) {
                                if (newJob.hasData) {
                                  return ListView.builder(
                                    //scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    //itemCount: _newJobs.length,
                                    itemCount: Provider.of<CurrentJobsProvider>(
                                            context,
                                            listen: false)
                                        .getAllNewJobs()
                                        .length,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (ctx, index) {
                                      return JobsDesign(
                                          width: _width * 0.8,
                                          //newJob_detail: _newJobs[index],
                                          newJob_detail:
                                              Provider.of<CurrentJobsProvider>(
                                                      context,
                                                      listen: false)
                                                  .getAllNewJobs()[index],
                                          function_handle: () {
                                            //print('click oon ${index}');
                                            Dialog errorDialog = Dialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0)),
                                              //this right here
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
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
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
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
                                                    ),
                                                    margin:
                                                        const EdgeInsets.all(10),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  EdgeInsets.all(
                                                                      5),
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 3.0),
                                                                  borderRadius:
                                                                      const BorderRadius
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
                                                                    //'${_newJobs[index].job_date}',
                                                                    '${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].job_date}',
                                                                    style: TextStyle(
                                                                        color: Theme.of(
                                                                                context)
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400),
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
                                                              //'Hours : ${_newJobs[index].no_of_hours}',
                                                              'Hours : ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].no_of_hours}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100),
                                                            ),
                                                            Container(
                                                              color: Colors.grey,
                                                              width: 0.5,
                                                              height: 25,
                                                            ),
                                                            Text(
                                                              //'  ${_newJobs[index].job_id}',
                                                              '  ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].job_id}',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontSize: 18,
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
                                                              //'Start : ${_newJobs[index].start_time}',
                                                              'Start : ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].start_time}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100),
                                                            ),
                                                            Container(
                                                              color: Colors.grey,
                                                              width: 0.5,
                                                              height: 25,
                                                            ),
                                                            Text(
                                                              //' End : ${_newJobs[index].end_time}',
                                                              ' End : ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].end_time}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 20,
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
                                                              color: Colors.black,
                                                            ),
                                                            Text(
                                                              //' ${_newJobs[index].sites}',
                                                              ' ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index].sites}',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  fontSize: 16,
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
                                                            CustomButton('Accept',
                                                                _width * 0.3, () {
                                                              //acceptJob(_newJobs[index]);
                                                              acceptJob(Provider.of<
                                                                          CurrentJobsProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .getAllNewJobs()[index]);
                                                            }),
                                                            CustomButton('Reject',
                                                                _width * 0.3,
                                                                background: Colors
                                                                    .grey[100],
                                                                () {
                                                              ///from reject
                                                              TextEditingController
                                                                  _controller_reason_of_rejection =
                                                                  TextEditingController();
                                                              Dialog
                                                                  rejectDialog_with_reason =
                                                                  Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                12.0)),
                                                                //this right here
                                                                child: Container(
                                                                  //height: _hight * 0.4,
                                                                  width: _width *
                                                                      0.9,
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                7),
                                                                        //width: _width * 0.6
                                                                        decoration: BoxDecoration(
                                                                            color: Theme.of(context).primaryColor,
                                                                            borderRadius: const BorderRadius.only(
                                                                              topLeft:
                                                                                  Radius.circular(12),
                                                                              topRight:
                                                                                  Radius.circular(12),
                                                                            )),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Image.asset(
                                                                                height: 30,
                                                                                width: 30,
                                                                                'assets/images/ic_forget.png'),
                                                                            const Padding(
                                                                              padding:
                                                                                  EdgeInsets.all(8.0),
                                                                              child:
                                                                                  Text(
                                                                                'Reject job',
                                                                                style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    //Theme.of(context).cardColor
                                                                                    fontSize: 20,
                                                                                    fontWeight: FontWeight.bold),
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
                                                                        padding: const EdgeInsets
                                                                                .only(
                                                                            top:
                                                                                10,
                                                                            bottom:
                                                                                5,
                                                                            right:
                                                                                10,
                                                                            left:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.center,
                                                                              children: [
                                                                                Container(
                                                                                  padding: const EdgeInsets.all(5),
                                                                                  child: CustomTextField(_width * 0.6, 'Reason to reject job', '', TextInputType.name, _controller_reason_of_rejection),
                                                                                )
                                                                              ],
                                                                            ),
                                                                            const SizedBox(
                                                                              height:
                                                                                  15,
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                CustomButton('Submit', _width * 0.3, () {
                                                                                  if (_controller_reason_of_rejection.text.isEmpty) {
                                                                                    Helper.Toast('Invalid reason', Colors.grey);
                                                                                  } else {
                                                                                    Helper.showLoading(context);
                                                                                    //rejectJob(_newJobs[index], _controller_reason_of_rejection.text.trim());
                                                                                    rejectJob(Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs()[index], _controller_reason_of_rejection.text.trim());
                                                                                  }
                                                                                }),
                                                                                CustomButton('Cancel', _width * 0.3, background: Colors.grey[100], () {
                                                                                  Navigator.of(context, rootNavigator: true).pop(false);
                                                                                }),
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
                                                            }),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    errorDialog);
                                          });
                                    },
                                  );
                                } else {
                                  return SizedBox(
                                    height: _hight * 0.8,
                                    child: Helper.LoadingWidget(context),
                                  );
                                }
                              },
                            )*/
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
                                              newJob_detail: _acceptedJobs[index],
                                              function_handle: () {
                                                if (_acceptedJobs[index]
                                                        .job_status ==
                                                    'Patrol_started') {
                                                  Navigator.of(context).pushNamed(
                                                      FinishJobScreen.routeName,
                                                      arguments:
                                                          _acceptedJobs[index]);
                                                } else {
                                                  Navigator.of(context).pushNamed(
                                                      SiteSchedule.routeName,
                                                      arguments:
                                                          _acceptedJobs[index]);
                                                }

                                                //print('click oon ${index}');
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
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void loadData() async {
    loadNewJobs(Constants.TYPE_NEW_JOBS);
    loadNewJobs(Constants.TYPE_ACCEPTED_JOBS);
  }

  void loadNewJobs(String job_type) async {
    final parameters = {
      'type': Constants.PATROL_LISTING,
      'office_name': officeName,
      'guard_id': gard_id,
      'job_type': job_type,
      'offset': 0, //from start to all
    };
    final respoce = await restClient.get(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    bool haveStartedJob = false;
    print('reprocess is here of new jobs ${respoce.data} ');
    if (respoce.data['RESULT'] == 'OK' ) { //&& respoce.data['status'] == 1
      new_jobs = respoce.data['new_count']??0;
      accepted_jobs = respoce.data['accepted_count']??0;
      print("new jobs are   ${new_jobs}    accepted are   ${accepted_jobs}    type : ${job_type}");

      if (job_type == Constants.TYPE_NEW_JOBS) {
        //_newJobs.clear();
        Provider.of<CurrentJobsProvider>(context, listen: false).removeAllNewJobs();
        print(' new jobs after clear  ${Provider.of<CurrentJobsProvider>(context, listen: false).getAllNewJobs().length}');
        NewJob nj;
        for (int i = 0; i < new_jobs; i++) {
          print('total new jobs  ${i}');
          //_newJobs.add(NewJob(
          nj = NewJob(
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
                  ['visitors_log_count']);
          Provider.of<CurrentJobsProvider>(context, listen: false)
              .addNewJob(nj);
          streamController_jobs.sink.add(nj);
        }
      } else if (job_type == Constants.TYPE_ACCEPTED_JOBS) {
        _acceptedJobs.clear();
        NewJob njb;
        for (int i = 0; i < accepted_jobs; i++) {
          njb = NewJob(
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
                  ['visitors_log_count']);
          _acceptedJobs.add(njb);

          if (respoce.data['DATA'][i]['job_status'] == 'Patrol_started') {
            //if(LocalDatabase.getString(LocalDatabase.STARTED_JOB)=='null'){
            print('this job already started...${respoce.data['DATA'][i]['job_status']}');
            LocalDatabase.saveString(LocalDatabase.STARTED_JOB, respoce.data['DATA'][i]['job_id']);
            //}
            haveStartedJob = true;
          }
        }
        if (!haveStartedJob) {
          print('havet running job...');
          LocalDatabase.saveString(LocalDatabase.STARTED_JOB, 'null');
          Helper.stopTracking();
        }
      }
    }

    // firstTimeOpenScreen = isloading;
    // isloading = false;
    print('current job set state run 1 ...${firstTimeOpenScreen}');
    /*if (firstTimeOpenScreen) {
      //run only once
      print('current job set state run...');
      firstTimeOpenScreen = false; //isloading
      setState(() {});
    }*/
    setState(() {});
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
    final respose = await restClient.post(Constants.BASE_URL + "",
        headers: {}, body: parameters);

    print('job accepted, response is..... ${respose.data}');
    Navigator.of(context, rootNavigator: true).pop(false);

    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      Helper.Toast(respose.data['msg'], Constants.toast_grey);
      loadData();
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

    final respose = await restClient.post(Constants.BASE_URL + "",
        headers: {}, body: parameters);
    Navigator.pop(context); //for loader
    Navigator.of(context, rootNavigator: true).pop(false);
    print('job rejected, response is..... ${respose.data}');
    if (respose.data['RESULT'] == 'OK' && respose.data['status'] == 1) {
      Helper.Toast(respose.data['msg'], Constants.toast_grey);
      loadData();
      Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: job);
    } else {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
