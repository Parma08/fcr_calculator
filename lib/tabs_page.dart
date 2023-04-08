import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:fcr_calculator/Screens/history_screen.dart';
import 'package:fcr_calculator/Screens/per_bird_cost_screen.dart';
import 'package:fcr_calculator/Screens/profilescreen.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<Widget> tabScreens = [
    CalculatorScreen(),
    PerBirdCostScreen(),
    HistoryScreen(),
    ProfileScreen()
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
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate_outlined), label: 'FCR'),
            BottomNavigationBarItem(
                icon: Icon(Icons.money_sharp), label: 'Bird Cost'),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_history_outlined), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: tabScreens[index],
    );
  }
}
