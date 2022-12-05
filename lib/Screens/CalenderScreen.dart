import 'package:flutter/material.dart';
import 'package:horizontalcalender/date_item_widget.dart';
import 'package:horizontalcalender/extra/color.dart';
import 'package:horizontalcalender/extra/dimen.dart';
import 'package:horizontalcalender/extra/style.dart';
import 'package:horizontalcalender/horizontalcalendar.dart';
import 'package:horizontalcalender/listener/tap.dart';
class CalenderScreen extends StatefulWidget {
  static const routeName = '/CalenderScreen';

  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  MediaQueryData? mediaQueryData;
  final FixedExtentScrollController itemController =
  FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    var hight = mediaQueryData!.size.height;
    var width = mediaQueryData!.size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: hight,
          child: Column(
            children: [
              Row(children: const [
                 Text('Day',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w100,color: Colors.black),),
                Text('Day name \n mon year',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w100,color: Colors.grey),),

              ],),
              HorizontalCalendar( DateTime.now(),
                  width: width*.8,
                  height: 250,
                  selectionColor: Colors.red,
                  itemController: itemController,

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
}
