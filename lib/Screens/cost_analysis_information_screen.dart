import 'package:fcr_calculator/Screens/pdf_generator.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';

import '../table_display.dart';

class CostAnalysisInformationScreen extends StatelessWidget {
  EffectiveBirdCostModal calculationDisplayInformation;
  CostAnalysisInformationScreen({required this.calculationDisplayInformation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final confirmationData = await showDeleteConfirmationModal(
                  context,
                  'Are you sure you want to delete?',
                );
                if (confirmationData == 'delete') {
                  var status = await deleteCostAnalysisEntryFromDatabase(
                      calculationDisplayInformation.id);
                  if (status == 'success') {
                    getCostAnalysisHistory.removeWhere((element) =>
                        element.id == calculationDisplayInformation.id);
                    Navigator.of(context).pop();
                  } else {
                    showErrorDialog(context, status);
                  }
                }
              },
              icon: Icon(Icons.delete_forever)),
          IconButton(
              onPressed: () {
                generateCostAnalysisPDF(calculationDisplayInformation);
              },
              icon: Icon(Icons.picture_as_pdf_rounded))
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height -
            (AppBar().preferredSize.height +
                MediaQuery.of(context).padding.top),
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            TableDisplayCostAnalysis(
                calculationData: calculationDisplayInformation,
                saveDataEnabled: false),
          ],
        ),
      ),
    );
  }
}
