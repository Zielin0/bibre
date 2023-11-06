import 'package:bibre/utils.dart';

class BookInfoModel {
  String abbreviation;
  String displayAbbrev;
  String name;

  String partAbbreviation;
  String partName;

  BookInfoModel({
    required this.abbreviation,
    required this.displayAbbrev,
    required this.name,
    required this.partAbbreviation,
    required this.partName,
  });
}

class BibleInfoModel {
  String abbreviation;
  List<BookInfoModel> books = List.empty(growable: true);
  int booksLength;
  String description;
  String language;
  String name;
  String type;

  BibleInfoModel({
    required this.abbreviation,
    required this.books,
    required this.booksLength,
    required this.description,
    required this.language,
    required this.name,
    required this.type,
  });

  factory BibleInfoModel.fromJson(json) {
    var model = BibleInfoModel(
      abbreviation: json["abbreviation"],
      books: List.empty(growable: true),
      booksLength: json["books_length"],
      description: json["description"],
      language: json["language"],
      name: json["name"],
      type: json["type"],
    );

    for (var book in json["books"]) {
      String name = "";
      if (book["name"] == "Apokalipsa (Objawienie)") {
        name = "Apokalipsa";
      } else {
        name = book["name"];
      }

      String abbrev = "";
      if (name == "Apokalipsa") {
        abbrev = "Ap";
      } else {
        abbrev = capitalize(book["abbreviation"]);
      }

      model.books.add(BookInfoModel(
        abbreviation: book["abbreviation"],
        displayAbbrev: abbrev,
        name: name,
        partAbbreviation: book["part"]["abbreviation"],
        partName: book["part"]["name"],
      ));
    }

    return model;
  }
}

class ExpandedBookInfoModel {
  String abbreviation;
  List<dynamic> allAbbreviations = List.empty(growable: true);
  int chapters;
  bool hasZeroChapter;
  String name;

  String partAbbrev;
  String partName;

  ExpandedBookInfoModel({
    required this.abbreviation,
    required this.allAbbreviations,
    required this.chapters,
    required this.hasZeroChapter,
    required this.name,
    required this.partAbbrev,
    required this.partName,
  });

  factory ExpandedBookInfoModel.fromJson(json) {
    return ExpandedBookInfoModel(
      abbreviation: json["abbreviation"],
      allAbbreviations: json["all_abbreviations"],
      chapters: json["chapters"],
      hasZeroChapter: json["has_zero_chapter"],
      name: json["name"],
      partAbbrev: json["part"]["abbreviation"],
      partName: json["part"]["name"],
    );
  }
}

class VerseModel {
  String text;
  String verse;

  VerseModel({
    required this.text,
    required this.verse,
  });
}

class ChapterModel {
  String bibleAbbrev;
  String bibleName;

  String abbrev;
  String name;

  int chapter;
  String type;

  List<VerseModel> verses = List.empty(growable: true);
  String versesRange;

  ChapterModel({
    required this.bibleAbbrev,
    required this.bibleName,
    required this.abbrev,
    required this.name,
    required this.chapter,
    required this.type,
    required this.verses,
    required this.versesRange,
  });

  factory ChapterModel.fromJson(json) {
    String name = "";
    if (json["book"]["name"] == "Apokalipsa (Objawienie)") {
      name = "Apokalipsa";
    } else {
      name = json["book"]["name"];
    }

    var model = ChapterModel(
      bibleAbbrev: json["bible"]["abbreviation"],
      bibleName: json["bible"]["name"],
      abbrev: json["book"]["abbreviation"],
      name: name,
      chapter: json["chapter"],
      type: json["type"],
      verses: List.empty(growable: true),
      versesRange: json["verses_range"],
    );

    for (var verse in json["verses"]) {
      model.verses.add(VerseModel(
        text: verse["text"],
        verse: verse["verse"],
      ));
    }

    return model;
  }
}

class SearchResultModel {
  String bookAbbrev;
  String bookName;

  int chapter;

  List<VerseModel> verses = List.empty(growable: true);

  String versesRange;

  SearchResultModel({
    required this.bookAbbrev,
    required this.bookName,
    required this.chapter,
    required this.verses,
    required this.versesRange,
  });
}

class SearchModel {
  int allResults;

  String bibleAbbrev;
  String bibleName;

  String query;

  List<SearchResultModel> results = List.empty(growable: true);

  String resultsRange;
  String type;

  SearchModel({
    required this.allResults,
    required this.bibleAbbrev,
    required this.bibleName,
    required this.query,
    required this.results,
    required this.resultsRange,
    required this.type,
  });

  factory SearchModel.fromJson(json) {
    var model = SearchModel(
      allResults: json["all_results"],
      bibleAbbrev: json["bible"]["abbreviation"],
      bibleName: json["bible"]["name"],
      query: json["query"],
      results: List.empty(growable: true),
      resultsRange: json["results_range"],
      type: json["type"],
    );

    for (var jsonResult in json["results"]) {
      var result = SearchResultModel(
        bookAbbrev: jsonResult["book"]["abbreviation"],
        bookName: jsonResult["book"]["name"],
        chapter: jsonResult["chapter"],
        verses: List.empty(growable: true),
        versesRange: jsonResult["verses_range"],
      );

      for (var verse in jsonResult["verses"]) {
        result.verses.add(VerseModel(
          text: verse["text"],
          verse: verse["verse"],
        ));
      }

      model.results.add(result);
    }

    return model;
  }
}
