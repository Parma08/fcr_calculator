import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GuestUserScreen extends StatelessWidget {
  const GuestUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        child: LayoutBuilder(builder: (_, constraints) {
          return Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 60),
                height: constraints.maxHeight * 0.35,
                child: SvgPicture.asset('assets/images/info.svg'),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Welcome to our app! Although we recommend signing in for the best experience, we understand if you prefer not to. Please note that except FCR calculator all other features will be blocked if you choose to skip the login process. If you change your mind later, simply return to the login page to log in. Thank you for using our app!',
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CalculatorScreen();
                    }));
                  },
                  child: Text('Move to FCR Calculator'))
            ],
          );
        }),
      ),
    );
  }
}
