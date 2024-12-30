import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:fcr_calculator/Screens/farm_record_screen/farm_record_screen.dart';
import 'package:fcr_calculator/Screens/history_screen.dart';
import 'package:fcr_calculator/Screens/per_bird_cost_screen.dart';
import 'package:fcr_calculator/Screens/profilescreen.dart';
import 'package:flutter/material.dart';

class CounterTabPage extends StatefulWidget {
  const CounterTabPage({super.key});

  @override
  State<CounterTabPage> createState() => _CounterTabPageState();
}

class _CounterTabPageState extends State<CounterTabPage> {
  List<Widget> tabScreens = [
    CalculatorScreen(),
    const ProfileScreen(),
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          currentIndex: index,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.note_add_outlined), label: 'Farm Record'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: tabScreens[index],
    );
  }
}
