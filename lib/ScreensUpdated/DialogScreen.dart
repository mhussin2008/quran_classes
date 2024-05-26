import 'package:flutter/material.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Directionality(

      textDirection: TextDirection.rtl,
      child: AlertDialog(
            title: const Text('إنتبه'),
            content: const Text('سيتم مسح بيانات كل الطلبة'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('تراجع',),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('مسح'),
              ),
            ],
          ),
    );

  }
}