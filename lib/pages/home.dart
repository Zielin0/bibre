import 'package:bibre/model/bible_model.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Map? data = ModalRoute.of(context)?.settings.arguments as Map?;

    if (data == null || !data.containsKey("infoModel")) {
      return const BibreErrorScreen(
        message: "Ładowanie informacji o Biblii nie powiodło się.",
      );
    }

    final infoModel = data["infoModel"] as BibleInfoModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(infoModel.name),
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
      drawer: BibreDrawer(title: infoModel.name),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: infoModel.books.map((book) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SizedBox(
                    width: 275.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo[400]!),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/book", arguments: {
                          "bookInfoModel": book,
                          "name": infoModel.name,
                        });
                      },
                      child: Text(
                        "${book.name} (${book.displayAbbrev})",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
