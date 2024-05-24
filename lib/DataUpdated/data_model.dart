class ModelClass{
  int id;
  String stCol1="";
  String stCol2="";

  ModelClass({
    required this.id,
    required this.stCol1,
    required this.stCol2});


  @override
  String toString() {
    return 'ModelClass{id:$id,stCol1: $stCol1, stCol2: $stCol2}';
  }

  Map<String,dynamic> toMap() {
    return {
      'id':id,
      'stCol1': stCol1,
      'stCol2': stCol2
    };
  }

}