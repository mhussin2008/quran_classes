import 'package:flutter/material.dart';
import 'package:quran_classes/Data/qaryData.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class QaryDataSource extends DataGridSource {
  QaryDataSource({required List<QaryData> qaryList}) {
    _qaryList = qaryList
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'name', value: e.qaryName
      ),
      DataGridCell<int>(
          columnName: 'age', value: e.qaryAge),
      // DataGridCell<double>(
      //     columnName: 'degree', value: e.degree),
      // DataGridCell<int>(
      //     columnName: 'questions', value: e.questions),

    ]))
        .toList().reversed.toList();
  }

  List<DataGridRow>  _qaryList = [];

  @override
  List<DataGridRow> get rows =>  _qaryList;



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