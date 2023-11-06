import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:holding_gesture/holding_gesture.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var controller = TextEditingController();
  var focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constants.bibleName),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      drawer: const BibreDrawer(title: Constants.bibleName),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 8.0,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              focusNode: focusNode,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Szukaj w Biblii",
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                labelStyle: const TextStyle(color: Colors.red),
                              ),
                              cursorColor: Colors.white,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: Colors.indigo[700],
                              ),
                              onPressed: () {
                                if (controller.text.isNotEmpty) {
                                  focusNode.unfocus();

                                  BlocProvider.of<SearchDataBloc>(context)
                                      .add(ClearSearchDataEvent());
                                  BlocProvider.of<SearchDataBloc>(context).add(
                                      LoadSearchDataEvent(controller.text));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: BlocBuilder<SearchDataBloc, BibleState>(
                    builder: (context, state) {
                      if (state is SearchDataInit) {
                        return Container();
                      } else if (state is SearchDataLoading) {
                        return const Center(
                          child: Constants.loadingSpinner,
                        );
                      } else if (state is SearchDataResponse) {
                        return state.either.fold((error) {
                          return BibreErrorWidget(
                            message: error,
                          );
                        }, (search) {
                          if (search.resultsRange != "0") {
                            final currentPage =
                                context.read<SearchDataBloc>().currentPage;
                            int totalPages = (search.allResults / 25).ceil() +
                                (search.allResults % 25 == 0 ? 1 : 0);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: HtmlWidget(
                                    "Znaleziono <b>${search.allResults.toString()}</b> wyników. Strona <b>$currentPage/$totalPages</b>",
                                    textStyle: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    children: search.results
                                        .expand(
                                          (result) => result.verses.map(
                                            (verse) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                ),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.95,
                                                  child: SearchResultWidget(
                                                    verseText: verse.text,
                                                    bookName: result.bookName ==
                                                            "Apokalipsa (Objawienie)"
                                                        ? "Apokalipsa"
                                                        : result.bookName,
                                                    abbrev: result.bookAbbrev ==
                                                            "obj"
                                                        ? "Ap"
                                                        : capitalize(
                                                            result.bookAbbrev),
                                                    chapter: result.chapter
                                                        .toString(),
                                                    versesRange:
                                                        result.versesRange,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: currentPage == 1
                                            ? null
                                            : () {
                                                BlocProvider.of<SearchDataBloc>(
                                                        context)
                                                    .add(
                                                        LoadMoreSearchDataEvent(
                                                            search.query,
                                                            false));
                                              },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.indigo[500],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: currentPage == totalPages
                                            ? null
                                            : () {
                                                BlocProvider.of<SearchDataBloc>(
                                                        context)
                                                    .add(
                                                        LoadMoreSearchDataEvent(
                                                            search.query,
                                                            true));
                                              },
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          backgroundColor: Colors.indigo[500],
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const BibreErrorWidget(
                              message: "Nie znaleziono wyników",
                            );
                          }
                        });
                      }

                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResultWidget extends StatelessWidget {
  final String verseText;
  final String bookName;
  final String abbrev;
  final String chapter;
  final String versesRange;

  const SearchResultWidget({
    super.key,
    required this.verseText,
    required this.bookName,
    required this.abbrev,
    required this.chapter,
    required this.versesRange,
  });

  @override
  Widget build(BuildContext context) {
    return HoldDetector(
      onHold: () {
        String verseTextToCopy = verseText
            .replaceFirst("<strong>", "")
            .replaceFirst("</strong>", "");

        Clipboard.setData(
          ClipboardData(
            text: "\"$verseTextToCopy\" - $abbrev $chapter, $versesRange",
          ),
        );
      },
      holdTimeout: const Duration(milliseconds: 300),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HtmlWidget(
                verseText,
                textStyle: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                    ),
                    child: Text(
                      "- $bookName $chapter, $versesRange",
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
