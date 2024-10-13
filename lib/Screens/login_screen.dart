import 'package:fcr_calculator/Screens/guest_user_screen.dart';
import 'package:fcr_calculator/Screens/register_screen.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/tabs_page.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog(context, 'Please fill all the fields');
      return;
    }

    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      await initializeDataFromDB();
      isLoading = false;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) {
        return const TabsPage();
      }), (route) => false);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      showErrorDialog(context, e.message.toString());
    }
  }

  Widget inputFieldBuilder(
      {required BuildContext context,
      required String hintText,
      required TextEditingController controller,
      required Icon icon,
      required String type}) {
    bool obscureTextEnabled = false;
    TextInputType keyboardType = TextInputType.emailAddress;
    if (type == 'password') {
      keyboardType = TextInputType.text;
      obscureTextEnabled = true;
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
                          child: Image.asset(
                            'assets/images/success.png',
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Please Login to Continue',
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
                            hintText: 'Enter Your Email',
                            controller: emailController,
                            icon: const Icon(Icons.email),
                            type: 'email'),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Enter Your Password',
                            controller: passwordController,
                            icon: const Icon(Icons.lock),
                            type: 'password'),
                        GestureDetector(
                          onTap: () {
                            login(context);
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
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return const RegisterScreen();
                            }));
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 18,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return const GuestUserScreen();
                            }));
                          },
                          child: Text(
                            'Don\'t wanna Login?',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
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
            SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
