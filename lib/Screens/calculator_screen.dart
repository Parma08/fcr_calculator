import 'package:fcr_calculator/calculations.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../table_display.dart';

class CalculatorScreen extends StatefulWidget {
  bool showFullCalculator;
  CalculatorScreen({this.showFullCalculator = false});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController totalSoldWeight = TextEditingController();
  TextEditingController totalSoldBirds = TextEditingController();
  TextEditingController totalPlacedChicks = TextEditingController();

  TextEditingController totalFeedConsumed = TextEditingController();
  TextEditingController farmerName = TextEditingController();
  TextEditingController feedName = TextEditingController();
  TextEditingController chickPlacementDateController = TextEditingController();
  TextEditingController chickSellDateController = TextEditingController();

  DateTime chickPlacementDate = DateTime.now();
  DateTime chickSellDate = DateTime.now();

  double avgWeight = 0;
  double livability = 0;
  double mortality = 0;
  double fcr = 0;
  double cfcr = 0;
  bool showValues = false;
  double mortalityCount = 0;
  int age = 0;

  fieldReset() {
    totalSoldWeight = TextEditingController();
    totalSoldBirds = TextEditingController();
    totalPlacedChicks = TextEditingController();

    totalFeedConsumed = TextEditingController();
    farmerName = TextEditingController();
    feedName = TextEditingController();
    chickPlacementDateController = TextEditingController();
    chickSellDateController = TextEditingController();

    avgWeight = 0;
    livability = 0;
    mortality = 0;
    fcr = 0;
    cfcr = 0;
    showValues = false;
    mortalityCount = 0;
    age = 0;
  }

  doCalculations() {
    // if (showValues) {
    //   setState(() {
    //     fieldReset();
    //   });
    //   return;
    // }
    if (widget.showFullCalculator) {
      if (farmerName.text.isEmpty ||
          feedName.text.isEmpty ||
          chickPlacementDateController.text.isEmpty ||
          chickSellDateController.text.isEmpty) {
        showErrorDialog(context, 'Kuch chut gaya shyd');
        return;
      }
    }

    var isInputValid = numberInputValidation(
        totalSoldWeight: totalSoldWeight,
        totalSoldBird: totalSoldBirds,
        totalPlacedChicks: totalPlacedChicks,
        totalFeedConsumed: totalFeedConsumed);
    if (isInputValid != 'success') {
      showErrorDialog(context, isInputValid);
      return;
    }

    double totalSoldWeightValue = double.parse(totalSoldWeight.text);
    int totalSoldBirdValue = int.parse(totalSoldBirds.text);
    int totalPlacedChicksValue = int.parse(totalPlacedChicks.text);
    double totalFeedConsumedValue = double.parse(totalFeedConsumed.text);

    avgWeight =
        calculateAverageWeight(totalSoldWeightValue, totalSoldBirdValue);
    livability = calculateLivabilityPercentage(
        totalSoldBirdValue, totalPlacedChicksValue);
    mortality = calculateMortalityPercentage(
        totalSoldBirdValue, totalPlacedChicksValue);
    fcr = calculateFCR(totalFeedConsumedValue, totalSoldWeightValue);
    cfcr = calculateCFCR(avgWeight, fcr);

    mortalityCount = (totalPlacedChicksValue / 100) * mortality;
    age = chickSellDate.difference(chickPlacementDate).inDays;

    setState(() {
      showValues = true;
    });
  }

  Widget labelFieldsBuilder(
      TextEditingController controller, String labelName) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelName,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            width: 100,
            decoration: BoxDecoration(
                color: Color(0xFFE4E4E4),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              style: Theme.of(context).textTheme.labelMedium,
              decoration: InputDecoration(border: InputBorder.none),
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          )
        ],
      ),
    );
  }

  Widget inputTextFieldBuilder(
      String hintText, TextEditingController controller) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFE4E4E4),
        ),
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.labelMedium,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }

  Widget datetimeFieldBuilder(
      String hintText, TextEditingController controller, String type) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFFE4E4E4),
        ),
        child: TextField(
          onTap: () {
            openDatePicker(context, type);
          },
          readOnly: true,
          controller: controller,
          keyboardType: TextInputType.datetime,
          style: Theme.of(context).textTheme.labelMedium,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }

  openDatePicker(BuildContext context, String type) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2040));

    if (date != null) {
      if (type == 'placementDate') {
        chickPlacementDate = date;
        chickPlacementDateController.text = DateFormat.yMMMEd().format(date);
      } else if (type == 'sellDate') {
        chickSellDate = date;
        chickSellDateController.text = DateFormat.yMMMEd().format(date);
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Calculator'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, bottom: 5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top),
        child: ListView(
          children: [
            labelFieldsBuilder(totalSoldWeight, 'Total Sold Weight'),
            Divider(),
            labelFieldsBuilder(totalSoldBirds, 'Total Sold Bird'),
            Divider(),
            labelFieldsBuilder(totalPlacedChicks, 'Total Placed Chicks'),
            Divider(),
            labelFieldsBuilder(totalFeedConsumed, 'Total Feed Consumed'),
            Divider(),
            widget.showFullCalculator
                ? Column(
                    children: [
                      inputTextFieldBuilder('Farmer Name', farmerName),
                      Divider(),
                      inputTextFieldBuilder('Feed Name', feedName),
                      Divider(),
                      datetimeFieldBuilder('Chick Placement Date',
                          chickPlacementDateController, 'placementDate'),
                      Divider(),
                      datetimeFieldBuilder('Chick Sell Date',
                          chickSellDateController, 'sellDate'),
                    ],
                  )
                : SizedBox(),
            GestureDetector(
              onTap: () {
                doCalculations();
              },
              child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      'Calculate FCR',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            showValues
                ? TableDisplay(
                    calculationData: CalculationDisplayModal(
                        id: Uuid().v1(),
                        inputs: InputsModal(
                            totalSoldWeight: double.parse(totalSoldWeight.text),
                            totalSoldBird: int.parse(totalSoldBirds.text),
                            totalPlacedChicks:
                                int.parse(totalPlacedChicks.text),
                            totalFeedConsumed:
                                double.parse(totalFeedConsumed.text),
                            farmerName: farmerName.text,
                            feedName: feedName.text,
                            chickPlacementDate: chickPlacementDate,
                            chickSellDate: chickSellDate),
                        age: age,
                        averageWeight: avgWeight,
                        livability: livability,
                        mortality: mortality,
                        fcr: fcr,
                        cfcr: cfcr,
                        mortalityCount: mortalityCount),
                    showFullDetails: widget.showFullCalculator,
                    saveDataEnabled: true,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
