import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quran_classes/Screens/ChallengeEntryScreen.dart';

import 'package:sqflite/sqflite.dart';

import '../Screens/DegreeTableScreen.dart';
import '../ScreensUpdated/DialogScreen.dart';


class startUpScreen extends StatelessWidget {
  const startUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Container(
            padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/jpg/back.jpg' ),fit: BoxFit.cover
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(child: Text('Start Up Screen')),

              //SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () async {

                  String result= await showDialog(
                  context: context,
                  builder: (BuildContext context) => const DialogScreen());

                  print(result);
                  if(result=='OK'){
                  print('deleting');
                  await deleteDB();
                  }},
                  child: Text('مسح قاعدة البيانات')),
             // SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => challengeEntryScreen()));
                  },
                  child: Text('جدول المسابقات'))
              ,
              //SizedBox(height: 10),
              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => DegreeTable()));
                  },
                  child: Text('تعديل جدول خصم الدرجات'))
              // OutlinedButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (BuildContext context) => qaryDataEntry()));
              //     },
              //     child: Text('بيانات الطلاب'))
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
}}
