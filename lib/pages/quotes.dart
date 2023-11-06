import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/controller/quote_controller.dart';
import 'package:bibre/data/bible_repository.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/add_quote_modal.dart';
import 'package:bibre/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Quotes extends StatefulWidget {
  const Quotes({super.key});

  @override
  State<Quotes> createState() => _QuotesState();
}

class _QuotesState extends State<Quotes> {
  final quoteController = Get.find<QuoteController>();

  @override
  Widget build(BuildContext context) {
    String displayText = "cytat";
    int number = quoteController.items.length;

    if (number == 0) {
      displayText += "ów";
    } else if (number == 1) {
      // No change
    } else if (number % 10 >= 2 &&
        number % 10 <= 4 &&
        (number % 100 < 10 || number % 100 >= 20)) {
      displayText += "y";
    } else {
      displayText += "ów";
    }

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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              addQuoteModal(context, true, "rdz", 1);
            },
          ),
        ],
      ),
      drawer: const BibreDrawer(title: Constants.bibleName),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Zapisane Cytaty",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${quoteController.items.length} $displayText",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: quoteController.items.length,
                    itemBuilder: (context, index) {
                      final item = quoteController.items[index];

                      final verseRangeBloc = VerseRangeBloc(BibleRepository());

                      return buildList(item, context, verseRangeBloc);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(
      QuoteItem item, BuildContext context, VerseRangeBloc verseRangeBloc) {
    verseRangeBloc.add(
        LoadVerseRangeDataEvent(item.abbrev, item.chapter, item.verseRange));

    String displayAbbrev = "";
    if (item.abbrev == "obj") {
      displayAbbrev = "Ap";
    } else {
      displayAbbrev = capitalize(item.abbrev);
    }

    return BlocBuilder<VerseRangeBloc, BibleState>(
      bloc: verseRangeBloc,
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
          return state.either.fold(
            (error) {
              return BibreErrorWidget(
                message: error,
              );
            },
            (verseRangeModel) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: Wrap(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${verseRangeModel.name} ${verseRangeModel.chapter}, ${verseRangeModel.versesRange}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  spacing: -10.0,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.indigo),
                                        iconColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.all(6.0),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size(30, 30),
                                        ),
                                      ),
                                      child: const Icon(Icons.copy, size: 18.0),
                                      onPressed: () {
                                        String quoteVerses =
                                            verseRangeModel.verses.map((verse) {
                                          return verse.text;
                                        }).join(" ");

                                        Clipboard.setData(
                                          ClipboardData(
                                            text:
                                                "\"$quoteVerses\" - $displayAbbrev ${item.chapter}, ${verseRangeModel.versesRange}",
                                          ),
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.red),
                                        iconColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        padding: MaterialStateProperty.all<
                                            EdgeInsetsGeometry>(
                                          const EdgeInsets.all(6.0),
                                        ),
                                        minimumSize:
                                            MaterialStateProperty.all<Size>(
                                          const Size(30, 30),
                                        ),
                                      ),
                                      child:
                                          const Icon(Icons.delete, size: 18.0),
                                      onPressed: () {
                                        showDialog<String>(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: const Text(
                                                "Czy napewno chcesz usunąć ten cytat?"),
                                            actions: [
                                              TextButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.red),
                                                  overlayColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.indigo
                                                              .withOpacity(
                                                                  0.4)),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, "TAK");

                                                  quoteController
                                                      .removeItem(item.id);
                                                  setState(() {});
                                                },
                                                child: const Text("TAK"),
                                              ),
                                              TextButton(
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(Colors.indigo),
                                                  overlayColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.indigo
                                                              .withOpacity(
                                                                  0.4)),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context, "NIE");
                                                },
                                                child: const Text("NIE"),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0, top: 4.0),
                          child: Wrap(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: verseRangeModel.verses.map((verse) {
                                    return TextSpan(children: [
                                      TextSpan(
                                        text: verse.text,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context)
                                              .secondaryHeaderColor,
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
                        ),
                      ],
                    ),
                  ),
                ),
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
}
