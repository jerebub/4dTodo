import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todoPages/todo_view_page.dart';
import 'todo_element.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        title: '4D TODO',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: '4D TODO'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // write stuff in here needed for the general businesslogic of the app
  var todoList = <TodoElement>[];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = TodoViewerPage(title: widget.title);
      case 1:
        page = Placeholder();
      case 2:
        page = Placeholder();
      default:
        throw UnimplementedError('no widget for index $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 400) {
        return Column(
          children: [
            Expanded(child:page),
            SafeArea(
              child: BottomNavigationBar(
                showSelectedLabels: constraints.maxWidth > 300,
                showUnselectedLabels: constraints.maxWidth > 300,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: 'History',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ],
        );
      }
      var style = (constraints.maxWidth > 600)? Theme.of(context).textTheme.displaySmall: Theme.of(context).textTheme.titleMedium;
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 2.0, right: 2.0),
                  child: Text(widget.title, style: style),
                ),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                extended: constraints.maxWidth > 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.history), 
                    label: Text('History')),
                  NavigationRailDestination(
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
