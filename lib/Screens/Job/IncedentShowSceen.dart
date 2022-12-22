import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import 'package:gard_msg_flutter/Widgets/IncidentsRowDesign.dart';
import '../../APIs/RestClient.dart';
import 'dart:io';
import '../../Helper/Helper.dart';
import '../../Helper/LocalDatabase.dart';
import '../../Models/Incident.dart';
import '../../Models/NewJob.dart';
import '../HomeScreen.dart';
import 'AddIncidentScreen.dart';

class IncedentShowScreen extends StatefulWidget {
  static const routeName = '/IncedentShowScreen';

  const IncedentShowScreen({Key? key}) : super(key: key);

  @override
  State<IncedentShowScreen> createState() => _IncedentShowScreenState();
}

class _IncedentShowScreenState extends State<IncedentShowScreen> {
  NewJob? job;
  final restClient = RestClient();
  bool isLoading = true;
  List<Incident> incident_list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadIncidents();
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)?.settings.arguments as NewJob?;
    print('ffaffdfasfdafsaf ${job!.job_id}');
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData.size.height;
    var width = mediaQueryData.size.width;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'Incidents',
          style: TextStyle(fontWeight: FontWeight.w100, fontSize: 20),
        ),
        actions: [
          InkWell(
              onTap: () {
                ///open new screen to add visitor
                Navigator.pushNamed(context, AddIncidentScreen.routeName);
              },
              child: Container(
                padding: const EdgeInsets.only(right: 10, left: 10),
                margin: const EdgeInsets.all(10),
                /* decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20))),*/
                child: Center(
                    child: Stack(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.white,
                      size: 35,
                    ),
                    Icon(
                      Constants.ic_add,
                      color: Theme.of(context).primaryColor,
                      size: 35,
                    ),
                  ],
                )),
              )),
        ],
      ),
      body: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(5),
          width: width,
          height: hight,
          child: !isLoading
              ? ListView.builder(
                  //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: incident_list.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return IncidentsRowDesign(
                      incident: incident_list[index],
                    );
                  },
                )
              : Helper.LoadingWidget(context)),
    ));
  }

  void loadIncidents() async {
    // await Helper.determineCurrentPosition();
    String job_idd = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    print('job id is   ${job_idd}');
    try {
      final parameters = {
        'type': Constants.job_incidents_list,
        'office_name': officeName,
        'job_id': job_idd,
        'guard_id': gard_id,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "",
          headers: {},
          body: parameters);
      print('respose is here of incidents  ${respoce.data} ');
      incident_list.clear();
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        respoce.data['DATA'].forEach((value) {
          //print('incident value is hrer   ${value['notes']}');
          incident_list.add(Incident(
              id: value['id'],
              job_id: value['job_id'],
              name: value['name'],
              incident_type: value['incident_type'],
              logged_by: value['Logged_by'],
              notes: value['notes']??'null'));
        });
        print('incidents are ${incident_list.length.toString()}');
      }else if(respoce.data['status'] == 0){
        Helper.Toast("Data not found", Constants.toast_red);
      } else {
        Helper.Toast("Cannot load incidents", Constants.toast_red);
      }
      isLoading = false;
      setState(() {});
    } catch (e) {
      print('llllllllllllllllllllllllll');
      print(e);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      isLoading = false;
      setState(() {});
    }
  }
}
