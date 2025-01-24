import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/settingPages/about_view_page.dart';
import 'package:four_dimensional_todo/settingPages/language_viewer_page.dart';
import 'package:four_dimensional_todo/settingPages/packages_view_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsViewerPage extends StatefulWidget {
  const SettingsViewerPage({super.key,});


  @override
  State<SettingsViewerPage> createState() => _SettingsViewerPageState();
}

class _SettingsViewerPageState extends State<SettingsViewerPage> {
  var selectedIndex = 0;
  static const List<Widget> pages = [
    PackagesViewerPage(),
    LanguageViewerPage(), //LanguageViewerPage(title: 'Language'),
    AboutViewerPage(),
  ];
  

  @override
  Widget build(BuildContext context) {
    TextStyle selectedStyle = TextStyle(
    color: Colors.black,
    shadows: [
      Shadow(
        color: Theme.of(context).colorScheme.primary,
        offset: Offset(0, 0),
        blurRadius: 5,
      ),
    ],
  );
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 400) {
        return Scaffold(
          body: ListView(
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.settings,
                    softWrap: false,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ExpansionTile(
                title: Text(
                  AppLocalizations.of(context)!.licenses,
                  softWrap: false,
                ),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                    child: pages[0],
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  AppLocalizations.of(context)!.languages,
                  softWrap: false,
                ),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                    child: pages[1],
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(
                  AppLocalizations.of(context)!.about,
                  softWrap: false,
                ),
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: constraints.maxHeight,
                      maxWidth: constraints.maxWidth,
                    ),
                    child: pages[2],
                  ),
                ],
              ),
            ],
          ),
        );
      }
      return Scaffold(
        body: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth * 2.65 / 4),
              child: pages[selectedIndex],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth * 1.35 / 4),
              child: ListView(
                children: [
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.settings,
                        softWrap: false,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.licenses,
                      softWrap: false,
                      style: selectedIndex == 0 ? selectedStyle : null,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.languages,
                      softWrap: false,
                      style: selectedIndex == 1 ? selectedStyle : null,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.about,
                      softWrap: false,
                      style: selectedIndex == 2 ? selectedStyle : null,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
