import 'package:flutter/material.dart';
import 'package:gard_msg_flutter/Widgets/CustomButton.dart';

import '../APIs/RestClient.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Models/NewJob.dart';
import '../Widgets/HistoryJobDesign.dart';
import '../Widgets/JobsDesign.dart';
import 'HomeScreen.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/HistoryScreen';

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String dateFrom =
      '01-${Helper.getCurrentTime().month}-${Helper.getCurrentTime().year}';
  String dateTo =
      '${Helper.getCurrentTime().day}-${Helper.getCurrentTime().month}-${Helper.getCurrentTime().year}';

  List<NewJob> list_job = [];
  final restClient = RestClient();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJobs(dateFrom, dateTo);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SizedBox(
          height: _hight,
          width: _width,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text(
                    'Start Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                  ),
                  Text(
                    'End Date',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w100),
                  ),
                ],
              ),
              Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: _width * 0.45,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Constants.ic_calender,
                          size: 30,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime t = await Helper.selectDate(context);
                            dateFrom = '${t.day}-${t.month}-${t.year}';
                            setState(() {});
                          },
                          child: Container(
                            width: _width * 0.35,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                            ),
                            child: Center(
                              child: Text(
                                dateFrom,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: _width * 0.45,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Constants.ic_calender,
                          size: 30,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () async {
                            DateTime t = await Helper.selectDate(context);
                            dateTo = '${t.day}-${t.month}-${t.year}';
                            setState(() {});
                          },
                          child: Container(
                            width: _width * 0.35,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5),
                            ),
                            child: Center(
                              child: Text(
                                dateTo,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w100,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              CustomButton('Show jobs', _width * 0.9, () {
                loadJobs(dateFrom, dateTo);
              }),
              Expanded(
                child: !isLoading
                    ? list_job.isNotEmpty
                        ? ListView.builder(
                            padding: const EdgeInsets.all(5),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: list_job.length,
                            itemBuilder: (ctx, index) {
                              return HistoryJobsDesign(
                                  width: _width * 0.8,
                                  newJob_detail: list_job[index],
                                  function_handle: () {
                                    print('click oon ${index}');
                                  });
                            },
                          )
                        : const Center(
                            child: Text(
                              'Jobs not found',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 20),
                            ),
                          )
                    : Center(
                        child: Helper.LoadingWidget(context),
                      ),
              ),
            ],
          )),
    ));
  }

  void loadJobs(String dtFrom, String dtTo) async {
    //Helper.showLoading(context);
    try {
      final parameters = {
        'type': Constants.JOBS_HISTORY,
        'office_name': officeName,
        'guard_id': gard_id,
        'from_date': dtFrom,
        'to_date': dtTo,
      };
      final respoce = await restClient.get(Constants.BASE_URL + "",
          headers: {}, body: parameters);
      print('reprocess is here of history jobs ${respoce.data} ');
      if (respoce.data['RESULT'] == 'OK') {
        //&& respoce.data['status'] == 1
        list_job.clear();
        //int totalJobs=respoce.data['job_count'];
        /*for(int a=0;a<totalJobs;a++){
          print('line is...   ${respoce.data['DATA'][a]['end_time']}');
        }*/
        respoce.data['DATA'].forEach((value) {
          list_job.add(NewJob(
            //check_point_count: value['check_point_count'],
            //customer_id: value['customer_id'],
            end_time: value['end_time'],
            fare: value['fare'],
            //incidents_count: value['incidents_count'],
            job_date: value['job_date'],
            //job_end_date: value['job_end_date'],
            job_id: value['job_id'],
            job_status: value['status'],
            //job_status
            //latitude: value['latitude'],
            //longitude: value['longitude'],
            mobile: value['mobile'],
            name: value['name'],
            no_of_hours: value['no_of_hours'],
            //restriction_check: value['restriction_check'],
            sites: value['sites'],
            start_time: value['start_time'],
            //time_check: value['time_check'],
            //visitors_log_count: value['visitors_log_count']
          ));
        });
      } else {
        Helper.Toast('Can\'t get jobs, try again', Constants.toast_red);
      }
      // print('jobs loaded... ${list_job.length}');
      isLoading = false;
      setState(() {});
    } catch (e) {
      Helper.Toast(Constants.somethingwentwrong, Constants.toast_red);
      isLoading = false;
      setState(() {});
    }
  }
}
