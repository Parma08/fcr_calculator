import 'package:fcr_calculator/utils/counter_gettersetter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CounterRecordScreen extends StatefulWidget {
  const CounterRecordScreen({super.key});

  @override
  State<CounterRecordScreen> createState() => _CounterRecordScreenState();
}

class _CounterRecordScreenState extends State<CounterRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: SpeedDial(
        icon: Icons.add, // The main button icon
        backgroundColor: Colors.blue,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.price_change_rounded),
            label: 'Sell',
            onTap: () {
              print('Button 1 tapped');
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.shopping_cart),
            label: 'Buy',
            onTap: () {
              print('Button 2 tapped');
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
