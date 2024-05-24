import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import 'examDetailData.dart';

class ExamDetailDataSource extends DataGridSource {
  ExamDetailDataSource({required List<ExamDetailData> ExamDetailList}) {
    _testDetailList = ExamDetailList
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'qnumber', value: e.qNumber
      ),
      DataGridCell<String>(
          columnName: 'desc', value: e.desc),
      DataGridCell<double>(
          columnName: 'degreedec', value: e.degreeDec),


    ]))
        .toList().reversed.toList();
  }

  List<DataGridRow>  _testDetailList = [];

  @override
  List<DataGridRow> get rows =>  _testDetailList;



  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            //color: Colors.lightBlue,
            padding: const EdgeInsets.all(16.0),
            child: Text(
                textAlign: TextAlign.right,
                dataGridCell.value.toString()),
          );
        }).toList().reversed.toList());
  }
}