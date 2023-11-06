import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/controller/percent_controller.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/navigation_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Percent extends StatefulWidget {
  const Percent({super.key});

  @override
  State<Percent> createState() => _PercentState();
}

class _PercentState extends State<Percent> {
  final percentController = Get.find<PercentController>();
  final bibleInfoBloc = Get.find<BibleInfoBloc>();

  @override
  void initState() {
    percentController.loadAndStoreData(percentController, bibleInfoBloc);

    super.initState();
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
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0, bottom: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Procent przeczytania Biblii",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "${((percentController.getCheckedAmount() * 100) / percentController.items.length).toStringAsFixed(3)}% (${percentController.getCheckedAmount()} z ${percentController.items.length})",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: percentController.items.length,
                  itemBuilder: (context, index) {
                    final item = percentController.items[index];

                    return buildList(item);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildList(PercentItem item) {
    return ListTile(
      leading: Checkbox(
        activeColor: Colors.indigo,
        value: item.isChecked,
        onChanged: (bool? value) {
          setState(() {
            percentController.removeItems();
            item.isChecked = value!;
            percentController.saveItems();
          });
        },
        side: const BorderSide(color: Colors.grey, width: 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      title: Text(
        "${item.name} (${item.displayAbbreviation})",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: item.isChecked
              ? Colors.grey
              : Theme.of(context).secondaryHeaderColor,
          decoration: item.isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
      horizontalTitleGap: -5,
    );
  }
}
