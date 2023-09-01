import 'package:flutter/material.dart';

class PreferenceProvider with ChangeNotifier {
  bool isDarkMode = false;

  // 필터 관련
  bool isFilterEnable = false;
  String? questNameFilter;
  String? tagNameFilter;

  setDarkMode(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }

  updateFilterEnable() {
    isFilterEnable = (questNameFilter != null) || (tagNameFilter != null);
    notifyListeners();
  }

  setQuestNameFilter(String string) {
    if (string == "") {
      questNameFilter = null;
    } else {
      questNameFilter = string;
    }
    updateFilterEnable();
  }

  setTagNameFilter(String string) {
    if (string == "") {
      tagNameFilter = null;
    } else {
      tagNameFilter = string;
    }
    updateFilterEnable();
  }
}
