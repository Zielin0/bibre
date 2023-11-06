import 'package:bibre/utils.dart';
import 'package:dio/dio.dart';

class BibleApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> getBibleInfoData() async {
    var response = await _dio.get("${Constants.baseUrl}/info/bt");

    return response;
  }

  Future<dynamic> getBookInfoData(bookAbbrev) async {
    var response = await _dio.get("${Constants.baseUrl}/info/bt/$bookAbbrev");

    return response;
  }

  Future<dynamic> getChapterData(abbrev, chapter) async {
    var response =
        await _dio.get("${Constants.baseUrl}/biblia/bt/$abbrev/$chapter");

    return response;
  }

  Future<dynamic> getSearchData(search, page) async {
    const int resultsPerPage = 25;
    final start = (page - 1) * resultsPerPage + 1;
    final end = page * resultsPerPage;

    var response = await _dio
        .get("${Constants.baseUrl}/szukaj/$search?zakres=$start-$end");

    return response;
  }

  Future<dynamic> getVerseRangeData(abbrev, chapter, verseRange) async {
    var response = await _dio
        .get("${Constants.baseUrl}/biblia/bt/$abbrev/$chapter/$verseRange");

    return response;
  }
}
