import 'package:flutter/material.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text(
          'إنتبه',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          'سيتم مسح بيانات كل الطلبة',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 40,
                  //color: Colors.red,
                  decoration: BoxDecoration(
                      color: Colors.cyan,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all()),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text(
                      'تراجع',
                    ),
                  )),
              Container(
                //color: Colors.red,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.deepOrangeAccent,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all()),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text('مسح'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
