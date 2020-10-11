import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'page/home.dart';
import 'model/ais_targets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AISTargets>(
          create: (_) => AISTargets(),
        ),
      ],
      child: MaterialApp(
        title: 'AIS UI',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}