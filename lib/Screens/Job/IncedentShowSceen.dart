import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Helper/Constants.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Helper.dart';
import '../../Models/NewJob.dart';
import '../HomeScreen.dart';

class IncedentShowScreen extends StatefulWidget {
  static const routeName = '/IncedentShowScreen';

  const IncedentShowScreen({Key? key}) : super(key: key);

  @override
  State<IncedentShowScreen> createState() => _IncedentShowScreenState();
}

class _IncedentShowScreenState extends State<IncedentShowScreen> {
  NewJob? job;
  final restClient = RestClient();

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
                //Navigator.pushNamed(context, AddIncidentScreen.routeName);
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
        margin: const EdgeInsets.all(10),
        width: width,
        height: hight,
        child: Column(
          children: [],
        ),
      ),
    ));
  }

  void loadIncidents() async {
    // await Helper.determineCurrentPosition();
    print("jjjjjjjjjjmmmmmmm   ${job!.job_id}");
    try {
      final parameters = {
        'type': Constants.job_incidents_list,
        'office_name': officeName,
        'job_id': job!.job_id,
        'guard_id': gard_id,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);

      print('respose is here of check calls ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
      } else {
        Helper.Toast("Cannot load incidents", Constants.toast_red);
      }
    } catch (e) {
      print('llllllllllllllllllllllllll');
      print(e);
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
    }
  }
}
