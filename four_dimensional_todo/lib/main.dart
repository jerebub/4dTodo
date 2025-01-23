import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:four_dimensional_todo/archivePages/archive_view_page.dart';
import 'package:four_dimensional_todo/settingPages/setting_view_page.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'todoPages/todo_view_page.dart';
import 'todo_element.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      openDatabase(join(await getDatabasesPath(), 'todo_database.db'),
          onCreate: (db, version) {
    return db.execute(
      'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, done INTEGER, archived INTEGER, creationDate TEXT, dueDate TEXT, eisenhowerMatrixCategory TEXT)',
    );
  }, version: 1);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MyAppState(),
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateTitle:(context) => AppLocalizations.of(context)!.appTitle,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: Builder(
          builder: (context) {
            return MyHomePage(title: AppLocalizations.of(context)!.appTitle);
          }
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  // write stuff in here needed for the general businesslogic of the app
  var todoList = <TodoElement>[];
  var archivedTodoList = <TodoElement>[];

  TodoElement getTodoElementFromMap(Map map) {
    return TodoElement(
      id: map['id'] ?? -1,
      title: map['title'],
      description: map['description'] != null && map['description'] != ''
          ? map['description']
          : null,
      done: map['done'] == 1,
      archived: map['archived'] == 1,
      creationDate: DateTime.parse(map['creationDate']),
      dueDate: map['dueDate'] != null && map['dueDate'] != ''
          ? DateTime.parse(map['dueDate'])
          : null,
      eisenhowerMatrixCategory:
          TodoElement.stringToCategory(map['eisenhowerMatrixCategory']),
    );
  }

  Future<void> getUnarchivedTodoElementsFromDB() async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'todo_database.db'));
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos WHERE archived = 0');
    todoList = List.generate(maps.length, (i) {
      return getTodoElementFromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> getArchivedTodoElementsFromDB() async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'todo_database.db'));
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('todos WHERE archived = 1');
    archivedTodoList = List.generate(maps.length, (i) {
      return getTodoElementFromMap(maps[i]);
    });
    notifyListeners();
  }

  Future<void> addTodoElement(TodoElement todoElement) async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'todo_database.db'));
    final db = await database;
    var id = await db.insert('todos', todoElement.toMap());
    todoElement.setID(id);
    todoList.add(todoElement);
    notifyListeners();
  }

  Future<void> updateTodoElement({required TodoElement todoElement}) async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'todo_database.db'));
    final db = await database;
    await db.update(
      'todos',
      todoElement.toMap(),
      where: 'id = ?',
      whereArgs: [todoElement.id],
    );
    notifyListeners();
  }

  Future<void> deleteTodoElement(TodoElement todoElement) async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'todo_database.db'));
    final db = await database;
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [todoElement.id],
    );
    todoList.remove(todoElement);
    notifyListeners();
  }
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
        page = TodoViewerPage();
      case 1:
        page = ArchiveViewerPage();
      case 2:
        page = SettingsViewerPage();
      default:
        throw UnimplementedError(AppLocalizations.of(context)!.noWidgetForIndex(selectedIndex));
    }
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 400) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(child: page),
              BottomNavigationBar(
                showSelectedLabels: constraints.maxWidth > 300,
                showUnselectedLabels: constraints.maxWidth > 300,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: AppLocalizations.of(context)!.home,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.history),
                    label: AppLocalizations.of(context)!.archiveNoun,
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: AppLocalizations.of(context)!.settings,
                  ),
                ],
                currentIndex: selectedIndex,
                onTap: (int index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
        );
      }
      var style = (constraints.maxWidth > 600)
          ? Theme.of(context).textTheme.displaySmall
          : Theme.of(context).textTheme.titleMedium;
      return Scaffold(
        body: Row(
          children: [
            SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: NavigationRail(
                    leading: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, left: 2.0, right: 2.0),
                      child: Text(widget.title, style: style),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    extended: constraints.maxWidth > 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text(AppLocalizations.of(context)!.home),
                      ),
                      NavigationRailDestination(
                          icon: Icon(Icons.history), label: Text(AppLocalizations.of(context)!.archiveNoun)),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text(AppLocalizations.of(context)!.settings),
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
