import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/bloc/bible_state.dart';
import 'package:bibre/model/bible_model.dart';
import 'package:bibre/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Book extends StatefulWidget {
  const Book({super.key});

  @override
  State<Book> createState() => _BookState();
}

class _BookState extends State<Book> {
  @override
  Widget build(BuildContext context) {
    final Map? data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null ||
        !data.containsKey("bookInfoModel") ||
        !data.containsKey("name")) {
      return const BibreErrorScreen(
        message: "Ładowanie informacji o Księdze nie powiodło się.",
      );
    }

    final bookInfoModel = data["bookInfoModel"] as BookInfoModel;

    context
        .read<BookInfoBloc>()
        .add(LoadBookInfoEvent(bookInfoModel.abbreviation));

    return Scaffold(
      appBar: AppBar(
        title: Text(data["name"] as String),
        centerTitle: true,
        backgroundColor: Colors.indigo[400],
      ),
      body: SafeArea(
        child: BlocBuilder<BookInfoBloc, BibleState>(
          builder: (context, state) {
            if (state is BookInfoInit) {
              return Container();
            } else if (state is BookInfoLoading) {
              return const Center(
                child: Constants.loadingSpinner,
              );
            } else if (state is BookInfoResponse) {
              return state.either.fold(
                (error) {
                  return BibreErrorWidget(
                    message: error,
                  );
                },
                (bookInfo) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                bookInfo.partName.toUpperCase(),
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
                              bookInfo.name,
                              style: const TextStyle(
                                fontSize: 26.0,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Text(
                                "Rozdziały",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6.0,
                            children: List.generate(
                              (bookInfo.hasZeroChapter
                                  ? bookInfo.chapters + 1
                                  : bookInfo.chapters),
                              (index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/chapter",
                                          arguments: {
                                            "name": data["name"],
                                            "abbrev": bookInfo.abbreviation,
                                            "chapter": (bookInfo.hasZeroChapter
                                                ? index
                                                : (index + 1)),
                                            "partName": bookInfo.partName,
                                            "maxChapters": bookInfo.chapters,
                                            "hasZeroChapter":
                                                bookInfo.hasZeroChapter,
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(14.0),
                                      backgroundColor: Colors.indigo[500],
                                    ),
                                    child: Text(
                                      (bookInfo.hasZeroChapter
                                          ? index.toString()
                                          : (index + 1).toString()),
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
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
      ),
    );
  }
}
