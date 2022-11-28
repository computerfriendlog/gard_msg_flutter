import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/HomeScreen.dart';

import '../APIs/RestClient.dart';
import '../Helper/Helper.dart';
import '../Models/Message.dart';
import '../Widgets/JobsDesign.dart';

class MessageScreen extends StatefulWidget {
  static const routeName = '/MessageScreen';

  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final restClient = RestClient();
  bool isLoding = true;
  List<Message>? msg_list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSms();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Message',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SizedBox(
        width: width,
        height: hight,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Helper.makePhoneCall(office_phone);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Constants.ic_phone,
                      color: Colors.grey,
                      size: 30,
                    ),
                    const SizedBox(),
                    const SizedBox(),
                    Text(
                      office_phone,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(),
                    const SizedBox(),
                  ],
                ),
              ),
            ),
            isLoding
                ? ListView.builder(
                    //scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: msg_list?.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return JobsDesign(
                          width: width * 0.8,
                          newJob_detail: NewJob(), //msg_list![index]
                          function_handle: () {
                            //print('click oon ${index}');
                            /*Dialog errorDialog = Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12.0)),
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
                                                '${_newJobs[index].job_date}',
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
                                          'Hours : ${_newJobs[index].no_of_hours}',
                                          style: const TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 16,
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
                                          '  ${_newJobs[index].job_id}',
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
                                              fontSize: 14,
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
                                          ' End : ${_newJobs[index].end_time}',
                                          style: const TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 14,
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
                                          ' ${_newJobs[index].sites}',
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
                                        ElevatedButton(
                                            onPressed: () {
                                              acceptJob(
                                                  _newJobs[
                                                  index]);
                                            },
                                            child: const Text(
                                              'Accept',
                                              style: TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize:
                                                  14,
                                                  fontWeight:
                                                  FontWeight
                                                      .w100),
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
                                                  BorderRadius.circular(
                                                      12.0)),
                                              //this right here
                                              child:
                                              Container(
                                                height:
                                                _hight *
                                                    0.4,
                                                width:
                                                _width *
                                                    0.6,
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
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
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                        children: [
                                                          Image.asset(
                                                              height: 30,
                                                              width: 30,
                                                              'assets/images/ic_forget.png'),
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
                                          style:
                                          ElevatedButton
                                              .styleFrom(
                                            backgroundColor:
                                            Colors.grey[
                                            300],
                                          ),
                                          child: const Text(
                                            'Reject',
                                            style: TextStyle(
                                                color: Colors
                                                    .black,
                                                fontSize: 14,
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
                          builder: (BuildContext context) =>
                          errorDialog);*/
                          });
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void loadSms() async {
    print('getting sms list start');
    final parameters = {
      'type': Constants.MESSAGE_LIST,
      'office_name': officeName,
      'guard_id': gard_id,
      'device_type': deviceType
    };

    final respose = await restClient.post(Constants.BASE_URL + "guardappv4.php",
        headers: {}, body: parameters);
    print('sms list response is here     ${respose.data}');
    // fill the list msg_list
    //Navigator.pop(context);
  }
}
