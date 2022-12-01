import 'package:flutter/material.dart';

import '../Helper/LocalDatabase.dart';

class GuardStatus extends ChangeNotifier {
     bool gaurdStuts=false;

  void changeStatus(bool value) {
    gaurdStuts=value;
    LocalDatabase.setAvailable(gaurdStuts);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
    bool getStatus() {
      //notifyListeners();
      return gaurdStuts;
    }

}