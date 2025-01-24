import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageViewerPage extends StatelessWidget {
  const LanguageViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, String> availableLanguages = {
      AppLocalizations.of(context)!.systemLanguage: 'default',
      AppLocalizations.of(context)!.english: 'en',
      AppLocalizations.of(context)!.german: 'de',
    };
    List<ListTile> languageTiles = [for (var language in availableLanguages.keys)
            ListTile(
              title: Text(language),
              leading: Icon(Icons.translate),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onTap: () {
              },
            ), ];

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
