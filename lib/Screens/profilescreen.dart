import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: Theme.of(context).primaryColor, blurRadius: 5),
            ]),
            padding: const EdgeInsets.all(15),
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
              padding: const EdgeInsets.all(15),
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
