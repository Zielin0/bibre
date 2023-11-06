import 'package:bibre/bloc/bible_bloc.dart';
import 'package:bibre/bloc/bible_event.dart';
import 'package:bibre/pages/loading.dart';
import 'package:bibre/pages/percent.dart';
import 'package:bibre/pages/quotes.dart';
import 'package:bibre/pages/search.dart';
import 'package:bibre/provider/navigator_provider.dart';
import 'package:bibre/utils.dart';
import 'package:bibre/widget/switch_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BibreDrawer extends StatelessWidget {
  final String title;

  const BibreDrawer({
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.indigo[400],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 20.0,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                ),
              ),
              buildItems(context),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.light_mode_outlined),
                    ThemeSwitcher(),
                    Icon(Icons.dark_mode_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItems(BuildContext context) => Consumer<NavigatorProvider>(
        builder: (context, status, _) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
          ),
          child: Wrap(
            children: [
              buildItem(
                icon: Icons.home,
                title: "Strona Główna",
                status: status.newStatus,
                itemStatus: "home",
                context: context,
              ),
              buildItem(
                icon: Icons.search,
                title: "Szukaj w Biblii",
                status: status.newStatus,
                itemStatus: "search",
                context: context,
              ),
              buildItem(
                icon: Icons.percent,
                title: "Procent Przeczytania",
                status: status.newStatus,
                itemStatus: "percent",
                context: context,
              ),
              buildItem(
                icon: Icons.format_quote,
                title: "Zapisane Cytaty",
                status: status.newStatus,
                itemStatus: "quotes",
                context: context,
              ),
              buildItem(
                icon: Icons.info,
                title: "Informacje",
                status: status.newStatus,
                itemStatus: "info",
                context: context,
              ),
            ],
          ),
        ),
      );

  Widget buildItem({
    required IconData icon,
    required String title,
    required String status,
    required String itemStatus,
    required BuildContext context,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      horizontalTitleGap: -3,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      tileColor: status == itemStatus ? Colors.indigo[400] : null,
      textColor: status == itemStatus ? Colors.white : null,
      iconColor: status == itemStatus ? Colors.white : null,
      onTap: () {
        Provider.of<NavigatorProvider>(context, listen: false)
            .changeStatus(itemStatus);

        Widget routeTo = const Loading();

        String appName = "";
        String version = "";
        String buildNumber = "";

        BuildContext routeContext = context;

        PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
          appName = packageInfo.appName;
          version = packageInfo.version;
          buildNumber = packageInfo.buildNumber;
        }).whenComplete(() {
          switch (itemStatus) {
            case "home":
              routeTo = const Loading();
              break;
            case "search":
              routeTo = const Search();
              break;
            case "percent":
              routeTo = const Percent();
              break;
            case "quotes":
              routeTo = const Quotes();
              break;
            case "info":
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("Bibre - Informacje"),
                  content: Wrap(
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              "Informacje o Biblii",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(Constants.bibleDescription),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Text(
                              "Wersja Aplikacji",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text("$appName $version ($buildNumber)"),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                            child: Text(
                              "Kod źródłowy",
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _launchUrl,
                            child: Text(
                              "github.com/Zielin0/bibre",
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.indigo),
                        overlayColor: MaterialStateProperty.all<Color>(
                            Colors.indigo.withOpacity(0.4)),
                      ),
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context, "OK");
                        itemStatus =
                            ModalRoute.of(routeContext)!.settings.name ==
                                    "/home"
                                ? "home"
                                : ModalRoute.of(routeContext)!.settings.name!;

                        Provider.of<NavigatorProvider>(context, listen: false)
                            .changeStatus(itemStatus);
                      },
                    ),
                  ],
                ),
              );
              break;
            default:
              routeTo = const Loading();
              break;
          }

          if (itemStatus != "info") {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                settings: RouteSettings(
                  name: itemStatus,
                ),
                builder: (BuildContext context) {
                  clearSearchBloc(context);

                  return routeTo;
                },
              ),
              (Route<dynamic> route) => false,
            );
          }
        });
      },
    );
  }

  void clearSearchBloc(BuildContext context) {
    BlocProvider.of<SearchDataBloc>(context).add(ClearSearchDataEvent());
  }
}

_launchUrl() async {
  final Uri url = Uri.parse("https://github.com/Zielin0/bibre");
  if (await canLaunchUrl(url)) {
    launchUrl(url);
  } else {}
}
