import 'dart:convert';

import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PercentItem {
  final String abbreviation;
  final String displayAbbreviation;
  final String name;
  bool isChecked;

  PercentItem({
    required this.abbreviation,
    required this.displayAbbreviation,
    required this.name,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "abbreviation": abbreviation,
      "displayAbbreviation": displayAbbreviation,
      "name": name,
      "isChecked": isChecked,
    };
  }

  factory PercentItem.fromMap(Map<String, dynamic> map) {
    return PercentItem(
      abbreviation: map["abbreviation"],
      displayAbbreviation: map["displayAbbreviation"],
      name: map["name"],
      isChecked: map["isChecked"] ?? false,
    );
  }
}

class PercentController extends GetxController {
  RxList<PercentItem> items = <PercentItem>[].obs;

  @override
  void onInit() {
    loadItems();
    super.onInit();
  }

  void addItem(PercentItem item) {
    items.add(item);
    saveItems();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("percent");

    if (jsonString != null) {
      final itemsList = (json.decode(jsonString) as List)
          .map((item) => PercentItem.fromMap(item))
          .toList();

      items.assignAll(itemsList);
    }
  }

  void saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toMap()).toList());

    prefs.setString("percent", jsonString);
  }

  void removeItems() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("percent");
  }

  Future<void> loadAndStoreData(
      PercentController percentController, BibleInfoBloc bibleInfoBloc) async {
    if (percentController.items.isEmpty) {
      bibleInfoBloc.add(LoadBibleInfoEvent());

      bibleInfoBloc.stream.listen((state) {
        if (state is BibleInfoResponse) {
          state.either.fold(
            (error) {},
            (data) {
              for (var book in data.books) {
                addItem(
                  PercentItem(
                    abbreviation: book.abbreviation,
                    displayAbbreviation: book.displayAbbrev,
                    name: book.name,
                    isChecked: false,
                  ),
                );
              }

              saveItems();
            },
          );
        }
      });
    }
  }

  int getCheckedAmount() {
    int checked = 0;
    for (var item in items) {
      if (item.isChecked) checked++;
    }

    return checked;
  }
}
