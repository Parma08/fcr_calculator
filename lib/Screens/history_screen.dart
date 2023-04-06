import 'package:fcr_calculator/Screens/information_screen.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('History'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height),
        child: ListView.builder(
          itemBuilder: (_, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return InformationScreen(
                    calculationDisplayInformation: getCalculationHistory[index],
                  );
                }));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).primaryColorLight,
                          blurRadius: 4)
                    ]),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(DateFormat.yMMMEd().format(getCalculationHistory[index]
                        .inputs
                        .chickPlacementDate)),
                    Text('${getCalculationHistory[index].inputs.farmerName}'),
                    Text('${getCalculationHistory[index].inputs.feedName}'),
                  ],
                ),
              ),
            );
          },
          itemCount: getCalculationHistory.length,
        ),
      ),
    );
  }
}
