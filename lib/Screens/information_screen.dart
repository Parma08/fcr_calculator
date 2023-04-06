import 'package:fcr_calculator/Screens/pdf_generator.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
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
              onPressed: () async {
                final confirmationData = await showDeleteConfirmationModal(
                  context,
                  'Pakka delete?',
                );
                print("VALUEEE = $confirmationData");
                if (confirmationData == 'delete') {
                  var status = await deleteEntryFromDatabase(
                      calculationDisplayInformation.id);
                  if (status == 'success') {
                    getCalculationHistory.removeWhere((element) =>
                        element.id == calculationDisplayInformation.id);
                    Navigator.of(context).pop();
                  } else {
                    showErrorDialog(context, 'Kuch galat ho gaya');
                  }
                }
              },
              icon: Icon(Icons.delete_forever)),
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
