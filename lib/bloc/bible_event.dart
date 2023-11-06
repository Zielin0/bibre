abstract class BibleEvent {}

// Bible Info

class LoadBibleInfoEvent extends BibleEvent {}

// Book Info

class LoadBookInfoEvent extends BibleEvent {
  String bookAbbrev;

  LoadBookInfoEvent(this.bookAbbrev);
}

// Selection Book Info

class LoadSelectionBookInfoEvent extends BibleEvent {
  String bookAbbrev;

  LoadSelectionBookInfoEvent(this.bookAbbrev);
}

// Chapter Data

class LoadChapterDataEvent extends BibleEvent {
  String abbrev;
  int chapter;

  LoadChapterDataEvent(this.abbrev, this.chapter);
}

// Selection Chapter Data

class LoadSelectionChapterDataEvent extends BibleEvent {
  String abbrev;
  int chapter;

  LoadSelectionChapterDataEvent(this.abbrev, this.chapter);
}

// Search Data

class LoadSearchDataEvent extends BibleEvent {
  String search;

  LoadSearchDataEvent(this.search);
}

class LoadMoreSearchDataEvent extends BibleEvent {
  String search;
  bool forward;

  LoadMoreSearchDataEvent(this.search, this.forward);
}

class ClearSearchDataEvent extends BibleEvent {}

// Verse Range Data

class LoadVerseRangeDataEvent extends BibleEvent {
  String abbrev;
  int chapter;
  String verseRange;

  LoadVerseRangeDataEvent(this.abbrev, this.chapter, this.verseRange);
}
