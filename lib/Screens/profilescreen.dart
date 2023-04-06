import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 5),
            ]),
            padding: EdgeInsets.all(15),
            alignment: Alignment.centerLeft,
            child: Text(
              'Reset Password',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 5),
              ]),
              padding: EdgeInsets.all(15),
              alignment: Alignment.centerLeft,
              child: Text('Log out',
                  style: Theme.of(context).textTheme.labelMedium),
            ),
          )
        ],
      ),
    );
  }
}
