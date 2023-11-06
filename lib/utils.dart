import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Constants {
  static const String baseUrl = "https://biblia.info.pl/api";
  static const Widget loadingSpinner = SpinKitWave(
    color: Colors.indigo,
    size: 65.0,
  );
  static const String bibleName = "Biblia Tysiąclecia";
  static const String bibleDescription =
      "Biblia Tysiąclecia, wydanie IV Copyright (c) 1989 Wydawnictwo Pallottinum, Poznań. Wykorzystany w opracowaniu tekst IV wydania Biblii Tysiąclecia jest własnością Wydawnictwa Pallottinum w Poznaniu (ISBN 83-7014-218-4).";
}

class BibreErrorScreen extends StatelessWidget {
  final String message;

  const BibreErrorScreen({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Błąd!"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width - 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red[400],
                size: 84.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BibreErrorWidget extends StatelessWidget {
  final String message;

  const BibreErrorWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error,
            size: 100,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }

  int firstDigitIndex = input.indexOf(RegExp(r'\d'));
  if (firstDigitIndex >= 0) {
    String number = input.substring(0, firstDigitIndex + 1);
    String actualText = input.substring(firstDigitIndex + 1);

    return '$number ${actualText[0].toUpperCase()}${actualText.substring(1).toLowerCase()}';
  }

  return '${input[0].toUpperCase()}${input.substring(1).toLowerCase()}';
}
