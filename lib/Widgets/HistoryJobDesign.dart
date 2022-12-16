import 'package:gard_msg_flutter/Models/NewJob.dart';
import 'package:flutter/material.dart';
import '../Helper/Constants.dart';

class HistoryJobsDesign extends StatelessWidget {
  double? width;
  NewJob? newJob_detail;
  void Function()? function_handle;

  HistoryJobsDesign(
      {required this.width,
        required this.newJob_detail,
        required this.function_handle});

  @override
  Widget build(BuildContext context) {
    print(' job status is${newJob_detail!.job_status}');
    return Card(
      elevation: 3,
      child: Container(
        width: width! * .9,
        margin: const EdgeInsets.all(5),
        child: InkWell(
          onTap: function_handle,
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            size: 35,
                            Constants.ic_calender,
                            color: Colors.black,
                          ),
                          Text(
                            ' ${newJob_detail?.job_date}',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                      Text(
                        ' ${newJob_detail?.job_id}',
                        style: const TextStyle(
                            color: Colors.black, //Theme.of(context).cardColor
                            fontSize: 14,
                            fontWeight: FontWeight.w100),
                      ),
                    ]),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Start time: ${newJob_detail?.start_time}',
                      style: const TextStyle(
                          color: Colors.black, //Theme.of(context).cardColor
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                    Text(
                      '${newJob_detail?.no_of_hours} Hours',
                      style: const TextStyle(
                          color: Colors.black, //Theme.of(context).cardColor
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text(
                      'End time:  ${newJob_detail?.end_time}',
                      style: const TextStyle(
                          color: Colors.black, //Theme.of(context).cardColor
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      child: Row(
                        children: [
                          Icon(
                            size: 20,
                            Constants.ic_location,
                            color: Theme.of(context).primaryColor,
                          ),
                          Text(
                            ' ${newJob_detail?.sites}',
                            style: const TextStyle(
                                color: Colors.black,
                                //Theme.of(context).cardColor
                                fontSize: 14,
                                fontWeight: FontWeight.w100),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      size: 22,
                      Constants.ic_arrow_forword,
                      color: Colors.black, //Theme.of(context).primaryColor
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                //newJob_detail!.job_status == 'New' ?
                 Text(
                  newJob_detail!.job_status!,
                  style: const TextStyle(
                      color: Colors.green, //Theme.of(context).cardColor
                      fontSize: 18,
                      fontWeight: FontWeight.w100),
                ),
                    /*: Container(
                  child: newJob_detail!.job_status == 'Patrol_started'
                      ? const Text(
                    'Patrol started',
                    style: TextStyle(
                        color: Colors
                            .green, //Theme.of(context).cardColor
                        fontSize: 14,
                        fontWeight: FontWeight.w100),
                  )
                      : Container(),
                ),*/
                //Divider(),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
