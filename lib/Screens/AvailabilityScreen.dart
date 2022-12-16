import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';
import 'package:gard_msg_flutter/Widgets/RequestRowDesign.dart';
import 'dart:async';
import '../APIs/RestClient.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Models/GaurdRequest.dart';
import '../Providers/DatePicked.dart';
import 'HomeScreen.dart';
import 'package:quiver/time.dart';
import 'package:provider/provider.dart';

class AvailabilityScreen extends StatefulWidget {
  static const routeName = '/AvailabilityScreen';

  const AvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  MediaQueryData? mediaQueryData;
  final restClient = RestClient();
  List<GaurdRequest> request_list = [];
  bool isLoding = true;
  String start = '';
  String end = '';
  var hight;
  var width;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    start =
        "1-${Helper.getCurrentTime().month}-${Helper.getCurrentTime().year}";
    end =
        "${daysInMonth(Helper.getCurrentTime().year, Helper.getCurrentTime().month)}-${Helper.getCurrentTime().month}-${Helper.getCurrentTime().year}";
    print('start date is ${start}  end is ${end}');
    loadRequests(start, end);
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    hight = mediaQueryData!.size.height;
    width = mediaQueryData!.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Availability',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Helper.makePhoneCall(office_phone);
            },
            child: Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Constants.ic_phone,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    office_phone,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
            width: width,
            height: hight,
            margin: const EdgeInsets.all(5),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width * 0.45,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextButton(
                            onPressed: () async {
                              requestForOff(Constants.AVAILABILITY_STORE);
                            },
                            child: Text(
                              'Set availability',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: width * 0.04),
                            )),
                      ),
                      Container(
                        width: width * 0.45,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: TextButton(
                            onPressed: () {
                              requestForTimeOff();
                            },
                            child: Text(
                              'Request TimeOff',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: width * 0.04),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  child: TextButton(
                      onPressed: () {
                        requestForOff(Constants.HOLIDAY_STORE);
                      },
                      child: Text(
                        'Request holiday',
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: width * .05),
                      )),
                ),
                Expanded(
                  child: !isLoding
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: request_list.length,
                          physics: const ScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return RequestRowDesign(
                              request: request_list[index],
                            );
                          },
                        )
                      : Helper.LoadingWidget(context),
                ),

                /* HorizontalCalendar(
                  this.startDate, {
                Key? key,
                this.width = 40,
                this.height = 80,
                this.controller,
                this.monthTextStyle,
                this.dayTextStyle,
                this.dateTextStyle,
                this.selectedTextColor,
                this.selectionColor,
                this.deactivatedColor,
                this.initialSelectedDate,
                this.activeDates,
                this.inactiveDates,
                this.daysCount = 500,
                this.onDateChange,
                this.locale = "en_US",
                this.selectedDayStyle,
                this.selectedDateStyle,
                required this.itemController,
              })*/
              ],
            )),
      ),
    );
  }

  void loadRequests(String startDate, String toDate) async {
    try {
      final parameters = {
        'type': Constants.DRIVER_ATTENDANCE,
        'office_name': officeName,
        'from_date': startDate,
        'to_date': toDate,
        'driver_id': gard_id,
      };

      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print(
          'request responce is hereeee.         $respoce   khankkk  ${respoce.data['DATA'][0]}');
      request_list.clear();
      if (respoce.data['RESULT'] == 'OK' && respoce.data['STATUS'] == 1) {
        respoce.data['DATA'].forEach((value) {
          request_list.add(GaurdRequest(
              approval_status: value['approval_status'],
              bg_color: value['bg_color'],
              from_date: value['from_date'],
              to_date: value['to_date'],
              start_time: value['start_time'],
              end_time: value['end_time'],
              label: value['label'],
              user_id: value['user_id']));
        });
        print('list filld ${request_list.length}');
      } else {
        Helper.Toast('Can\'t get requests,try again', Constants.toast_grey);
      }
      isLoding = false;
      setState(() {});
    } catch (e) {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      isLoding = false;
      setState(() {});
    }
  }

  void requestOff(String sDate, String tDate, String type) async {
    print('s date $sDate      t date   $tDate');
    Helper.showLoading(context);
    try {
      final parameters = {
        'type': type, //AVAILABILITY_STORE
        'office_name': officeName,
        'from_date': sDate,
        'to_date': tDate,
        'driver_id': gard_id,
      };

      final respoce = await restClient.post(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print(
          'set availability responce is hereeee.         $respoce   khankkk  ${respoce.data['DATA']}');

      if (respoce.data['RESULT'] == 'OK' && respoce.data['STATUS'] == 1) {
        Helper.Toast('Request sent', Constants.toast_grey);
        Navigator.pop(context); //for loader
        Navigator.pop(context); //for dialog
        loadRequests(start, end);
      } else {
        Navigator.pop(context); //for loader
        Navigator.pop(context); //for dialog
        Helper.Toast('Can\'t send request,try again', Constants.toast_grey);
      }
    } catch (e) {
      Navigator.pop(context); //for loader
      Navigator.pop(context); //for dialog
      print('available exception is here ${e.toString()}');
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }

  void requestForOff(String type) async {
    DateTime startDate = Helper.getCurrentTime();
    DateTime endDate = Helper.getCurrentTime();
    // date selector
    final DateTime picked = await Helper.selectDate(context);
    if (picked != null) {
      startDate = picked;
      print('date selected start ${startDate}');
    }

    final DateTime picked2 = await Helper.selectDate(context);
    if (picked2 != null) {
      endDate = picked2;
      print('date selected end ${endDate}');
    }

    Dialog setAvailabilityDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      'Request Holiday',
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
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Start Date',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${startDate.day}-${startDate.month}-${startDate.year}',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'End Date',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // date selector
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${endDate.day}-${endDate.month}-${endDate.year}',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton('Request', width * 0.5, () {
                    requestOff(
                        '${startDate.day}-${startDate.month}-${startDate.year}',
                        '${endDate.day}-${endDate.month}-${endDate.year}',
                        type);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => setAvailabilityDialog);
  }

  void requestForTimeOff() async {
    DateTime date_of_off = Helper.getCurrentTime();
    TimeOfDay selectedTimefrom = TimeOfDay.now();
    TimeOfDay selectedTimeTo = TimeOfDay.now();
    // date selector
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: Helper.getCurrentTime(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null) {
      date_of_off = picked;
      print('date selected start ${date_of_off}');
    }
    selectedTimefrom= await Helper.selectTime(context);
    selectedTimeTo= await Helper.selectTime(context);


    Dialog setAvailabilityDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      //this right here
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
                      'Request Timeoff',
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
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Date',
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color:
                            Theme.of(context).primaryColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w100),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {},
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.grey)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '${date_of_off.day}-${date_of_off.month}-${date_of_off.year}',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Start Time',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                    Theme.of(context).primaryColor.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${selectedTimefrom.hour}:${selectedTimefrom.minute}',
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w100),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'End Time',
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                    Theme.of(context).primaryColor.withOpacity(0.5),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                                border: Border.all(color: Colors.grey)),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${selectedTimeTo.hour}:${selectedTimeTo.minute}',
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w100),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CustomButton('Request', width * 0.5, () {
                    requestAPITimeOff('${date_of_off.day}-${date_of_off.month}-${date_of_off.year}','${selectedTimefrom.hour}:${selectedTimefrom.minute}','${selectedTimeTo.hour}:${selectedTimeTo.minute}');//
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => setAvailabilityDialog);
  }

  void requestAPITimeOff(String dat,String startTime,String endTime) async {
    Helper.showLoading(context);
    try {
      final parameters = {
        'type': Constants.REQUEST_TIME_OFF,
        'office_name': officeName,
        'date': dat,
        'start_time': startTime,
        'end_time': endTime,
        'driver_id': gard_id,
      };

      final respoce = await restClient.post(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('set off on specific date and time responce is hereeee.         $respoce   khankkk  ${respoce.data['DATA']}');

      if (respoce.data['RESULT'] == 'OK' && respoce.data['STATUS'] == 1) {
        Helper.Toast('Request sent', Constants.toast_grey);
        Navigator.pop(context); //for loader
        Navigator.pop(context); //for dialog
        loadRequests(start, end);
      } else {
        Navigator.pop(context); //for loader
        Navigator.pop(context); //for dialog
        Helper.Toast('Can\'t send request,try again', Constants.toast_grey);
      }
    } catch (e) {
      Navigator.pop(context); //for loader
      Navigator.pop(context); //for dialog
      print('available exception is here ${e.toString()}');
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
