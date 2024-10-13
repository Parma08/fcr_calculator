import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/tabs_page.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  Widget inputFieldBuilder(
      {required BuildContext context,
      required String hintText,
      required TextEditingController controller,
      required Icon icon,
      required String type}) {
    bool obscureTextEnabled = false;
    TextInputType keyboardType = TextInputType.emailAddress;
    if (type == 'password') {
      obscureTextEnabled = true;
    }
    if (type == 'password' || type == 'name') {
      keyboardType = TextInputType.text;
    }

    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: const Color(0xFFE4E4E4), borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                SizedBox(
                  width: constraints.maxWidth * 0.9,
                  child: TextField(
                    controller: controller,
                    obscureText: obscureTextEnabled,
                    style: Theme.of(context).textTheme.labelMedium,
                    keyboardType: keyboardType,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: hintText),
                  ),
                ),
              ],
            );
          },
        ));
  }

  register(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showErrorDialog(context, 'Please fill all the details');
      return;
    } else if (passwordController.text != confirmPasswordController.text) {
      showErrorDialog(
          context, 'Password and Confim Passwords fields do not match');
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, e.message.toString());
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({'name': nameController.text});

      setUserDetails(
          nameController.text.trim(), FirebaseAuth.instance.currentUser!.uid);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        isLoading = false;
        return const TabsPage();
      }), (route) => false);
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: isLoading,
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: LayoutBuilder(
                builder: (_, constraints) => ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.3,
                          child: SvgPicture.asset(
                            'assets/images/delete_confirmation.svg',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Registration',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Please Enter your Name',
                            controller: nameController,
                            icon: const Icon(Icons.account_circle_rounded),
                            type: 'name'),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Please Enter your Email',
                            controller: emailController,
                            icon: const Icon(Icons.email),
                            type: 'email'),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Please Enter your Password',
                            controller: passwordController,
                            icon: const Icon(Icons.lock),
                            type: 'password'),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Please Confirm your Password',
                            controller: confirmPasswordController,
                            icon: const Icon(Icons.lock),
                            type: 'password'),
                        GestureDetector(
                          onTap: () {
                            register(context);
                          },
                          child: Center(
                            child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 20),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return const LoginScreen();
                            }));
                          },
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
