// To parse this JSON data, do
//
//     final examData = examDataFromJson(jsonString);

import 'dart:convert';

ExamDetailData examDataFromJson(String str) => ExamDetailData.fromJson(json.decode(str));

String examDataToJson(ExamDetailData data) => json.encode(data.toJson());

class ExamDetailData {
  String qaryName;
  String testName;
  String qNumber;
  String desc;
  double degreeDec;

  ExamDetailData({
    required this.qaryName,
    required this.testName,
    required this.qNumber,
    required this.desc,
    required this.degreeDec,
  });




  factory ExamDetailData.fromJson(Map<String, dynamic> json) => ExamDetailData(
    qaryName: json["qaryName"],
    testName: json["testName"],
    qNumber: json["qNumber"],
    desc: json["desc"],
    degreeDec: json["degreeDec"]?.toDouble(),
  );

  factory ExamDetailData.fromFields(String name,String tname,String qnum,String desc,double degdec)
                 =>      ExamDetailData(qaryName: name, testName: tname, qNumber: qnum, desc: desc, degreeDec: degdec);


  Map<String, dynamic> toJson() => {
    "qaryName": qaryName,
    "testName": testName,
    "qNumber": qNumber,
    "desc": desc,
    "degreeDec": degreeDec,
  };
}
List<ExamDetailData>  ExamDetailDataList=[];