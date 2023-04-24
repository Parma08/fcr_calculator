import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'modals/data_modal.dart';

class TableDisplayFCR extends StatelessWidget {
  CalculationDisplayModal calculationData;
  bool showFullDetails;
  bool saveDataEnabled;
  TableDisplayFCR({
    required this.calculationData,
    required this.showFullDetails,
    required this.saveDataEnabled,
  });

  // Color selectColorBasedOnLogic(String key, num value, double? expectedFCR) {
  //   switch (key) {
  //     case 'Feed Difference(KG)':
  //       if (value < 0) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     case 'FCR':
  //       if (value <= expectedFCR!) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     case 'Feed Difference(KG)':
  //       if (value <= 1.5) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     default:
  //       return Colors.black;
  //   }
  // }

  saveData(BuildContext context) async {
    showLoader(context);
    var status = await setfcrCalculationHistory(calculationData);
    if (status == 'success') {
      Navigator.of(context).pop();
      showSuccessDialog(context, 'FCR Data saved successfully');
    } else {
      Navigator.of(context).pop();
      showErrorDialog(context, status);
    }
  }

  Widget showCalculatedData(BuildContext context, String title, dynamic value) {
    List<String> units = getFCRCalucaltionUnit(title);
    return Center(
      child: Container(
        height: 40,
        decoration: (title == 'Chick Sell Date' && showFullDetails) ||
                (title == 'CFCR' && !showFullDetails)
            ? BoxDecoration(border: Border.all(width: 1, color: Colors.black))
            : BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.black),
                    left: BorderSide(width: 1, color: Colors.black),
                    right: BorderSide(width: 1, color: Colors.black))),
        width: MediaQuery.of(context).size.width * 0.95,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.5,
                decoration: BoxDecoration(
                    color: (title == 'FCR' ||
                            title == 'CFCR' ||
                            title == 'Feed Difference(KG)')
                        ? Color.fromRGBO(68, 138, 255, 0.4)
                        : Colors.white,
                    border: Border(
                        right: BorderSide(width: 1, color: Colors.black))),
                child:
                    Text(title, style: Theme.of(context).textTheme.labelMedium),
              ),
              Container(
                color: (title == 'FCR' ||
                        title == 'CFCR' ||
                        title == 'Feed Difference(KG)')
                    ? Color.fromRGBO(68, 138, 255, 0.4)
                    : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.5,
                child: Text(
                  '${units[0]} ${value} ${units[1]}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showCalculatedData(context, 'Total Sold Weight',
            calculationData.inputs.totalSoldWeight),
        showCalculatedData(
            context, 'Total Sold Bird', calculationData.inputs.totalSoldBird),
        showCalculatedData(context, 'Total Placed Chicks',
            calculationData.inputs.totalPlacedChicks),
        showCalculatedData(context, 'Total Feed Consumed',
            calculationData.inputs.totalFeedConsumed),
        showCalculatedData(context, 'Average weight',
            calculationData.averageWeight.toStringAsFixed(2)),
        showCalculatedData(context, 'Livability %',
            calculationData.livability.toStringAsFixed(2)),
        showCalculatedData(context, 'Mortality %',
            calculationData.mortality.toStringAsFixed(2)),
        showCalculatedData(
            context, 'Mortality Count', calculationData.mortalityCount.ceil()),
        showCalculatedData(context, 'Expected FCR',
            calculationData.inputs.expectedFCR.toStringAsFixed(2)),
        showCalculatedData(context, 'Ideal Feed Consumption',
            calculationData.idealFeedConsumption.toStringAsFixed(2)),
        showCalculatedData(
            context,
            'Feed Difference',
            calculationData.feedDifference <= 0
                ? calculationData.feedDifference.toStringAsFixed(2)
                : ('+' + calculationData.feedDifference.toStringAsFixed(2))),
        showCalculatedData(
            context, 'FCR', calculationData.fcr.toStringAsFixed(2)),
        showCalculatedData(
            context, 'CFCR', calculationData.cfcr.toStringAsFixed(2)),
        if (showFullDetails)
          Column(
            children: [
              showCalculatedData(
                  context, 'Farmer Name', calculationData.inputs.farmerName),
              showCalculatedData(context, 'Age', calculationData.age),
              showCalculatedData(
                  context, 'Feed Name', calculationData.inputs.feedName),
              showCalculatedData(
                  context,
                  'Chick Placement Date',
                  DateFormat.yMMMEd()
                      .format(calculationData.inputs.chickPlacementDate)),
              showCalculatedData(
                  context,
                  'Chick Sell Date',
                  DateFormat.yMMMEd()
                      .format(calculationData.inputs.chickSellDate)),
              if (saveDataEnabled && showFullDetails)
                GestureDetector(
                  onTap: () {
                    saveData(context);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class TableDisplayCostAnalysis extends StatelessWidget {
  EffectiveBirdCostModal calculationData;
  bool saveDataEnabled;
  TableDisplayCostAnalysis({
    required this.calculationData,
    required this.saveDataEnabled,
  });

  // Color selectColorBasedOnLogic(String key, num value, double? expectedFCR) {
  //   switch (key) {
  //     case 'Feed Difference(KG)':
  //       if (value < 0) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     case 'FCR':
  //       if (value <= expectedFCR!) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     case 'Feed Difference(KG)':
  //       if (value <= 1.5) {
  //         return Colors.green;
  //       } else {
  //         return Colors.red;
  //       }
  //     default:
  //       return Colors.black;
  //   }
  // }

  saveData(BuildContext context) async {
    showLoader(context);
    var status = await setCostAnalysisHistory(calculationData);
    if (status == 'success') {
      Navigator.of(context).pop();
      showSuccessDialog(context, 'Cost Analysis Data Saved Successfully');
    } else {
      Navigator.of(context).pop();
      showErrorDialog(context, status);
    }
  }

  Widget showCalculatedData(BuildContext context, String title, dynamic value) {
    List<String> prefixSufix = getCostAnalysisUnit(title);

    return Center(
      child: Container(
        height: 40,
        decoration: (title == 'Effective Bird Cost')
            ? BoxDecoration(border: Border.all(width: 1, color: Colors.black))
            : BoxDecoration(
                border: Border(
                    top: BorderSide(width: 1, color: Colors.black),
                    left: BorderSide(width: 1, color: Colors.black),
                    right: BorderSide(width: 1, color: Colors.black))),
        width: MediaQuery.of(context).size.width * 0.95,
        child: LayoutBuilder(builder: (_, constraints) {
          return Row(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 5),
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.5,
                decoration: BoxDecoration(
                    color: (title == 'FCR' ||
                            title == 'CFCR' ||
                            title == 'Feed Difference(KG)')
                        ? Color.fromRGBO(68, 138, 255, 0.4)
                        : Colors.white,
                    border: Border(
                        right: BorderSide(width: 1, color: Colors.black))),
                child:
                    Text(title, style: Theme.of(context).textTheme.labelMedium),
              ),
              Container(
                color: (title == 'Effective Bird Cost' ||
                        title == 'Total Expenses')
                    ? Color.fromRGBO(68, 138, 255, 0.4)
                    : Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                height: constraints.maxHeight,
                width: constraints.maxWidth * 0.5,
                child: Text(
                  '${prefixSufix[0]} ${value} ${prefixSufix[1]}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        showCalculatedData(context, 'Total Feed Consumed',
            calculationData.inputs.totalFeedConsumed),
        showCalculatedData(context, '50KG bag rate',
            calculationData.inputs.ratePerBag.toStringAsFixed(2)),
        showCalculatedData(context, 'Bird Cost',
            calculationData.inputs.chickCost.toStringAsFixed(2)),
        showCalculatedData(context, 'Total Birds Sold',
            calculationData.inputs.totalBirdsSold.toStringAsFixed(2)),
        showCalculatedData(context, 'Medicine Cost',
            calculationData.inputs.medicineCost.toStringAsFixed(2)),
        showCalculatedData(context, 'Labour Cost',
            calculationData.inputs.labourCost.toStringAsFixed(2)),
        showCalculatedData(
            context, 'Farm Expenses', calculationData.inputs.farmExpenses),
        showCalculatedData(context, 'Farmer Comission',
            calculationData.inputs.farmerCommission.toStringAsFixed(2)),
        showCalculatedData(context, 'Total Feed Expenses',
            calculationData.feedExpenses.toStringAsFixed(2)),
        showCalculatedData(context, 'Total Bird Expenses',
            calculationData.birdExpenses.toStringAsFixed(2)),
        showCalculatedData(context, 'Total commission ',
            calculationData.totalComission.toStringAsFixed(2)),
        showCalculatedData(context, 'Other Expenses',
            calculationData.otherExpenses.toStringAsFixed(2)),
        showCalculatedData(context, 'Total Expenses',
            calculationData.totalExpenses.toStringAsFixed(2)),
        showCalculatedData(context, 'Effective Bird Cost',
            calculationData.effectivePerBirdCost.toStringAsFixed(2)),
        if (saveDataEnabled)
          GestureDetector(
            onTap: () {
              saveData(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              alignment: Alignment.center,
              width: 80,
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                'Save',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
      ],
    );
  }
}
