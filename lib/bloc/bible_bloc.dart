import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/data/bible_repository.dart';
import 'package:bibre/model/bible_model.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

class BibleInfoBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  BibleInfoBloc(this.repository) : super(BibleInfoInit()) {
    on<LoadBibleInfoEvent>((event, emit) async {
      emit(BibleInfoLoading());

      Either<String, BibleInfoModel> either =
          await repository.fetchBibleInfoData();

      emit(BibleInfoResponse(either));
    });
  }
}

class BookInfoBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  BookInfoBloc(this.repository) : super(BookInfoInit()) {
    on<LoadBookInfoEvent>((event, emit) async {
      emit(BookInfoLoading());

      Either<String, ExpandedBookInfoModel> either =
          await repository.fetchBookInfoData(event.bookAbbrev);

      emit(BookInfoResponse(either));
    });
  }
}

class SelectionBookInfoBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  SelectionBookInfoBloc(this.repository) : super(SelectionBookInfoInit()) {
    on<LoadSelectionBookInfoEvent>((event, emit) async {
      emit(SelectionBookInfoLoading());

      Either<String, ExpandedBookInfoModel> either =
          await repository.fetchBookInfoData(event.bookAbbrev);

      emit(SelectionBookInfoResponse(either));
    });
  }
}

class ChapterDataBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  ChapterDataBloc(this.repository) : super(ChapterDataInit()) {
    on<LoadChapterDataEvent>((event, emit) async {
      emit(ChapterDataLoading());

      Either<String, ChapterModel> either =
          await repository.fetchChapterData(event.abbrev, event.chapter);

      emit(ChapterDataResponse(either));
    });
  }
}

class SelectionChapterDataBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  SelectionChapterDataBloc(this.repository)
      : super(SelectionChapterDataInit()) {
    on<LoadSelectionChapterDataEvent>((event, emit) async {
      emit(SelectionChapterDataLoading());

      Either<String, ChapterModel> either =
          await repository.fetchChapterData(event.abbrev, event.chapter);

      emit(SelectionChapterDataResponse(either));
    });
  }
}

class SearchDataBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;
  int currentPage = 1;

  SearchDataBloc(this.repository) : super(SearchDataInit()) {
    on<LoadSearchDataEvent>((event, emit) async {
      emit(SearchDataLoading());

      Either<String, SearchModel> either =
          await repository.fetchSearchData(event.search, currentPage);

      emit(SearchDataResponse(either));
    });

    on<LoadMoreSearchDataEvent>((event, emit) async {
      if (event.forward) {
        currentPage++;
      } else {
        currentPage--;
      }

      emit(SearchDataLoading());

      Either<String, SearchModel> either =
          await repository.fetchSearchData(event.search, currentPage);

      emit(SearchDataResponse(either));
    });

    on<ClearSearchDataEvent>((event, emit) {
      currentPage = 1;

      emit(SearchDataInit());
    });
  }
}

class VerseRangeBloc extends Bloc<BibleEvent, BibleState> {
  BibleRepository repository;

  VerseRangeBloc(this.repository) : super(VerseRangeDataInit()) {
    on<LoadVerseRangeDataEvent>((event, emit) async {
      emit(VerseRangeDataLoading());

      Either<String, ChapterModel> either = await repository
          .fetchVerseRangeData(event.abbrev, event.chapter, event.verseRange);

      emit(VerseRangeDataResponse(either));
    });
  }
}
