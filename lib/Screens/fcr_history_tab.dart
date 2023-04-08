import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/gettersetter.dart';
import 'calculator_screen.dart';
import 'fcr_information_screen.dart';

class FCRHistoryTab extends StatelessWidget {
  const FCRHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
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
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  AppBar().preferredSize.height),
          child: LayoutBuilder(
            builder: (_, constraints) => ListView.builder(
              itemBuilder: (_, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return FCRInformationScreen(
                        calculationDisplayInformation:
                            getfcrCalculationHistory[index],
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
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  DateFormat.yMMMd().format(
                                      getfcrCalculationHistory[index]
                                          .inputs
                                          .chickPlacementDate),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                            Text('  ||  '),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                  DateFormat.yMMMd().format(
                                      getfcrCalculationHistory[index]
                                          .inputs
                                          .chickSellDate),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16)),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: constraints.maxWidth * 0.7,
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${getfcrCalculationHistory[index].inputs.farmerName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.7,
                                  child: Text(
                                    '${getfcrCalculationHistory[index].inputs.feedName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Text(
                                getfcrCalculationHistory[index]
                                    .fcr
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: getfcrCalculationHistory[index].fcr <
                                            1.5
                                        ? Colors.green
                                        : getfcrCalculationHistory[index].fcr >
                                                1.6
                                            ? Colors.red
                                            : Colors.amber),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: getfcrCalculationHistory.length,
            ),
          ),
        ));
  }
}
