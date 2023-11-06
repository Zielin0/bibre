import 'package:bibre/model/bible_model.dart';
import 'package:dartz/dartz.dart';

abstract class BibleState {}

// Bible Info

class BibleInfoInit extends BibleState {}

class BibleInfoLoading extends BibleState {}

class BibleInfoResponse extends BibleState {
  Either<String, BibleInfoModel> either;

  BibleInfoResponse(this.either);
}

// Book Info

class BookInfoInit extends BibleState {}

class BookInfoLoading extends BibleState {}

class BookInfoResponse extends BibleState {
  Either<String, ExpandedBookInfoModel> either;

  BookInfoResponse(this.either);
}

// SelectionBook Info

class SelectionBookInfoInit extends BibleState {}

class SelectionBookInfoLoading extends BibleState {}

class SelectionBookInfoResponse extends BibleState {
  Either<String, ExpandedBookInfoModel> either;

  SelectionBookInfoResponse(this.either);
}

// Chapter Data

class ChapterDataInit extends BibleState {}

class ChapterDataLoading extends BibleState {}

class ChapterDataResponse extends BibleState {
  Either<String, ChapterModel> either;

  ChapterDataResponse(this.either);
}

// Selection Chapter Data

class SelectionChapterDataInit extends BibleState {}

class SelectionChapterDataLoading extends BibleState {}

class SelectionChapterDataResponse extends BibleState {
  Either<String, ChapterModel> either;

  SelectionChapterDataResponse(this.either);
}

// Search Data

class SearchDataInit extends BibleState {}

class SearchDataLoading extends BibleState {}

class SearchDataResponse extends BibleState {
  Either<String, SearchModel> either;

  SearchDataResponse(this.either);
}

// Verse Range Data

class VerseRangeDataInit extends BibleState {}

class VerseRangeDataLoading extends BibleState {}

class VerseRangeDataResponse extends BibleState {
  Either<String, ChapterModel> either;

  VerseRangeDataResponse(this.either);
}
