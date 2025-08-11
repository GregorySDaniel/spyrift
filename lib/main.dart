import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:spyrift/app_route.dart';
import 'package:spyrift/repository/db_base_repository.dart';
import 'package:spyrift/repository/db_mock_repository.dart';
import 'package:spyrift/repository/db_repository.dart';
import 'package:spyrift/services/database_interface.dart';
import 'package:spyrift/services/sqflite.dart';
import 'package:spyrift/theme.dart';
import 'package:spyrift/util.dart';
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
  late DbBaseRepository repo;
  late DatabaseInterface db;

  @override
  void initState() {
    super.initState();

    db = Sqflite();
    repo = useMock ? DbMockRepository() : DbRepository(db: db);
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
        Provider<DbBaseRepository>.value(value: repo),
        Provider<DatabaseInterface>.value(value: db),
      ],
      child: MaterialApp.router(
        routerConfig: router(),
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      ),
    );
  }
}
