import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutViewerPage extends StatelessWidget {
  const AboutViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: AppLocalizations.of(context)!.about1,
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context)!.eisenhowerMatrix,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse(
                          AppLocalizations.of(context)!.eisenhowerMatrixWiki));
                    }),
              TextSpan(
                text: AppLocalizations.of(context)!.about2,
              ),
              TextSpan(
                  text: 'https://github.com/jerebub/4dTodo',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse('https://github.com/jerebub/4dTodo'));
                    }),
              TextSpan(text: AppLocalizations.of(context)!.about3),
              TextSpan(
                  text: AppLocalizations.of(context)!.unlicenseLicense,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse('https://unlicense.org'));
                    }),
              TextSpan(text: AppLocalizations.of(context)!.about4),
            ],
          ),
        ),
      ),
    );
  }
}
