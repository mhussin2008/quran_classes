// To parse this JSON data, do
//
//     final qaryData = qaryDataFromJson(jsonString);

import 'dart:convert';

List<QaryData> qaryDataFromJson(String str) => List<QaryData>.from(json.decode(str).map((x) => QaryData.fromJson(x)));

String qaryDataToJson(List<QaryData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QaryData {
  final String qaryName;
  final String qaryAge;
  //final double degree;
  final String testName;
  //final int questions;
  QaryData(this.qaryName, this.qaryAge, this.testName);

  factory QaryData.fromJson(Map<String, dynamic> json) => QaryData(json['qaryName'],json['qaryAge'],json['testName']);
  factory QaryData.fromFields(String name,String age,String tname)=>QaryData(name, age,tname);

  Map<String, dynamic> toJson() => {
  };

  @override
  String toString(){return 'Qary Name is ${qaryName} , his age is ${qaryAge} \n  ';}



 }

List<QaryData> QaryList=[];