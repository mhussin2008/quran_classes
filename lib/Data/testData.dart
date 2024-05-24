// To parse this JSON data, do
//
//     final qaryData = qaryDataFromJson(jsonString);

import 'dart:convert';

List<TestData> qaryDataFromJson(String str) => List<TestData>.from(json.decode(str).map((x) => TestData.fromJson(x)));

String qaryDataToJson(List<TestData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TestData {
  final String testName;
  final String testDate;
  TestData(this.testName, this.testDate);

  factory TestData.fromJson(Map<String, dynamic> json) => TestData(json['qaryName'],json['qaryAge']);
  factory TestData.fromFields(String name,String tdate)=>TestData(name, tdate);

  Map<String, dynamic> toJson() => {
  };

  @override
  String toString(){return 'Test Name is ${testName} and its date is ${testDate}';}



 }

List<TestData> TestList=[];