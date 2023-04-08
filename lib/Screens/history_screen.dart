import 'package:fcr_calculator/Screens/cost_analysis_history.dart';
import 'package:fcr_calculator/Screens/fcr_history_tab.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/utils.dart';
import 'calculator_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('History'),
          centerTitle: true,
          bottom: TabBar(indicatorWeight: 3, tabs: [
            Tab(
              text: 'FCR History',
            ),
            Tab(
              text: 'Cost History',
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            FCRHistoryTab(),
            CostAnalysisTab(),
          ],
        ),
      ),
    );
  }
}
