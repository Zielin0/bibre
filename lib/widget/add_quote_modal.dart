import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/controller/quote_controller.dart';
import 'package:bibre/model/bible_model.dart';
import 'package:bibre/pages/quotes.dart';
import 'package:bibre/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

void addQuoteModal(BuildContext context, bool isScreenQuotes,
    String defaultAbbrev, int defaultChapter) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AddQuoteModal(
        isScreenQuotes: isScreenQuotes,
        defaultBookAbbrev: defaultAbbrev,
        defaultChapter: defaultChapter,
      );
    },
  );
}

class AddQuoteModal extends StatefulWidget {
  final bool isScreenQuotes;

  final String defaultBookAbbrev;
  final int defaultChapter;

  const AddQuoteModal({
    super.key,
    required this.isScreenQuotes,
    required this.defaultBookAbbrev,
    required this.defaultChapter,
  });

  @override
  State<AddQuoteModal> createState() => _AddQuoteModalState();
}

class _AddQuoteModalState extends State<AddQuoteModal> {
  String bookDropdownValue = "";
  String chapterDropdownValue = "";
  String startVerseValue = "";
  String endVerseValue = "";

  final quoteController = Get.find<QuoteController>();

  @override
  void initState() {
    super.initState();

    context.read<BibleInfoBloc>().add(LoadBibleInfoEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BibleInfoBloc, BibleState>(
      builder: (context, state) {
        if (state is BibleInfoInit) {
          return Container();
        } else if (state is BibleInfoLoading) {
          return const Wrap(
            children: [
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Center(
                  child: Constants.loadingSpinner,
                ),
              ),
            ],
          );
        } else if (state is BibleInfoResponse) {
          return state.either.fold(
            (error) {
              return BibreErrorWidget(message: error);
            },
            (bibleInfoModel) {
              if (bookDropdownValue.isEmpty) {
                bookDropdownValue = widget.defaultBookAbbrev;

                context
                    .read<SelectionBookInfoBloc>()
                    .add(LoadSelectionBookInfoEvent(bookDropdownValue));
              }

              return Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Księga",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownMenu(
                              menuHeight:
                                  MediaQuery.of(context).size.height * 0.60,
                              width: MediaQuery.of(context).size.width * 0.45,
                              initialSelection: widget.defaultBookAbbrev,
                              onSelected: (String? value) {
                                setState(() {
                                  bookDropdownValue = value!;

                                  context.read<SelectionBookInfoBloc>().add(
                                      LoadSelectionBookInfoEvent(
                                          bookDropdownValue));

                                  if (bookDropdownValue.isNotEmpty) {
                                    context
                                        .read<SelectionChapterDataBloc>()
                                        .add(LoadSelectionChapterDataEvent(
                                            bookDropdownValue,
                                            int.parse(chapterDropdownValue)));
                                  }
                                });
                              },
                              dropdownMenuEntries: bibleInfoModel.books
                                  .map<DropdownMenuEntry<String>>(
                                      (BookInfoModel value) {
                                return DropdownMenuEntry<String>(
                                    value: value.abbreviation,
                                    label: value.displayAbbrev);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      BlocBuilder<SelectionBookInfoBloc, BibleState>(
                        builder: (context, state) {
                          if (state is SelectionBookInfoInit) {
                            return Container();
                          } else if (state is SelectionBookInfoLoading) {
                            return const Wrap(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Center(
                                    child: Constants.loadingSpinner,
                                  ),
                                ),
                              ],
                            );
                          } else if (state is SelectionBookInfoResponse) {
                            return state.either.fold(
                              (error) {
                                return BibreErrorWidget(message: error);
                              },
                              (bookInfoModel) {
                                List<String> allChapters = List.generate(
                                  bookInfoModel.hasZeroChapter
                                      ? bookInfoModel.chapters + 1
                                      : bookInfoModel.chapters,
                                  (index) => (bookInfoModel.hasZeroChapter
                                          ? index
                                          : index + 1)
                                      .toString(),
                                );

                                if (chapterDropdownValue.isEmpty) {
                                  chapterDropdownValue =
                                      widget.defaultChapter.toString();

                                  context.read<SelectionChapterDataBloc>().add(
                                      LoadSelectionChapterDataEvent(
                                          bookDropdownValue,
                                          int.parse(chapterDropdownValue)));
                                }

                                return Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          "Rozdział",
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenu(
                                        menuHeight:
                                            MediaQuery.of(context).size.height *
                                                0.60,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.45,
                                        initialSelection:
                                            widget.defaultChapter.toString(),
                                        onSelected: (String? value) {
                                          setState(() {
                                            chapterDropdownValue = value!;

                                            context
                                                .read<
                                                    SelectionChapterDataBloc>()
                                                .add(LoadSelectionChapterDataEvent(
                                                    bookDropdownValue,
                                                    int.parse(
                                                        chapterDropdownValue)));
                                          });
                                        },
                                        dropdownMenuEntries: allChapters
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                          return DropdownMenuEntry<String>(
                                              value: value, label: value);
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }

                          return const Center(
                            child: Text("should not be seen"),
                          );
                        },
                      ),
                    ],
                  ),
                  BlocBuilder<SelectionChapterDataBloc, BibleState>(
                    builder: (context, state) {
                      if (state is SelectionChapterDataInit) {
                        return Container();
                      } else if (state is SelectionChapterDataLoading) {
                        return const Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                child: Constants.loadingSpinner,
                              ),
                            ),
                          ],
                        );
                      } else if (state is SelectionChapterDataResponse) {
                        return state.either.fold(
                          (error) {
                            return BibreErrorWidget(message: error);
                          },
                          (chapterDataModel) {
                            int versesInChapter = int.parse(
                                chapterDataModel.versesRange.split("-")[1]);

                            List<String> allVerses = List.generate(
                                versesInChapter,
                                (index) => (index + 1).toString());

                            if (startVerseValue.isEmpty) {
                              startVerseValue = allVerses.first;
                            }

                            if (endVerseValue.isEmpty) {
                              endVerseValue = allVerses.first;
                            }

                            return Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    "Zakres Wersów",
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      DropdownMenu(
                                        menuHeight:
                                            MediaQuery.of(context).size.height *
                                                0.50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        initialSelection: allVerses.first,
                                        onSelected: (String? value) {
                                          setState(() {
                                            startVerseValue = value!;
                                          });
                                        },
                                        dropdownMenuEntries: allVerses
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                          return DropdownMenuEntry<String>(
                                              value: value, label: value);
                                        }).toList(),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15.0),
                                        child: Text(
                                          "-",
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenu(
                                        menuHeight:
                                            MediaQuery.of(context).size.height *
                                                0.50,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        initialSelection: allVerses.first,
                                        onSelected: (String? value) {
                                          setState(() {
                                            endVerseValue = value!;
                                          });
                                        },
                                        dropdownMenuEntries: allVerses
                                            .map<DropdownMenuEntry<String>>(
                                                (String value) {
                                          return DropdownMenuEntry<String>(
                                              value: value, label: value);
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }

                      return const Center(
                        child: Text("should not be seen"),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                          ),
                          onPressed: () {
                            showConfirmationAlert(
                              bookDropdownValue,
                              chapterDropdownValue,
                              startVerseValue,
                              endVerseValue,
                              context,
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Dodaj Cytat",
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }

        return const Center(
          child: Text("should not be seen"),
        );
      },
    );
  }

  late BibleState bibleState;
  void showConfirmationAlert(String abbrev, String chapter, String startVerse,
      String endVerse, BuildContext context) {
    String verseRange = "$startVerse-$endVerse";

    context
        .read<VerseRangeBloc>()
        .add(LoadVerseRangeDataEvent(abbrev, int.parse(chapter), verseRange));

    String displayAbbrev = "";
    if (abbrev == "obj") {
      displayAbbrev = "Ap";
    } else {
      displayAbbrev = capitalize(abbrev);
    }

    bool disableAddButton = int.parse(startVerse) > int.parse(endVerse);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("$displayAbbrev $chapter, $verseRange"),
        content: BlocBuilder<VerseRangeBloc, BibleState>(
          builder: (context, state) {
            if (state is VerseRangeDataInit) {
              return Container();
            } else if (state is VerseRangeDataLoading) {
              return const Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Center(
                      child: Constants.loadingSpinner,
                    ),
                  ),
                ],
              );
            } else if (state is VerseRangeDataResponse) {
              bibleState = state;
              return state.either.fold(
                (error) {
                  return Wrap(
                    children: [
                      BibreErrorWidget(message: error),
                    ],
                  );
                },
                (verseRangeModel) {
                  return SingleChildScrollView(
                    child: Wrap(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: verseRangeModel.verses.map((verse) {
                              return TextSpan(children: [
                                TextSpan(
                                  text: "${verse.verse} ",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                TextSpan(
                                  text: verse.text,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                TextSpan(
                                  text: (verseRangeModel.abbrev == "ps"
                                      ? '\n'
                                      : ' '),
                                ),
                              ]);
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }

            return const Center(
              child: Text("should not be seen"),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.red.withOpacity(0.4)),
            ),
            onPressed: () {
              Navigator.pop(context, "ANULUJ");
            },
            child: const Text("ANULUJ"),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  disableAddButton ? Colors.grey : Colors.indigo),
              overlayColor: MaterialStateProperty.all<Color>(
                  Colors.indigo.withOpacity(0.4)),
            ),
            onPressed: disableAddButton
                ? null
                : () {
                    quoteController.addItem(QuoteItem(
                      id: 0,
                      abbrev: abbrev,
                      chapter: int.parse(chapter),
                      verseRange: verseRange,
                    ));
                    Navigator.pop(context, "DODAJ");

                    if (widget.isScreenQuotes) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const Quotes(),
                        ),
                      );
                    }
                  },
            child: const Text("DODAJ"),
          ),
        ],
      ),
    );
  }
}
