import 'package:sqflite/sqflite.dart';

import 'DatabaseHelper.dart';
import 'data_model.dart';

List<ModelClass> dataList=[];

DatabaseHelper myhelper=DatabaseHelper.instance;

int start()
{
  ModelClass newrow=ModelClass(id: 10, stCol1: 'stCol1', stCol2: 'stCol2');
  myhelper.insert(newrow);

  return 0;
}