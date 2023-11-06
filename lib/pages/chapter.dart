import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/add_quote_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Chapter extends StatefulWidget {
  const Chapter({super.key});

  @override
  State<Chapter> createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  @override
  Widget build(BuildContext context) {
    final Map? data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null ||
        !data.containsKey("name") ||
        !data.containsKey("abbrev") ||
        !data.containsKey("chapter") ||
        !data.containsKey("partName") ||
        !data.containsKey("maxChapters") ||
        !data.containsKey("hasZeroChapter")) {
      return const BibreErrorScreen(
        message: "Ładowanie informacji o Rozdziale nie powiodło się.",
      );
    }

    context.read<ChapterDataBloc>().add(LoadChapterDataEvent(
          data["abbrev"] as String,
          data["chapter"] as int,
        ));

    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"] as String),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
      ),
      body: SafeArea(
        child: BlocBuilder<ChapterDataBloc, BibleState>(
          builder: (context, state) {
            if (state is ChapterDataInit) {
              return Container();
            } else if (state is ChapterDataLoading) {
              return const Center(
                child: Constants.loadingSpinner,
              );
            } else if (state is ChapterDataResponse) {
              return state.either.fold((error) {
                return BibreErrorWidget(
                  message: error,
                );
              }, (chapterModel) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              (data["partName"] as String).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            chapterModel.name,
                            style: const TextStyle(
                              fontSize: 26.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              "Rozdział ${chapterModel.chapter.toString()}",
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 22.0, 8.0, 12.0),
                        child: SelectableText.rich(
                          TextSpan(
                            children: chapterModel.verses.map((verse) {
                              return TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${verse.verse} ",
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: verse.text,
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: (chapterModel.abbrev == "ps"
                                        ? '\n'
                                        : ' '),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
            }

            return const Center(
              child: Text("should not be seen"),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.indigo[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.home),
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.format_quote),
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  onPressed: () {
                    addQuoteModal(
                        context, false, data["abbrev"], data["chapter"]);
                  },
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  onPressed: (((data["chapter"] as int) == 1 &&
                              !(data["hasZeroChapter"] as bool)) ||
                          ((data["chapter"] as int) == 0 &&
                              (data["hasZeroChapter"] as bool))
                      ? null
                      : () {
                          Navigator.pushReplacementNamed(
                            context,
                            "/chapter",
                            arguments: {
                              "name": data["name"],
                              "abbrev": data["abbrev"],
                              "chapter": (data["chapter"] as int) - 1,
                              "partName": data["partName"],
                              "maxChapters": data["maxChapters"],
                              "hasZeroChapter": data["hasZeroChapter"],
                            },
                          );
                        }),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.white,
                  disabledColor: Colors.grey,
                  onPressed:
                      ((data["chapter"] as int) == (data["maxChapters"] as int)
                          ? null
                          : () {
                              Navigator.pushReplacementNamed(
                                context,
                                "/chapter",
                                arguments: {
                                  "name": data["name"],
                                  "abbrev": data["abbrev"],
                                  "chapter": (data["chapter"] as int) + 1,
                                  "partName": data["partName"],
                                  "maxChapters": data["maxChapters"],
                                  "hasZeroChapter": data["hasZeroChapter"],
                                },
                              );
                            }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
