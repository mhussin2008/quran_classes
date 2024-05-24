import 'package:shared_preferences/shared_preferences.dart';
class DegreeData{
  static List<double> degreeTable=[2.0,2.0,2.0,2.0,2.0];
  static List<String> faultList=['صحح له المعلم','صحح بنفسه','التردد','خطأ التجويد','خطأ الوقف والإبتداء'];
  static List<String>? degreeTableS=['2.0','2.0','2.0','2.0','2.0'];


  static Future<void> getDegreeData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    degreeTableS=await prefs.getStringList('degrees');
    //await Future.delayed(Duration(seconds: 2));
      print(degreeTableS);
    //degreeTable.clear();
    if(degreeTableS != null){
      degreeTable.clear();

    degreeTableS!.forEach((element) {
      degreeTable.add(double.parse(element));

    });
    }else{print('it is null');}
  }

  static Future<void> setDegreeData() async{
    //SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();


    if(degreeTable.isNotEmpty){
      degreeTableS=[];

       degreeTable.forEach((element) {
          degreeTableS!.add(element.toString());

        });
      }
    print(degreeTableS);
    bool ret=await prefs.setStringList('degrees',degreeTableS!);
    print(ret.toString());

    }

  }


