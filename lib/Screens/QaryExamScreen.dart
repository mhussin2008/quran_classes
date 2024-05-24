import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Data/examDetailData.dart';
import '../Data/ExamDetailSource.dart';
import '../Data/DegreeData.dart';

class QaryExam extends StatefulWidget {


  const QaryExam({Key? key, required this.qaryName, required this.degree,required this.testName, required this.questions}) : super(key: key);
  final String qaryName;
  final double degree;
  final String testName;
  final int questions;

  @override
  State<QaryExam> createState() => _QaryExamState();
}

class _QaryExamState extends State<QaryExam> {


  double totalMark=0;
  double mark=0 ;
  List<TextEditingController> markController=[];
  List<double> faultValue=DegreeData.degreeTable??[2.0,2.0,2.0,2.0,2.0];
  List<String> qNamesAll=['الأول',
  'الثانى','الثالث','الرابع','الخامس'];

  var theSelectedAll=[false,false,false,false,false];
  List<bool> theSelected=[];
  List<double> questionList=[];
  List<Text> txtList=[];
  int SelectedToggleIndex=0;

  @override
  void initState()  {
    // TODO: implement initState
print('init State');
    mark=100.0/widget.questions;
    questionList=List.generate(widget.questions, (index) => mark);
    markController=List.generate(widget.questions, (index) => TextEditingController());
    markController.forEach((element) {element.text=mark.toString(); });

    print(widget.questions);
    ExamDetailDataList.clear();
    //SelectedToggleIndex=widget.questions-1;
    CheckDbase().then((value) {
      print(value);
      return {

        if (value=='Ok'){
          GetFromDb().then((value) => {
            print('Loaded all data')

          })
        }
      };
    });

    updateSelected();
    updateSum().then((value) {
      calcTotal();
      setState(() {

      });
      return null;
    });


    // CheckDbase().then((value) =>
    // {
    //   if (value=='Ok'){
    //     GetDegree().then((retVal) => {
    //       mark=retVal,
    //       print('here $retVal')
    //
    //     })
    //   }
    // }
    // );
    super.initState();




  }

  @override
  void dispose() {
    print('dispose: $this');
    super.dispose();
  }
  
  void updateSelected() {
    theSelected.clear();
    txtList.clear();
    for(int i=0;i<widget.questions;i++){
      theSelected.add(theSelectedAll[i]);

      txtList.add(Text(qNamesAll[i],textDirection: TextDirection.rtl));

    }
    theSelected[widget.questions-1]=true;
  }

  @override
  Widget build(BuildContext context) {
    DataGridController dataGridController=DataGridController();
    ExamDetailDataSource dataSource = ExamDetailDataSource(ExamDetailList: ExamDetailDataList);


      for( int i=0;i<markController.length;i++){
    markController[i].text=questionList[i].toString() ;}
      calcTotal();
      //updateSelected();


   // markController.text=mark.toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title:  Center(child: Text('${widget.qaryName} إختبار '))),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/jpg/back.jpg' ),fit: BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            ToggleButtons(


                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.pink[900],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 60.0,
                ),


                isSelected: theSelected,//.reversed.toList(),

