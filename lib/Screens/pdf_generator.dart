import 'dart:io';
import 'dart:typed_data';

import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

void generateFCRPDF(CalculationDisplayModal pdfInfo) async {
  final doc = Document();

  TableRow tableRowBuilder(String key, String value) {
    List<String> unit = getFCRCalucaltionUnit(key);
    return TableRow(decoration: BoxDecoration(), children: [
      Center(
          child: (Padding(
              padding: EdgeInsets.all(5),
              child: Text(key,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))),
      Center(
          child: (Padding(
              padding: EdgeInsets.all(5),
              child: Text('${unit[0]} ${value} ${unit[1]}',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))),
    ]);
  }

  doc.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Column(children: [
          Center(
              child: Text('FCR CALCULATION',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline))),
          SizedBox(height: 20),
          Center(
              child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(width: 1.0),
                  children: [
                tableRowBuilder('Total Sold Weight(KG)',
                    pdfInfo.inputs.totalSoldWeight.toStringAsFixed(2)),
                tableRowBuilder('Total Sold Bird(Pcs)',
                    pdfInfo.inputs.totalSoldBird.toString()),
                tableRowBuilder('Total Placed Chicks(Pcs)',
                    pdfInfo.inputs.totalPlacedChicks.toString()),
                tableRowBuilder('Total Feed Consumed(KG)',
                    pdfInfo.inputs.totalFeedConsumed.toStringAsFixed(2)),
                tableRowBuilder('Average Weight(KG)',
                    pdfInfo.averageWeight.toStringAsFixed(2)),
                tableRowBuilder(
                    'Livability %', pdfInfo.livability.toStringAsFixed(2)),
                tableRowBuilder(
                    'Mortality %', pdfInfo.mortality.toStringAsFixed(2)),
                tableRowBuilder('Mortality Count(Pcs)',
                    pdfInfo.mortalityCount.ceil().toString()),
                tableRowBuilder('Expected FCR',
                    pdfInfo.inputs.expectedFCR.toStringAsFixed(2)),
                tableRowBuilder('Ideal Feed Consumption(KG)',
                    pdfInfo.idealFeedConsumption.toStringAsFixed(2)),
                tableRowBuilder('Feed Difference',
                    pdfInfo.feedDifference.toStringAsFixed(2)),
                tableRowBuilder('FCR', pdfInfo.fcr.toStringAsFixed(2)),
                tableRowBuilder('CFCR', pdfInfo.cfcr.toStringAsFixed(2)),
                tableRowBuilder('Age(Days)', pdfInfo.age.toString()),
                tableRowBuilder(
                    'Farmer Name', pdfInfo.inputs.farmerName.toString()),
                tableRowBuilder(
                    'Feed Name', pdfInfo.inputs.feedName.toString()),
                tableRowBuilder(
                    'Chick Placement Date',
                    DateFormat.yMMMEd()
                        .format(pdfInfo.inputs.chickPlacementDate)),
                tableRowBuilder('Chick Sell Date',
                    DateFormat.yMMMEd().format(pdfInfo.inputs.chickSellDate)),
              ]))
        ]);
      }));

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/${Uuid().v1()}.pdf');

  // Convert the Uint8List to a List<int>
  final pdfBytes = await doc.save();
  final pdfData = Uint8List.fromList(pdfBytes);
  final pdfList = pdfData.toList();

  await file.writeAsBytes(pdfList);

  print('PDF saved to ${file.path}');

  // Share the PDF file
  Share.shareFiles(['${file.path}'], text: 'Check out this PDF!');

  // print(outputFile);
}

void generateCostAnalysisPDF(EffectiveBirdCostModal pdfInfo) async {
  final doc = Document();

  TableRow tableRowBuilder(String key, String value) {
    List<String> unit = getCostAnalysisUnit(key);
    return TableRow(decoration: BoxDecoration(), children: [
      Center(
          child: (Padding(
              padding: EdgeInsets.all(5),
              child: Text(key,
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))),
      Center(
          child: (Padding(
              padding: EdgeInsets.all(5),
              child: Text('${unit[0]} ${value} ${unit[1]}',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))),
    ]);
  }

  doc.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Column(children: [
          Center(
              child: Text('COST ANALYSIS',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      decoration: TextDecoration.underline))),
          SizedBox(height: 20),
          Center(
              child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(width: 1.0),
                  children: [
                tableRowBuilder('Total Feed Consumed(KG)',
                    pdfInfo.inputs.totalFeedConsumed.toStringAsFixed(2)),
                tableRowBuilder('50KG Bag Rate',
                    pdfInfo.inputs.ratePerBag.toStringAsFixed(2)),
                tableRowBuilder(
                    'Chicks Cost', pdfInfo.inputs.chickCost.toStringAsFixed(2)),
                tableRowBuilder('Total Sold Bird',
                    pdfInfo.inputs.totalBirdsSold.toStringAsFixed(0)),
                tableRowBuilder('Medicine Cost',
                    pdfInfo.inputs.medicineCost.toStringAsFixed(2)),
                tableRowBuilder('Labour Cost',
                    pdfInfo.inputs.labourCost.toStringAsFixed(2)),
                tableRowBuilder('Farm Expenses',
                    pdfInfo.inputs.farmExpenses.toStringAsFixed(2)),
                tableRowBuilder('Farmer Commission',
                    pdfInfo.inputs.farmerCommission.toStringAsFixed(2)),
                tableRowBuilder('Total Feed Expenses',
                    pdfInfo.feedExpenses.toStringAsFixed(2)),
                tableRowBuilder('Total Bird Expenses',
                    pdfInfo.birdExpenses.toStringAsFixed(2)),
                tableRowBuilder('Total Commission',
                    pdfInfo.totalComission.toStringAsFixed(2)),
                tableRowBuilder('Total Other Expenses',
                    pdfInfo.otherExpenses.toStringAsFixed(2)),
                tableRowBuilder(
                    'Total Expenses', pdfInfo.totalExpenses.toStringAsFixed(2)),
                tableRowBuilder('Effective Bird Cost',
                    pdfInfo.effectivePerBirdCost.toStringAsFixed(2)),
              ]))
        ]);
      }));

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/${Uuid().v1()}.pdf');

  // Convert the Uint8List to a List<int>
  final pdfBytes = await doc.save();
  final pdfData = Uint8List.fromList(pdfBytes);
  final pdfList = pdfData.toList();

  await file.writeAsBytes(pdfList);

  print('PDF saved to ${file.path}');

  // Share the PDF file
  Share.shareFiles(['${file.path}'], text: 'Check out this PDF!');

  // print(outputFile);
}
