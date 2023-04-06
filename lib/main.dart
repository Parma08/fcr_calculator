import 'package:fcr_calculator/tabs_page.dart';
import 'package:flutter/material.dart';

import 'Screens/login_screen.dart';

void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
        labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )),
      home: LoginScreen(),
    );
  }
}
