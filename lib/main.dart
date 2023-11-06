import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/controller/percent_controller.dart';
import 'package:bibre/controller/quote_controller.dart';
import 'package:bibre/data/bible_repository.dart';
import 'package:bibre/pages/book.dart';
import 'package:bibre/pages/chapter.dart';
import 'package:bibre/pages/home.dart';
import 'package:bibre/pages/loading.dart';
import 'package:bibre/provider/navigator_provider.dart';
import 'package:bibre/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<BibleInfoBloc>(
          create: (BuildContext context) => BibleInfoBloc(BibleRepository()),
        ),
        BlocProvider<BookInfoBloc>(
          create: (BuildContext context) => BookInfoBloc(BibleRepository()),
        ),
        BlocProvider<SelectionBookInfoBloc>(
          create: (BuildContext context) =>
              SelectionBookInfoBloc(BibleRepository()),
        ),
        BlocProvider<ChapterDataBloc>(
          create: (BuildContext context) => ChapterDataBloc(BibleRepository()),
        ),
        BlocProvider<SelectionChapterDataBloc>(
          create: (BuildContext context) =>
              SelectionChapterDataBloc(BibleRepository()),
        ),
        BlocProvider<SearchDataBloc>(
          create: (BuildContext context) => SearchDataBloc(BibleRepository()),
        ),
        BlocProvider<VerseRangeBloc>(
          create: (BuildContext context) => VerseRangeBloc(BibleRepository()),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<NavigatorProvider>(
              create: (context) => NavigatorProvider()),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()..setThemeFromLocal(),
          ),
        ],
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          Get.put(PercentController());
          Get.put(BibleInfoBloc(BibleRepository()));

          Get.put(QuoteController());

          Get.put(BibleRepository());

          return MaterialApp(
            title: "Bibre",
            initialRoute: "/",
            routes: {
              "/": (context) => const Loading(),
              "/home": (context) => const Home(),
              "/book": (context) => const Book(),
              /* "/chapter": (context) => const Chapter(), */
            },
            onGenerateRoute: (settings) {
              if (settings.name == "/chapter") {
                return PageRouteBuilder(
                  settings: settings,
                  pageBuilder: (_, __, ___) => const Chapter(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                );
              }

              return null;
            },
            themeMode: themeProvider.themeMode,
            theme: BibreTheme.lightTheme,
            darkTheme: BibreTheme.darkTheme,
          );
        },
      ),
    ),
  );
}
