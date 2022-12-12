import 'package:flutter/material.dart';

class DatePicked extends ChangeNotifier {
  String startDate = '';
  String endDate = '';

  void setStartDate(String date) {
    startDate = date;
    notifyListeners();
  }

  void setEndDate(String date) {
    endDate = date;
    notifyListeners();
  }


  String getStatDate() {
    return startDate;
  }

  String getEndDate() {
    return endDate;
  }
}
