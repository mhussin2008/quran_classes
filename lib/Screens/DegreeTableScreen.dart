import 'package:flutter/material.dart';
import '';
import '../Data/DegreeData.dart';

class DegreeTable extends StatefulWidget {
   DegreeTable({Key? key}) : super(key: key);

  @override
  State<DegreeTable> createState() => _DegreeTableState();
}

class _DegreeTableState extends State<DegreeTable> {





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //DegreeData.getDegreeData().then((value) => print('done'));
    

  }
  
  @override
  Widget build(BuildContext context) {
    List<TextEditingController> tEditContoller=[];
    tEditContoller.clear();
    tEditContoller=
         List.generate(DegreeData.degreeTable.length, (index) => TextEditingController(text: DegreeData.degreeTable[index].toString() ));
      print(DegreeData.degreeTable.length.toString());
    print('im here');
    print(tEditContoller[0].text);

    return  Scaffold(
      appBar: AppBar(
        title: Text('جدول درجات الخصم'),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  tEditContoller.asMap().entries.map  (
                          (entry) =>  Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: TextField(
                                      controller: tEditContoller[entry.key]  ,
                                       ),
                                )
                                ,SizedBox(width: 20,)
                                ,
                                Expanded(child: Text(DegreeData.faultList[entry.key]))
                              ],
                            ),
                          )).toList()
              ),
              SizedBox(height: 40,),
              OutlinedButton(onPressed: () async {
                // DegreeData.degreeTable=DegreeData.degreeTable.asMap().entries.map((entry) {
                //   return int.parse(tEditContoller[entry.key].text);
                // }).toList();
                DegreeData.degreeTable.clear();
                tEditContoller.forEach((element) {
                  DegreeData.degreeTable.add(double.parse(element.text));
                });
                //print(DegreeData.degreeTable);
                Navigator.pop(context);

                await DegreeData.setDegreeData();
                await Future.delayed(Duration(seconds: 1), () {
                  // deleayed code here

                });
                
              }, child: Text('حفظ ورجوع للشاشة الرئيسية'))
            ,

              // OutlinedButton(onPressed: () async {
              //   // DegreeData.degreeTable=DegreeData.degreeTable.asMap().entries.map((entry) {
              //   //   return int.parse(tEditContoller[entry.key].text);
              //   // }).toList();
              //   DegreeData.degreeTable.clear();
              //
              //   //print(DegreeData.degreeTable);
              //   await DegreeData.getDegreeData();
              //   print(DegreeData.degreeTable);
              //   print(DegreeData.degreeTableS);
              //   setState(() {
              //
              //   });
              //
              // }, child: Text('read data'))
            ],
          ),
        ),
      ) ,
    );
  }
}
