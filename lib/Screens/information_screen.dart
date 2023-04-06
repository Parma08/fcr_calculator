import 'package:fcr_calculator/Screens/pdf_generator.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';

import '../table_display.dart';

class InformationScreen extends StatelessWidget {
  CalculationDisplayModal calculationDisplayInformation;
  InformationScreen({required this.calculationDisplayInformation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                generatePDF(calculationDisplayInformation);
              },
              icon: Icon(Icons.picture_as_pdf_rounded))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: TableDisplay(
            calculationData: calculationDisplayInformation,
            showFullDetails: true,
            saveDataEnabled: false),
      ),
    );
  }
}
