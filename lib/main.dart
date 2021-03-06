import 'package:flutter/material.dart';
import 'package:spongebob_streamer/screens/cartoon_picker.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: const Color.fromRGBO(58, 66, 86, 1.0)),
      debugShowCheckedModeBanner: false,
      home: const CartoonPicker()
    );
  }
}
