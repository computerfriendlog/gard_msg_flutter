import 'package:flutter/material.dart';

class ImagesArray extends ChangeNotifier {
  final List<String> _imagePaths = [];

  void add(String item) {
    _imagePaths.add(item);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeAll() {
    _imagePaths.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

}
