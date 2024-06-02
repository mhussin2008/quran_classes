import 'dart:io';
import 'package:flutter/material.dart';
import 'package:quran_classes/ScreensUpdated/ExamEntryScreenUpdated.dart';
import 'package:sqflite/sqflite.dart';
import '../ScreensUpdated/DegreeTableScreenUpdated.dart';
import 'DialogScreen.dart';

class startUpScreenUpdated extends StatelessWidget {
  const startUpScreenUpdated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Center(child: Text('Start Up Screen')),

              OutlinedButton(
                onPressed: () async {
                  String result = await showDialog(
                      context: context,
                      builder: (BuildContext context) => const DialogScreen());

                  print(result);
                  if (result == 'OK') {
                    print('deleting');
                    await deleteDB();
                  }
                },
                child:
                    const Text('مسح قاعدة البيانات', style: TextStyle(fontSize: 24)),
              ),
              // SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const ExamEntryScreenUpdated()));
                  },
                  child: const Text('جدول الحلقات', style: TextStyle(fontSize: 24))),
              //SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DegreeTableScreenUpdated()));
                  },
                  child: const Text('تعديل جدول خصم الدرجات',
                      style: TextStyle(fontSize: 24)))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteDB() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == true) {
      print('found and deleted database');
      await deleteDatabase(dbFilePath);
    }
  }
}
