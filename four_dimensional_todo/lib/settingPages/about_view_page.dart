import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutViewerPage extends StatelessWidget {
  const AboutViewerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichText(
          text: TextSpan(
            text: '''This is a simple TODO app that I (Jeremias Bub) made using Flutter.\n\nIt is based on the idea of four-dimensional time-management and uses the four categories of the ''',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: 'Eisenhower Matrix',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse(
                          'https://en.wikipedia.org/wiki/Time_management#The_Eisenhower_Method'));
                    }),
              TextSpan(
                text: '''.\nThis app is an ongoing project and I will add more features in the future.\n\nYou can find the source code on GitHub: ''',
              ),
              TextSpan(
                  text: 'https://github.com/jerebub/4dTodo',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse('https://github.com/jerebub/4dTodo'));
                    }),
              TextSpan(text: '''\n\nThis app is using the '''),
              TextSpan(
                  text: 'unlicense license',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // open link to wikipedia
                      launchUrl(Uri.parse('https://unlicense.org'));
                    }),
              TextSpan(text: '''. Feel free to use the code for your own projects.
        '''),
            ],
          ),
        ),
      ),
    );
  }
}

final String aboutText = '''
This is a simple TODO app that I made using Flutter.
It is based on the idea of four-dimensional time-management and uses the four categories of the Eisenhower Matrix (https://en.wikipedia.org/wiki/Time_management#The_Eisenhower_Method).
This app is an ongoing project and I will add more features in the future.
You can find the source code on GitHub: https://github.com/jerebub/4dTodo

This app is using the unlicence license. Feel free to use the code for your own projects.
''';
