import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuoteItem {
  int id;
  final String abbrev;
  final int chapter;
  final String verseRange;

  QuoteItem({
    required this.id,
    required this.abbrev,
    required this.chapter,
    required this.verseRange,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "abbrev": abbrev,
      "chapter": chapter,
      "verseRange": verseRange,
    };
  }

  factory QuoteItem.fromMap(Map<String, dynamic> map) {
    return QuoteItem(
      id: map["id"],
      abbrev: map["abbrev"],
      chapter: map["chapter"],
      verseRange: map["verseRange"],
    );
  }
}

class QuoteController extends GetxController {
  RxList<QuoteItem> items = <QuoteItem>[].obs;

  @override
  void onInit() {
    loadItems();
    super.onInit();
  }

  Future<void> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("quotes");

    if (jsonString != null) {
      final itemsList = (json.decode(jsonString) as List)
          .map((item) => QuoteItem.fromMap(item))
          .toList();

      items.assignAll(itemsList);
    }
  }

  void saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toMap()).toList());

    prefs.setString("quotes", jsonString);
  }

  void removeItems() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.remove("quotes");
  }

  void addItem(QuoteItem item) {
    if (items.isNotEmpty) {
      item.id = items.first.id + 1;
    } else {
      item.id = 1;
    }

    items.insert(0, item);
    saveItems();
  }

  void removeItem(int id) {
    final itemToRemove = items.firstWhere(
      (item) => item.id == id,
      orElse: () => QuoteItem(id: -1, abbrev: "", chapter: -1, verseRange: ""),
    );

    if (itemToRemove.id != -1) {
      items.remove(itemToRemove);
      saveItems();
    }
  }
}