                onPressed: (int toggleIndex) {
                  SelectedToggleIndex=widget.questions-toggleIndex-1;
                  print('toggleindex=${toggleIndex}  ${SelectedToggleIndex}  ');


                  //theSelected=<bool>[false,true];
                  theSelected.clear();
                  theSelected=theSelectedAll.sublist(0,widget.questions);
                  theSelected[0]=false;
                  setState(() {

                    theSelected[toggleIndex]=true;



                    print(theSelected);
                    // The button that is tapped is set to true, and the others to false.

                  });
                },
                //color: Colors.white,
                //fillColor: Colors.white,
                children: txtList.reversed.toList()
                                   ),

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                markController.asMap().entries.map((e) =>
                    SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: markController[e.key],
                        style: const TextStyle(
                            fontSize: 20
                        ),

                      ),
                    )
                ).toList()



              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                    onPressed: () {

                      ExamDetailDataList.add(ExamDetailData(
                          qaryName: widget.qaryName,
                          testName: widget.testName,
                          qNumber: qNamesAll[SelectedToggleIndex], desc: DegreeData.faultList[0], degreeDec: faultValue[0]));
                      AddSingletoDb();
                      print(ExamDetailDataList);
                      decreaseMark(faultValue[0]);
                      calcTotal();
                      },
                    style: ElevatedButton.styleFrom(

                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.black, // <-- Splash color
                    ),
                    child: Text('${DegreeData.faultList[0]}\n${faultValue[0]}',
                    textAlign: TextAlign.center
                    ,style: TextStyle(fontSize: 20),)),
                const SizedBox(width: 10,),
                OutlinedButton(
                    onPressed: () {
                      ExamDetailDataList.add(ExamDetailData(
                          qaryName: widget.qaryName, testName: widget.testName,
                          qNumber: qNamesAll[SelectedToggleIndex], desc: DegreeData.faultList[1], degreeDec: faultValue[1]));
                      AddSingletoDb();
                      decreaseMark(faultValue[1]);
                      calcTotal();
                    },
                    style: ElevatedButton.styleFrom(

                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.black, // <-- Splash color
                    ),
                    child: Text('${DegreeData.faultList[1]}\n${faultValue[1]}',
                      textAlign: TextAlign.center
                      ,style: const TextStyle(fontSize: 20),)),
                SizedBox(width: 10,),

                OutlinedButton(
                    onPressed: () {
                      ExamDetailDataList.add(ExamDetailData(
                          qaryName: widget.qaryName, testName: widget.testName,
                          qNumber: qNamesAll[SelectedToggleIndex], desc: DegreeData.faultList[2], degreeDec: faultValue[2]));
                      AddSingletoDb();
                      decreaseMark(faultValue[2]);
                      calcTotal();
                    },
                    style: ElevatedButton.styleFrom(

                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.black, // <-- Splash color
                    ),
                    child:  Text('${DegreeData.faultList[2]}\n${faultValue[2]}',
                      textAlign: TextAlign.center
                      ,style: TextStyle(fontSize: 20),)),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                const SizedBox(width: 10,),
                OutlinedButton(
                    onPressed: () {
                      ExamDetailDataList.add(ExamDetailData(
                          qaryName: widget.qaryName, testName: widget.testName,
                          qNumber: qNamesAll[SelectedToggleIndex], desc: DegreeData.faultList[3], degreeDec: faultValue[3]));
                      AddSingletoDb();
                      decreaseMark(faultValue[3]);
                      calcTotal();
                    },
                    style: ElevatedButton.styleFrom(

                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.black, // <-- Splash color
                    ),
                    child: Text('${DegreeData.faultList[3]}\n${faultValue[3]}',
                      textAlign: TextAlign.center
                      ,style: TextStyle(fontSize: 20),)),
                const SizedBox(width: 10,),
                OutlinedButton(
                    onPressed: () {
                      ExamDetailDataList.add(ExamDetailData(
                          qaryName: widget.qaryName, testName: widget.testName,
                          qNumber: qNamesAll[SelectedToggleIndex], desc: DegreeData.faultList[4], degreeDec: faultValue[4]));
                      AddSingletoDb();
                      decreaseMark(faultValue[4]);
                      calcTotal();
                    },
                    style: ElevatedButton.styleFrom(

                      padding: const EdgeInsets.all(8),
                      backgroundColor: Colors.blue, // <-- Button color
                      foregroundColor: Colors.black, // <-- Splash color
                    ),
                    child: Text('${DegreeData.faultList[4]}\n${faultValue[4]}',
                      textAlign: TextAlign.center
                      ,style: const TextStyle(fontSize: 20),)),
                const SizedBox(width: 10,),
              ],
            ),

          const SizedBox(height: 20,)

          ,Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ElevatedButton(onPressed: () async {
                //   await updateSum();
                //   calcTotal();
                //   setState(() {
                //
                //   });
                //
                //   print(ExamDetailDataList[0]);
                //
                // }, child: Text('TEST')),
                const SizedBox(width: 10,),
                Text(totalMark.toString(),
                  style: const TextStyle(
                    fontSize: 20
                  ),
                ),
                const SizedBox(width: 10,),

                OutlinedButton(
                  onPressed: () async {
                    if(await CheckDbase()=='Ok'){
                      calcTotal();

                      await DelFromDb();
                        await AddAlltoDb();
                      await updateDb(totalMark);
                    }

                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                     padding: const EdgeInsets.all(8),
                    backgroundColor: Colors.limeAccent, // <-- Button color
                    foregroundColor: Colors.black, // <-- Splash color
                  ),
                  child: const Text('حفظ الدرجة والعودة'
                    ,style: TextStyle(fontSize: 20),)),],),
          ),

            Container(
              height: 200,
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
                // onCellTap: (cellDetails){
                //     // setState(() {
                //     //
                //       print(cellDetails.rowColumnIndex.rowIndex-1);
                //       int x=(QaryList[cellDetails.rowColumnIndex.rowIndex-1].questions);
                //     //});
                //   setState(() {
                //     if(x==4){theSelected=[true,false];}
                //     else{theSelected=[false,true];}
                //   });
                //     //print(cellDetails.rowColumnIndex.rowIndex);
                // },
                columns: <GridColumn>[
                  GridColumn(

                      columnName: 'qnumber',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text(
                            'رقم السؤال',

                          ))),
                  GridColumn(

                      columnName: 'desc',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text('وصف الخطأ '))),

                  GridColumn(
                      columnName: 'degreedec',
                      label: Container(
                          color: Colors.cyanAccent,
                          padding: EdgeInsets.all(4.0),
                          alignment: Alignment.centerRight,
                          child: Text('الدرجة')))
                  ,

                ].reversed.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void decreaseMark(double fValue) {
    int sel=theSelected.indexWhere((element) => element==true);
    print(sel);
    if( questionList[sel]-fValue<=0){

      questionList[sel]=0; }else{
      questionList[sel]-=fValue;}

    setState(() {


    });
  }


  Future<void> AddAlltoDb() async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    //int age=int.parse(ageController.text);
    //ExamDetailDataList[ExamDetailDataList.length-1]
    for(int i=0;i<ExamDetailDataList.length;i++){
    String line=''' '${ExamDetailDataList[i].qaryName}', '${ExamDetailDataList[i].testName}'  , '${ExamDetailDataList[i].qNumber}', '${ExamDetailDataList[i].desc}', ${ExamDetailDataList[i].degreeDec}  ''';
    String insertString =
    '''INSERT INTO questtable ( qaryname, testname, qnumber, desc, degreedec) VALUES ( ${line} )''';
    print(insertString);
    await db.execute(insertString);
    }

  }

  Future<void> AddSingletoDb() async {

    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);
    //int age=int.parse(ageController.text);
    //ExamDetailDataList[ExamDetailDataList.length-1]
    int i=ExamDetailDataList.length-1;
      String line=''' '${ExamDetailDataList[i].qaryName}', '${ExamDetailDataList[i].testName}'  , '${ExamDetailDataList[i].qNumber}', '${ExamDetailDataList[i].desc}', ${ExamDetailDataList[i].degreeDec}  ''';
      String insertString =
      '''INSERT INTO questtable ( qaryname, testname, qnumber, desc, degreedec) VALUES ( ${line} )''';
      print(insertString);
      await db.execute(insertString);


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
        .rawQuery('SELECT * FROM sqlite_master WHERE name="questtable";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      try {
        await db.execute('''
        create table questtable (
        qaryname TEXT NOT NULL ,
        testname TEXT NOT NULL,
        qnumber TEXT,
        desc TEXT,
        degreedec REAL 
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

  Future<void> GetFromDb() async{
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);

    //testname='${tname}'
    List<Map<String,dynamic>>? gotlist =
    await db.database.rawQuery('''SELECT * FROM questtable WHERE qaryname= '${widget.qaryName}'  AND testname= '${widget.testName}' ''');
    print(gotlist);
    setState(() {
      ExamDetailDataList.clear();
    });
    if(gotlist.isNotEmpty){

      setState(() {
        gotlist.forEach((e) {
          {
            //QaryList.add(QaryData.fromJson(e));
            ExamDetailDataList.add(ExamDetailData.fromFields(e['qaryname'], e['testname'], e['qnumber'], e['desc'], e['degreedec']));
          };
        });
        print(ExamDetailDataList);
      });}
    else{print('empty data list');
  }
  }



  Future<void> DelFromDb() async{
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/qary_dbase.db';
    late Database db;
    db = await openDatabase(dbFilePath);

    //testname='${tname}'
    List<Map<String,dynamic>>? gotlist =
    await db.database.rawQuery('''DELETE FROM questtable WHERE qaryname= '${widget.qaryName}'  AND testname= '${widget.testName}' ''');
     print('deleted row');

    }



  Future<void> updateSum()  async {
    var db = await openDatabase('qary_dbase.db');
    var dsums=[];
    var sums=[];

    sums= await db.rawQuery('''
    SELECT SUM(degreedec) FROM questtable 
    WHERE qaryname = '${widget.qaryName}' AND testname = '${widget.testName}'
    GROUP BY qnumber
    '''
    );

    print('questions'+widget.questions.toString());

    for(int i=sums.length-1;i>=0;i--){
      double x;
      x=sums[i]['SUM(degreedec)'] as double;
      print(widget.questions-i-1);
      questionList[widget.questions-i-1]=100/widget.questions-x;
      print(x.toString()+'  '+i.toString());
    }



    // print(sums);
    // print(dsums);
    // print(dsums.runtimeType);

  }


  Future<void> updateDb(double newdegree)  async {
    var db = await openDatabase('qary_dbase.db');

    int updateCount = await db.rawUpdate('''
    UPDATE datatable 
    SET  degree = ? 
    WHERE qaryname = ? AND testname = ?
    ''',
        [newdegree,widget.qaryName,widget.testName]);

    print(updateCount.toString());
  }

  Future<double> GetDegree() async {
    var deg;
    var db = await openDatabase('qary_dbase.db');
    deg = await db.rawQuery('''
    SELECT degree FROM datatable 
    WHERE qaryname = '${widget.qaryName}' AND testname = '${widget.testName}'
    '''
        );
    print(deg[0]);
    print(deg[0]['degree'].runtimeType);

    return deg[0]['degree'];
  }

  void calcTotal() {
    double total=0;

    for(int i=0;i<markController.length;i++){
      total+=double.parse(markController[i].text);
      print(total);
    }

    totalMark=total;
    setState(() {

    });
  }


}
