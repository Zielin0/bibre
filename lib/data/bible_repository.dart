import 'package:bibre/data/bible_api_provider.dart';
import 'package:bibre/model/bible_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class BibleRepository {
  BibleApiProvider apiProvider = BibleApiProvider();

  Future<Either<String, BibleInfoModel>> fetchBibleInfoData() async {
    try {
      Response response = await apiProvider.getBibleInfoData();

      if (response.statusCode == 200) {
        BibleInfoModel bibleInfo = BibleInfoModel.fromJson(response.data);

        return right(bibleInfo);
      } else {
        return left("Wypadek! Nie można pobrać danych.");
      }
    } catch (e) {
      return left("Wypadek! Nie można pobrać danych.");
    }
  }

  Future<Either<String, ExpandedBookInfoModel>> fetchBookInfoData(
      String bookAbbrev) async {
    try {
      Response response = await apiProvider.getBookInfoData(bookAbbrev);

      if (response.statusCode == 200) {
        ExpandedBookInfoModel bookInfoModel =
            ExpandedBookInfoModel.fromJson(response.data);

        return right(bookInfoModel);
      } else {
        return left("Wypadek! Nie można pobrać danych.");
      }
    } catch (e) {
      return left("Wypadek! Nie można pobrać danych.");
    }
  }

  Future<Either<String, ChapterModel>> fetchChapterData(
      String abbrev, int chapter) async {
    try {
      Response response = await apiProvider.getChapterData(abbrev, chapter);

      if (response.statusCode == 200) {
        ChapterModel chapter = ChapterModel.fromJson(response.data);

        return right(chapter);
      } else {
        return left("Wypadek! Nie można pobrać danych.");
      }
    } catch (e) {
      return left("Wypadek! Nie można pobrać danych.");
    }
  }

  Future<Either<String, SearchModel>> fetchSearchData(
      String search, int page) async {
    try {
      Response response = await apiProvider.getSearchData(search, page);

      if (response.statusCode == 200) {
        SearchModel searchModel = SearchModel.fromJson(response.data);

        return right(searchModel);
      } else {
        return left("Podczas wyszukiwania wystąpił błąd.");
      }
    } catch (e) {
      return left("Podczas wyszukiwania wystąpił błąd.");
    }
  }

  Future<Either<String, ChapterModel>> fetchVerseRangeData(
      String abbrev, int chapter, String verseRange) async {
    try {
      Response response =
          await apiProvider.getVerseRangeData(abbrev, chapter, verseRange);

      if (response.statusCode == 200) {
        ChapterModel chapter = ChapterModel.fromJson(response.data);

        return right(chapter);
      } else {
        return left("Wypadek! Nie można pobrać danych.");
      }
    } catch (e) {
      return left("Wypadek! Nie można pobrać danych.");
    }
  }
}
