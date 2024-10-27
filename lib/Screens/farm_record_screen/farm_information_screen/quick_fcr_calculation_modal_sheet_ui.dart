import 'package:flutter/material.dart';

class QuickFCRCalculationModalSheetUI extends StatefulWidget {
  int totalNumberOfBirds;
  double totalFeedConsumption;
  QuickFCRCalculationModalSheetUI(
      {super.key,
      required this.totalFeedConsumption,
      required this.totalNumberOfBirds});

  @override
  State<QuickFCRCalculationModalSheetUI> createState() =>
      _QuickFCRCalculationModalSheetUIState();
}

class _QuickFCRCalculationModalSheetUIState
    extends State<QuickFCRCalculationModalSheetUI> {
  TextEditingController avgWeightTextEditingController =
      TextEditingController();
  double computedFCR = 0;

  Widget labelFieldsBuilder(
      TextEditingController controller, String labelName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            labelName,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 50,
            width: 130,
            decoration: BoxDecoration(
                color: const Color(0xFFE4E4E4),
                borderRadius: BorderRadius.circular(10)),
            child: TextField(
              style: Theme.of(context).textTheme.labelMedium,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: controller,
              keyboardType: TextInputType.number,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    avgWeightTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          labelFieldsBuilder(
              avgWeightTextEditingController, "Average weight (in Kgs)"),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              if (avgWeightTextEditingController.text.isNotEmpty &&
                  num.tryParse(avgWeightTextEditingController.text) != null) {
                FocusScope.of(context).unfocus();

                // (totalConsumedFeed / totalSoldWeight);
                double totalBirdWeight = widget.totalNumberOfBirds *
                    double.parse(avgWeightTextEditingController.text);
                computedFCR = widget.totalFeedConsumption / totalBirdWeight;
                setState(() {});
              }
            },
            child: Center(
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(100)),
                  child: const Text(
                    'Calculate FCR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          computedFCR == 0
              ? const SizedBox()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(border: Border.all(width: 1)),
                  child: Text(
                    computedFCR.toStringAsFixed(2),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
