import 'package:flutter/material.dart';
import 'package:four_dimensional_todo/settingPages/about_view_page.dart';
import 'package:four_dimensional_todo/settingPages/packages_view_page.dart';

class SettingsViewerPage extends StatefulWidget {
  const SettingsViewerPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsViewerPage> createState() => _SettingsViewerPageState();
}

class _SettingsViewerPageState extends State<SettingsViewerPage> {
  var selectedIndex = 0;
  static const List<Widget> pages = [
    PackagesViewerPage(title: 'Packages'),
    Placeholder(), //LanguageViewerPage(title: 'Language'),
    AboutViewerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 400) {
        return Scaffold(
          body: ListView(
            children: [
              ListTile(
                title: Text('Settings',
                    softWrap: false,
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              ExpansionTile(
                title: Text(
                  'Licenses',
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
                  'Language',
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
                  'About',
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
                    title: Text('Settings',
                        softWrap: false,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  ListTile(
                    title: Text(
                      'Licenses',
                      softWrap: false,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Language',
                      softWrap: false,
                    ),
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  ListTile(
                    title: Text(
                      'About',
                      softWrap: false,
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
