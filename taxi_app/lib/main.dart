import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxi_app/states/map_provider.dart';
import 'package:taxi_app/utils/constants.dart';

import 'screens/home_page.dart';

void main() {
  return runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(
        value: MapProvider(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: app_name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: app_name),
    );
  }
}
