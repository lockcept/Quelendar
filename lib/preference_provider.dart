import 'package:flutter/material.dart';

class PreferenceProvider with ChangeNotifier {
  bool isDarkMode = false;

  setDarkMode(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
