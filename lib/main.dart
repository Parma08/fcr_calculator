import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/tabs_page.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser?.uid != null) {
    var status = await initializeDataFromDB();
    if (status != 'success') {
      runApp(ErrorWidget(status));
      return;
    }
  }
  runApp(MyWidget());
}

class ErrorWidget extends StatelessWidget {
  String message;
  ErrorWidget(this.message);
  Widget build(BuildContext context) {
    return Center(
      child: Text(message),
    );
  }
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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Something went Wrong'),
            );
          }
          if (snapshot.hasData) {
            return TabsPage();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
