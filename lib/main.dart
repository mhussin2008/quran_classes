import 'package:flutter/material.dart';
import 'package:quran_classes/Data/DegreeData.dart';

import 'ScreensUpdated/StartUpScreenUpdated.dart';

Future<void> main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();
  await DegreeData.getDegreeData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const startUpScreen(),
    );
  }
}

