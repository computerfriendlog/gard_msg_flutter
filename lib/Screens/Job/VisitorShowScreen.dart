import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Models/Visitor.dart';
import 'package:gard_msg_flutter/Widgets/VisitorsRowDesign.dart';
import '../../APIs/RestClient.dart';
import '../../Helper/Constants.dart';
import '../../Helper/Helper.dart';
import '../../Helper/LocalDatabase.dart';
import '../../Models/Incident.dart';
import '../HomeScreen.dart';
import 'AddVisitorScreen.dart';

class VisitorShowScreen extends StatefulWidget {
  static const routeName = '/VisitorShowScreen';

  const VisitorShowScreen({Key? key}) : super(key: key);

  @override
  State<VisitorShowScreen> createState() => _VisitorShowScreenState();
}

class _VisitorShowScreenState extends State<VisitorShowScreen> {
  final restClient = RestClient();
  TextEditingController _controller_msg = TextEditingController();
  final List<Visitor> visitors_list = []; //change type
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVisitors();
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
        actions: [
          InkWell(
              onTap: () {
                ///open new screen to add visitor
                Navigator.pushNamed(context, AddVisitorScreen.routeName);
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
                  itemCount: visitors_list.length,
                  physics: const ScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    //return Container();
                     return VisitorsRowDesign(
                       visitor: visitors_list[index],
                     );
                  },
                )
              : Helper.LoadingWidget(context)),
    ));
  }

  void loadVisitors() async {
    // await Helper.determineCurrentPosition();
    String job_idd = await LocalDatabase.getString(LocalDatabase.STARTED_JOB);
    print('job id is   ${job_idd}');
    try {
      final parameters = {
        'type': Constants.FETCH_VISITORS,
        'office_name': officeName,
        'job_id': job_idd,
        'guard_id': gard_id,
      };
      final respoce = await restClient.get(
          Constants.BASE_URL + "guardappv4.php",
          headers: {},
          body: parameters);
      print('respose is here of visitors ${respoce.data} ');
      visitors_list.clear();
      if (respoce.data['RESULT'] == 'OK' && respoce.data['status'] == 1) {
        respoce.data['DATA'].forEach((value) {
          print('incident value is hrer   ${value['notes']}');
          visitors_list.add(Visitor(
            name: value['name'],
            company: value['company'],
            log_date: value['log_date'],
            time_in: value['time_in'],
            time_out: value['time_out'],
            vehicle_reg: value['vehicle_reg'],
            visit_purpose: value['visit_purpose'],
          ));
        });
        print('incidents are ${visitors_list.length.toString()}');
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
