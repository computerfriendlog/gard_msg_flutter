import 'package:flutter/material.dart';

import '../Models/NewJob.dart';

class CurrentJobsProvider extends ChangeNotifier {
  final List<NewJob> _newJobs = [];
  final List<NewJob> _acceptedJobs = [];

  void addNewJob(NewJob item) {
    _newJobs.add(item);
    notifyListeners();
  }

  void addAcceptedJob(NewJob item) {
    _acceptedJobs.add(item);
    notifyListeners();
  }

  void removeAllNewJobs() {
    _newJobs.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAllAcceptedJobs() {
    _acceptedJobs.clear();
    notifyListeners();
  }

  List<NewJob> getAllNewJobs() {
    return _newJobs;
  }

  List<NewJob> getAcceptedNewJobs() {
    return _acceptedJobs;
  }
}
