import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:four_dimensional_todo/main.dart';
import 'package:provider/provider.dart';

class LanguageViewerPage extends StatelessWidget {
  LanguageViewerPage({super.key});

  final ftoast = FToast();

  @override
  Widget build(BuildContext context) {
    ftoast.init(context);
    var appState = context.read<MyAppState>();
    var prefs = appState.prefs;
    var selectedLanguage = prefs.getString('local') ?? 'default';
    Map<String, String> availableLanguages = {
      AppLocalizations.of(context)!.systemLanguage: 'default',
      AppLocalizations.of(context)!.english: 'en',
      AppLocalizations.of(context)!.german: 'de',
    };
    List<ListTile> languageTiles = [
      for (var language in availableLanguages.keys)
        ListTile(
          title: Text(language),
          leading: Icon(Icons.translate),
          trailing: selectedLanguage == availableLanguages[language]
              ? Icon(Icons.check)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: () {
            prefs.setString('local', availableLanguages[language]!);
            ftoast.showToast(
                child: Text(AppLocalizations.of(context)!.restartAppToast),
                gravity: ToastGravity.BOTTOM,
                toastDuration: Duration(seconds: 3));
          },
        ),
    ];

    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: languageTiles.length,
        itemBuilder: (context, index) {
          return languageTiles[index];
        },
      ),
    );
  }
}
