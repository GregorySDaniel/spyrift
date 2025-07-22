import 'package:desktop/app_route.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/repository/mock_repository.dart';
import 'package:desktop/repository/repository.dart';
import 'package:desktop/services/database_interface.dart';
import 'package:desktop/services/sqflite.dart';
import 'package:desktop/theme.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

bool useMock = false;

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late BaseRepository repo;
  late DatabaseInterface db;

  @override
  void initState() {
    super.initState();

    db = Sqflite();
    repo = useMock ? MockRepository() : Repository(db: db);
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightness = View.of(
      context,
    ).platformDispatcher.platformBrightness;

    final TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    final MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<BaseRepository>.value(value: repo),
        Provider<DatabaseInterface>.value(value: db),
      ],
      child: MaterialApp.router(
        routerConfig: router(),
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      ),
    );
  }
}
