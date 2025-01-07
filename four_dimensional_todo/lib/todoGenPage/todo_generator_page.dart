import 'package:flutter/material.dart';

class TodoGeneratorPage extends StatefulWidget {
  const TodoGeneratorPage({super.key, required this.title});

  final String title;

  @override
  State<TodoGeneratorPage> createState() => _TodoGeneratorPageState();
}

class _TodoGeneratorPageState extends State<TodoGeneratorPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button sooo many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
