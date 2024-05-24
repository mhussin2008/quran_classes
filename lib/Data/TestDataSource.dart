import 'package:flutter/material.dart';
import 'package:quran_classes/Data/testData.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class TestDataSource extends DataGridSource {
  TestDataSource({required List<TestData> testList}) {
    _testList = testList
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(

          columnName: 'name', value: e.testName
      ),
      DataGridCell<String>(
          columnName: 'date', value: e.testDate),

    ]))
        .toList().reversed.toList();
  }

  List<DataGridRow>  _testList = [];

  @override
  List<DataGridRow> get rows =>  _testList;



  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
       return DataGridRowAdapter(
         //color: Colors.lime,
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            //color: Colors.white,
            padding: const EdgeInsets.all(8.0),
            child: Text(
                textAlign: TextAlign.right,
                dataGridCell.value.toString()),
          );
        }).toList().reversed.toList());
  }
}