//import 'dart:js_interop';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_classes/Data/qaryData.dart';
import 'package:quran_classes/Screens/QaryExamScreen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../Data/QaryDataSource.dart';

import 'DialogScreen.dart';

class qaryDataEntry extends StatefulWidget {
  final String testName;
  qaryDataEntry({Key? key, required this.testName}) : super(key: key);

  @override
  State<qaryDataEntry> createState() => _qaryDataEntryState();
}

class _qaryDataEntryState extends State<qaryDataEntry> {
  //QaryDataSource dataSource=QaryDataSource(qaryList: QaryList);
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  List<bool> theSelected = <bool>[true, false];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   CheckDbase();
    // });
    QaryList.clear();

    CheckDbase().then((value) => {
          if (value == 'Ok')
            {
              GetFromDb(widget.testName)
                  .then((value) => {print('Loaded all data')})
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    //var chkbox_value='4 أسئلة';

    DataGridController dataGridController = DataGridController();
    QaryDataSource dataSource = QaryDataSource(qaryList: QaryList);
    //dataGridController.addListener((){listnerFunction();});
    const sb = SizedBox(
      width: 10,
    );
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 10.0,
          title: Text('  حلقة  ${widget.testName}'),
          backgroundColor: Colors.blueAccent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // SizedBox(
              //   height: 10,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        style: const TextStyle(height: 0.5),
                        keyboardType: TextInputType.text,
                        textDirection: TextDirection.rtl,
                        controller: nameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder())),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('اسم الطالب'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                        style: const TextStyle(height: 0.5),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                        controller: ageController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder())),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text('عمر الطالب'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        List<QaryData>? search = [];
                        search = QaryList.where((element) =>
                            element.qaryName == nameController.text).toList();
                        print(search);
                        if (search.length > 0) {
                          return;
                        }
                        //
                        if (nameController.text.isNotEmpty &&
                            ageController.text.isNotEmpty) {
                          setState(() {
                            QaryList.add(QaryData.fromFields(
                                nameController.text,
                                ageController.text,

                                widget.testName,
                                ));
                          });
                          String retVal = await CheckDbase();
                          if (retVal == 'Ok') {
                            print('ok');
                            await AddtoDb();
                          }
                          Fluttertoast.showToast(
                              msg: "تم إضافة بيانات الطالب بنجاح ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          nameController.text = '';
                          ageController.text = '';
                          FocusManager.instance.primaryFocus?.unfocus();
                          print(QaryList.toString());
                          print(QaryList.length.toDouble());
                          dataGridController.refreshRow(QaryList.length);
                          //dataGridController.scrollToRow(QaryList.length.toDouble());

                          // Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "بيانات الطالب غير مكتملة",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text('حفظ البيانات')),
                  const SizedBox(
                    width: 20,
                  ),
                  OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('عودة الى الشاشة\n الرئيسية')),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // Container(width: 20,color: Colors.green,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        if (dataGridController.selectedRow != null) {
                          String result = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                              const DialogScreen());

                          print(result);
                          if(result=='OK'){
                          print(dataGridController.selectedRow
                              ?.getCells()
                              .first
                              .value);
                          String qname = dataGridController.selectedRow
                              ?.getCells()
                              .first
                              .value;

                          setState(() {
                            QaryList.removeWhere((element) =>
                                element.qaryName ==
                                dataGridController.selectedRow
                                    ?.getCells()
                                    .first
                                    .value);
                          });
                          await DelSrowFromDb(qname, widget.testName);
                        }
                        //Navigator.pop(context);
                      }},
                      child: const Text('مسح بيانات \n الطالب')),
                  OutlinedButton(
                      onPressed: () async {
                        String result = await showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                const DialogScreen());

                        print(result);
                        if (result == 'OK') {
                          print('deleting');
                          setState(() {
                            QaryList.clear();
                          });
                          CheckDbase().then((value) async {
                            if (value == 'Ok') {
                              await ClearDb();
                            }
                            ;
                          });
                        }
                      },
                      child: const Text('مسح الجدول \n بالكامل')),

                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                // height: 200,
                //color: Colors.tealAccent,
                child: SfDataGrid(
                  allowEditing: true,
                  allowSorting: true,
                  selectionMode: SelectionMode.single,
                  columnWidthMode: ColumnWidthMode.fill,
                  isScrollbarAlwaysShown: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  controller: dataGridController,
                  source: dataSource,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                            color: Colors.cyanAccent,
                            padding: const EdgeInsets.all(4.0),
                            alignment: Alignment.centerRight,
                            child: const Text(
                              'اسم الطالب',
                            ))),
                    GridColumn(
                        columnName: 'age',
                        label: Container(
                            color: Colors.cyanAccent,
                            padding: const EdgeInsets.all(4.0),
                            alignment: Alignment.centerRight,
                            child: const Text('عمر الطالب  '))),
                  ].reversed.toList(),
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ));
  }

  Future<String> CheckDbase() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == false) {
      print('no such database');
    } else {}
    late Database db;
    db = await openDatabase('qary_dbase.db');
    if (db.isOpen == false) {
      print('cant open database');
      return 'No';
    }
    var tables = await db
        .rawQuery('SELECT * FROM sqlite_master WHERE name="datatable";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      try {
        await db.execute('''
        CREATE TABLE datatable (
        qaryname TEXT NOT NULL ,
        qaryage TEXT ,
        testname TEXT NOT NULL
        )''');
      } catch (err) {
        if (err.toString().contains('DatabaseException') == true) {
          print(err.toString());
          return 'No';
        }
        //print(err.toString().substring(0,30));
      }
    }
    return 'Ok';
  }

  Future<void> AddtoDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    String age = ageController.text;
    String line =
        ''' '${nameController.text}', '${age}' ,  '${widget.testName}' ''';
    String insertString =
        '''INSERT INTO datatable ( qaryname, qaryage,  testname ) VALUES ( ${line} )''';
    print(insertString);
    await db.execute(insertString);
  }

  Future<void> GetFromDb(String tname) async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    List<Map<String, dynamic>>? gotlist = await db.database
        .rawQuery('''SELECT * FROM datatable WHERE testname='${tname}' ''');
    print(gotlist);
    print(gotlist.length);
    if (gotlist.isNotEmpty) {
      QaryList.clear();

      setState(() {
        gotlist.forEach((e) {
          {
            //QaryList.add(QaryData.fromJson(e));
            //int qn=getQuestNum(theSelected[0]);
            print(e['qaryage'].runtimeType);
            QaryList.add(QaryData.fromFields(e['qaryname'], e['qaryage'],
                 e['testname']));
          }
          ;
        });
        print(QaryList);
      });
    }
  }

  Future<void> ClearDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.database.rawQuery('DELETE FROM datatable');
    setState(() {});
  }

  Future<void> DelSrowFromDb(String qname, String tname) async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.rawDelete(
        'DELETE FROM datatable WHERE qaryname = ? AND testname = ?',
        [qname, tname]);
  }

  int getQuestNum(bool theInput) {
    if (theInput == true) {
      return 4;
    } else {
      return 5;
    }
  }
}
