//import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:quran_classes/Screens/QaryExamScreen.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
//import 'package:quran_test/Data/qaryData.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Data/QaryDataSource.dart';
import '../Data/TestDataSource.dart';
import '../Data/testData.dart';

import '../ScreensUpdated/DialogScreen.dart';
import '../ScreensUpdated/QaryDataEntryScreenUpdated.dart';

class challengeEntryScreen extends StatefulWidget {
  challengeEntryScreen({Key? key}) : super(key: key);

  @override
  State<challengeEntryScreen> createState() => _challengeEntryScreenState();
}

class _challengeEntryScreenState extends State<challengeEntryScreen> {
  //QaryDataSource dataSource=QaryDataSource(qaryList: QaryList);
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   CheckDbase();
    // });


    CheckDbase().then((value) {
      print(value);
      return {

      if (value=='Ok'){
      GetFromDb().then((value) => {
        print('Loaded all data')

      })
    }
    };
    }
    );
  }

  @override
  Widget build(BuildContext context) {

    DataGridController dataGridController=DataGridController();
    TestDataSource dataSource = TestDataSource(testList:TestList);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Container(
              

              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/jpg/back.jpg' ),fit: BoxFit.cover
                  )
              ),


              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text('اسم الحلقة'),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        style: const TextStyle(height: 0.5),
                        keyboardType: TextInputType.text,
                        textDirection: TextDirection.rtl,
                        controller: nameController,

                        decoration:
                            const InputDecoration(border: OutlineInputBorder())),
                    SizedBox(
                      height: 10,
                    ),
                    Text('تاريخ الحلقة'),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        style: const TextStyle(height: 0.5),
                        keyboardType: TextInputType.number,
                        textDirection: TextDirection.rtl,
                        controller: dateController,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder())),
                    SizedBox(
                      height: 10,
                    ),
                    OutlinedButton(
                        onPressed: () async {
                          List<TestData>? search=[];
                         search=TestList.where((element) => element.testName==nameController.text).toList();
                          print(search);
                          if(search.length>0){
                            return;
                          }
                         //
                          if (nameController.text.isNotEmpty &&
                              dateController.text.isNotEmpty) {
                            setState(()  {
                              TestList.add(TestData.fromFields(nameController.text,
                                  dateController.text));
                                });
                            String retVal=await  CheckDbase();
                            if (retVal=='Ok'){
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
                            dateController.text = '';
                            FocusManager.instance.primaryFocus?.unfocus();
                            print(TestList.toString());
                              print(TestList.length.toDouble());
                              dataGridController.refreshRow(TestList.length);
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
                        child: Text('حفظ البيانات')),
                    SfDataGrid(
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
                              padding: EdgeInsets.all(2.0),
                              alignment: Alignment.centerRight,
                              child: Text(
                               'اسم الحلقة',

                              ))),
                      GridColumn(
                          columnName: 'age',
                          label: Container(
                              color: Colors.cyanAccent,
                              padding: EdgeInsets.all(2.0),
                              alignment: Alignment.centerRight,
                              child: Text('تاريخ الحلقة ')))
                    ].reversed.toList(),
                      ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly ,children: [
                      OutlinedButton(

                          onPressed: () async {
                            if(dataGridController.selectedRow != null){
                              print(dataGridController.selectedRow?.getCells().first.value);
                              String qname=dataGridController.selectedRow?.getCells().first.value;

                              setState(() {
                                TestList.removeWhere(
                                        (element) => element.testName==dataGridController.selectedRow?.getCells().first.value);
                              });
                              await DelSrowFromDb(qname);

                            }
                            //Navigator.pop(context);
                          },
                          child: Text('مسح بيانات \n الحلقة')),

                      OutlinedButton(

                          onPressed: () {
                            String Selected='';
                            if(dataGridController.selectedRow != null){
                            Selected=dataGridController.selectedRow!.getCells().first.value.toString();

                              print(dataGridController.selectedRow?.getCells().first.value);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => qaryDataEntry(testName: Selected)));
                            }
                            //Navigator.pop(context);
                          },
                          child: Text('إدخال بيانات\n الطلبة',
                          textDirection: TextDirection.rtl,),
                      ),

                      OutlinedButton(
                          onPressed: () async {
                            String result= await showDialog(
                                context: context,
                                builder: (BuildContext context) => const DialogScreen());

                            print(result);
                            if(result=='OK'){
                              print('deleting');
                              setState(() {
                                TestList.clear();
                              });
                              CheckDbase().then(
                                      (value) async {
                                        if(value=='Ok'){
                                          await ClearDb();
                                        };
                                      });
                            }

                          },
                          child: Text('مسح الجدول \n بالكامل')),


                    ],


                    ),
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('عودة الى الشاشة الرئيسية')),

                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<String> CheckDbase() async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == false) {
      print('no such database');

    } else {

    }
    late Database db;
    db = await openDatabase('qary_dbase.db');
    if (db.isOpen == false) {
      print('cant open database');
      return 'No';
    }
    var tables = await db
        .rawQuery('SELECT * FROM sqlite_master WHERE name="testtable";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      try {
        await db.execute('''
        create table testtable (
        testname TEXT NOT NULL UNIQUE ,
        testdate TEXT 
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
    String testdate=dateController.text;
    String line=''' '${nameController.text}', '${testdate}' ''';
    String insertString =
    '''INSERT INTO testtable ( testname, testdate) VALUES ( ${line} )''';
    print(insertString);
    await db.execute(insertString);

  }


  Future<void> GetFromDb() async{
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    List<Map<String,dynamic>>? gotlist =
    await db.database.rawQuery('SELECT * FROM testtable');
    print(gotlist);
    setState(() {
      TestList.clear();
    });
    if(gotlist.isNotEmpty){

    setState(() {
      gotlist.forEach((e) {
        {
          //QaryList.add(QaryData.fromJson(e));
         TestList.add(TestData.fromFields(e['testname'],e['testdate']));
      };
    });
    print(TestList);
  });}
}

  Future<void> ClearDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.database.rawQuery('DELETE FROM testtable');
    setState(() {

    });

  }


  Future<void> DelSrowFromDb(String tname) async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.rawDelete('DELETE FROM testtable WHERE testname = ?',[tname]);




  }

}
