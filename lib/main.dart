import 'package:flutter/material.dart';
import 'package:learn_project/pages/home_pages.dart';

import 'helper/sqflite_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await DoctorHelper.dbHelper.initDatabase();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
