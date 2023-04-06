import 'package:fcr_calculator/Screens/information_screen.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                })).then((value) {
                  setState(() {
                    print('Set State');
                  });
                });
              },
              child: Stack(
                children: [
                  Container(
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
                                      getCalculationHistory[index]
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
                                      getCalculationHistory[index]
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
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    '${getCalculationHistory[index].inputs.farmerName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                                Text(
                                  '${getCalculationHistory[index].inputs.feedName}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black, width: 1)),
                              child: Text(
                                getCalculationHistory[index]
                                    .fcr
                                    .toStringAsFixed(2),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: getCalculationHistory[index].fcr <
                                            1.5
                                        ? Colors.green
                                        : getCalculationHistory[index].fcr > 1.6
                                            ? Colors.red
                                            : Colors.amber),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          itemCount: getCalculationHistory.length,
        ),
      ),
    );
  }
}
