import 'package:fcr_calculator/Screens/register_screen.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/tabs_page.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

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
        return TabsPage();
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
        margin: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            color: Color(0xFFE4E4E4), borderRadius: BorderRadius.circular(10)),
        child: LayoutBuilder(
          builder: (_, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                icon,
                Container(
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
            child: Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: LayoutBuilder(
                builder: (_, constraints) => ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.3,
                          child: Image.asset(
                            'assets/images/success.png',
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'Please Login to Continue',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Enter Your Email',
                            controller: emailController,
                            icon: Icon(Icons.email),
                            type: 'email'),
                        inputFieldBuilder(
                            context: context,
                            hintText: 'Enter Your Password',
                            controller: passwordController,
                            icon: Icon(Icons.lock),
                            type: 'password'),
                        GestureDetector(
                          onTap: () {
                            login(context);
                          },
                          child: Center(
                            child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Text(
                                  'Login',
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
                              return RegisterScreen();
                            }));
                          },
                          child: Text(
                            'Register',
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
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
