import 'package:driver_data_preview/screens/driver_list.dart';
import 'package:driver_data_preview/screens/loading.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Driver Data',
      debugShowCheckedModeBanner: false,
      home: Loading(),
    );
  }
}




