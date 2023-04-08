import 'package:fcr_calculator/Screens/cost_analysis_information_screen.dart';
import 'package:fcr_calculator/Screens/per_bird_cost_screen.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';

class CostAnalysisTab extends StatelessWidget {
  const CostAnalysisTab({super.key});

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
                  return PerBirdCostScreen();
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
                      return CostAnalysisInformationScreen(
                        calculationDisplayInformation:
                            getCostAnalysisHistory[index],
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
                    child: Text(getCostAnalysisHistory[index]
                        .effectivePerBirdCost
                        .toString()),
                  ),
                );
              },
              itemCount: getCostAnalysisHistory.length,
            ),
          ),
        ));
  }
}
