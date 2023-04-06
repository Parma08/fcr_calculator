import 'package:fcr_calculator/Screens/calculator_screen.dart';
import 'package:fcr_calculator/Screens/history_screen.dart';
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
    HistoryScreen(),
    ProfileScreen()
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: index == 1
          ? Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return CalculatorScreen(
                        showFullCalculator: true,
                      );
                    }));
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  )),
            )
          : SizedBox(),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          onTap: (selectedIndex) {
            setState(() {
              index = selectedIndex;
            });
          },
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.calculate_outlined), label: 'Calculator'),
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
