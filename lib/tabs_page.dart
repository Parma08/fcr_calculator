import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:fcr_calculator/Screens/farm_record_screen/farm_record_screen.dart';
import 'package:fcr_calculator/Screens/history_screen.dart';
import 'package:fcr_calculator/Screens/per_bird_cost_screen.dart';
import 'package:fcr_calculator/Screens/profilescreen.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  List<Widget> tabScreens = [
    CalculatorScreen(),
    const PerBirdCostScreen(),
    const HistoryScreen(),
    const FarmRecordScreen(),
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
                icon: Icon(Icons.calculate_outlined), label: 'FCR'),
            BottomNavigationBarItem(
                icon: Icon(Icons.money_sharp), label: 'Bird Cost'),
            BottomNavigationBarItem(
                icon: Icon(Icons.work_history_outlined), label: 'History'),
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
