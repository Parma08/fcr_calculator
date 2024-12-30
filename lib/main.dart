import 'package:fcr_calculator/Screens/counter_screens/counter_tab_page.dart';
import 'package:fcr_calculator/services/firebase_service_counter.dart';
import 'package:fcr_calculator/services/firebase_service_fcr.dart';
import 'package:fcr_calculator/tabs_page.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser?.uid != null) {
    try {
      await checkIsCounterUser();
      if (isCounterTypeUser()) {
      } else {
        var status = await initializeDataFromDB();
        if (status != 'success') {
          runApp(ErrorWidget(status));
          return;
        }
      }
    } on FirebaseException catch (e) {
      runApp(ErrorWidget(e.message as String));
      return;
    }
  }
  runApp(const MyWidget());
}

class ErrorWidget extends StatelessWidget {
  String message;
  ErrorWidget(this.message, {super.key});
  @override
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
          textTheme: const TextTheme(
        labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      )),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went Wrong'),
            );
          }
          if (snapshot.hasData) {
            return FutureBuilder(
                future: checkIsCounterUser(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went Wrong'),
                    );
                  }
                  if (snapshot.hasData) {
                    if (isCounterTypeUser()) return const CounterTabPage();
                    return const TabsPage();
                  } else {
                    return const Center(
                      child: Text('Something went Wrong'),
                    );
                  }
                });
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
