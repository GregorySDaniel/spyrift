import 'package:desktop/app_route.dart';
import 'package:desktop/repository/base_repository.dart';
import 'package:desktop/repository/mock_repository.dart';
import 'package:desktop/theme.dart';
import 'package:desktop/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late BaseRepository repo;

  @override
  void initState() {
    super.initState();

    repo = MockRepository();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Poppins", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<BaseRepository>.value(value: repo),
      ],
      child: MaterialApp.router(
        routerConfig: router(),
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      ),
    );
  }
}
