import 'package:fcr_calculator/calculations.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/table_display.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';

import '../utils/gettersetter.dart';

class PerBirdCostScreen extends StatefulWidget {
  const PerBirdCostScreen({super.key});

  @override
  State<PerBirdCostScreen> createState() => _PerBirdCostScreenState();
}

class _PerBirdCostScreenState extends State<PerBirdCostScreen> {
  final myFocusNode = FocusScopeNode();
  final scrollController = ScrollController();

  TextEditingController totalFeedConsumedController = TextEditingController();
  TextEditingController ratePerBag = TextEditingController();
  TextEditingController chickCost = TextEditingController();
  TextEditingController totalBirdsSold = TextEditingController();
  TextEditingController medicineCost = TextEditingController();
  TextEditingController labourCost = TextEditingController();
  TextEditingController farmExpenses = TextEditingController();
  TextEditingController farmercommission = TextEditingController();
  late EffectiveBirdCostModal effectiveBirdCost;
  bool showCalculation = false;
  Widget labelFieldsBuilder(
      TextEditingController controller, String labelName) {
    return Tooltip(
      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
      preferBelow: false,
      waitDuration: Duration(microseconds: 10),
      padding: EdgeInsets.all(10),
      message: getQuickInfo(labelName),
      child: Container(
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
                // readOnly: (labelName == 'Total feed consumed(KG)' ||
                //     labelName == 'Total Birds Sold'),
                style: Theme.of(context).textTheme.labelMedium,
                decoration: InputDecoration(border: InputBorder.none),
                controller: controller,
                keyboardType: TextInputType.number,
              ),
            )
          ],
        ),
      ),
    );
  }

  double stringToDoubleConvertor(String value) {
    return double.parse(value);
  }

  calculateCost() {
    var status = CostAnalysisnumberInputValidation(
        totalFeedConsumed: totalFeedConsumedController,
        bagRate: ratePerBag,
        chicksCost: chickCost,
        totalBirdsSold: totalBirdsSold,
        medicineCost: medicineCost,
        labourCost: labourCost,
        farmExpenses: farmExpenses,
        farmercommission: farmercommission);

    if (status != 'success') {
      showErrorDialog(context, status);
      return;
    }

    EffecitiveBirdCostInputsModal inputs = EffecitiveBirdCostInputsModal(
        totalFeedConsumed:
            stringToDoubleConvertor(totalFeedConsumedController.text),
        ratePerBag: stringToDoubleConvertor(ratePerBag.text),
        chickCost: stringToDoubleConvertor(chickCost.text),
        totalBirdsSold: stringToDoubleConvertor(totalBirdsSold.text),
        medicineCost: stringToDoubleConvertor(medicineCost.text),
        labourCost: stringToDoubleConvertor(labourCost.text),
        farmExpenses: stringToDoubleConvertor(farmExpenses.text),
        farmerCommission: stringToDoubleConvertor(farmercommission.text));

    setState(() {
      effectiveBirdCost = calculateEffectiveBirdCost(inputs);
      showCalculation = true;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myFocusNode.dispose();
  }

  void _scrollDown() {
    scrollController.animateTo(
      scrollController.offset + (MediaQuery.of(context).size.height * 0.5),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cost Analysis'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showInfoDialog(context,
                    'You can hold on each field to get some information about them');
              },
              icon: Icon(Icons.info_outline))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15, bottom: 5),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top),
        child: FocusScope(
          node: myFocusNode,
          child: ListView(
            controller: scrollController,
            children: [
              labelFieldsBuilder(
                  totalFeedConsumedController, 'Total Feed Consumed\n(in KG)'),
              Divider(),
              labelFieldsBuilder(ratePerBag, 'Rate of 50KG Feed Bag\n(in Rs)'),
              Divider(),
              labelFieldsBuilder(chickCost, 'Per Chick Cost\n(in Rs)'),
              Divider(),
              labelFieldsBuilder(totalBirdsSold, 'Total Birds Sold\n(in Pcs)'),
              Divider(),
              labelFieldsBuilder(medicineCost, 'Medicine Cost\n(in Rs)'),
              Divider(),
              labelFieldsBuilder(labourCost, 'Labour Cost\n(in Rs)'),
              Divider(),
              labelFieldsBuilder(farmExpenses, 'Farm Expenses\n(in Rs)'),
              Divider(),
              labelFieldsBuilder(
                  farmercommission, 'Farmer Commission \n(Per Bird)'),
              Divider(),
              GestureDetector(
                onTap: () {
                  myFocusNode.unfocus();
                  _scrollDown();
                  calculateCost();
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
                        'Calculate Cost',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                ),
              ),
              if (showCalculation)
                TableDisplayCostAnalysis(
                    calculationData: effectiveBirdCost, saveDataEnabled: true),
            ],
          ),
        ),
      ),
    );
  }
}
