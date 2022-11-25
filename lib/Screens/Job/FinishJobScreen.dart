import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Helper.dart';
import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:gard_msg_flutter/Screens/Job/CheckCallsScreen.dart';

import '../../Helper/Constants.dart';
import '../HomeScreen.dart';
import 'IncedentShowSceen.dart';

class FinishJobScreen extends StatefulWidget {
  static const routeName = '/FinishJobScreen';

  const FinishJobScreen({Key? key}) : super(key: key);

  @override
  State<FinishJobScreen> createState() => _FinishJobScreenState();
}

class _FinishJobScreenState extends State<FinishJobScreen> {
  NewJob? job;

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)?.settings.arguments as NewJob?;

    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Site Schedule',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                Helper.makePhoneCall(office_phone);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Constants.ic_phone,
                  size: 30,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        width: width,
        height: hight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: hight * 0.35,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          CheckCallsScreen.routeName,
                          arguments: job!);
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_check_points.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Check calls',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
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
                                          '${job!.check_point_count.toString()}',
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
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          IncedentShowScreen.routeName,
                          arguments: job!);
                    },
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_incidents.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Incidents',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
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
                                          '${job!.incidents_count.toString()}',
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
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: width * 0.9,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          shape: BoxShape.rectangle),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                  height: 30,
                                  width: 30,
                                  'assets/images/ic_visitor.png'),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'Visitors',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.white),
                                ),
                              ),
                            ],
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
                                          '${job!.visitors_log_count.toString()}',
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
                  ),
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_sos.png'),
                              const Text(
                                'SOS\nmsg',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_update_pro.png'),
                              const Text(
                                'Update\nprog',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: width * 0.25,
                          padding: const EdgeInsets.only(top: 7, bottom: 7),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              shape: BoxShape.rectangle),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                  height: 25,
                                  width: 25,
                                  'assets/images/ic_scan.png'),
                              const Text(
                                'Update\nlocation',
                                style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 10,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  job!.job_date.toString(),
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  job!.job_id.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w100),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start : ${job!.start_time.toString()}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'End  : ${job!.end_time.toString()}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${job!.no_of_hours.toString()} Hours',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'End  : ${job!.end_time.toString()}',
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Constants.ic_location,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                    Text(
                      '${job!.sites.toString()}',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Icon(
                  Constants.ic_arrow_forword,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            SizedBox(
              width: width * 0.8,
              child: ElevatedButton(
                  onPressed: () {
                    /// finish job here
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(
                      'Finish Job',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
