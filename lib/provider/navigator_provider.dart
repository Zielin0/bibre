import 'package:flutter/material.dart';

class NavigatorProvider extends ChangeNotifier {
  String status = "home";

  void changeStatus(String itemName) {
    status = itemName;
    notifyListeners();
  }

  String get newStatus => status;
}
