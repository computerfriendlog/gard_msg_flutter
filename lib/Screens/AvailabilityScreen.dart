import 'package:flutter/material.dart';

import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import 'HomeScreen.dart';

class AvailabilityScreen extends StatefulWidget {
  static const routeName = '/AvailabilityScreen';

  const AvailabilityScreen({Key? key}) : super(key: key);

  @override
  State<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends State<AvailabilityScreen> {
  MediaQueryData? mediaQueryData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData!.size.height;
    var width = mediaQueryData!.size.width;
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
                  padding: const EdgeInsets.only(bottom: 5,top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: width*0.45,
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: TextButton(
                            onPressed: () {},
                            child:  Text(
                              'Set availability',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: width*0.04),
                            )),
                      ),
                      Container(
                        width: width*0.45,
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: const BorderRadius.all(Radius.circular(10))
                        ),
                        child: TextButton(
                            onPressed: () {},
                            child:  Text(
                              'Request TimeOff',
                              style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: width*0.04),
                            )),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width*0.9,
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(10))
                  ),
                  child: TextButton(
                      onPressed: () {},
                      child:  Text(
                        'Request holiday',
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: width *.05),
                      )),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'show all request here below',
                      style: TextStyle(
                          fontWeight: FontWeight.w100, fontSize: 25),
                    )),

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

  void loadRequests() {

  }
}
