import 'dart:io';
import 'dart:typed_data';

import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

final doc = Document();

void generatePDF(CalculationDisplayModal pdfInfo) async {
  doc.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Column(children: [
          Center(
              child: Text('FCR CALCULATION',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          Center(
              child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(width: 1.0),
                  children: [
                TableRow(decoration: BoxDecoration(), children: [
                  Center(child: (Text('Total Sold Weight(KG)'))),
                  Center(
                      child: (Text(pdfInfo.inputs.totalSoldWeight.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Total Sold Bird(Pcs)'))),
                  Center(child: (Text(pdfInfo.inputs.totalSoldBird.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Total Placed Chicks(Pcs)'))),
                  Center(
                      child:
                          (Text(pdfInfo.inputs.totalPlacedChicks.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Total Feed Consumed(KG)'))),
                  Center(
                      child:
                          (Text(pdfInfo.inputs.totalFeedConsumed.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Average Weight(KG)'))),
                  Center(child: (Text(pdfInfo.averageWeight.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Livability %'))),
                  Center(child: (Text(pdfInfo.livability.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Mortality %'))),
                  Center(child: (Text(pdfInfo.mortality.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Mortality Count(Pcs)'))),
                  Center(child: (Text(pdfInfo.mortalityCount.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Average Weight(KG)'))),
                  Center(child: (Text(pdfInfo.averageWeight.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('FCR'))),
                  Center(child: (Text(pdfInfo.fcr.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('CFCR'))),
                  Center(child: (Text(pdfInfo.cfcr.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Farmer Name'))),
                  Center(child: (Text(pdfInfo.inputs.farmerName.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Feed Name'))),
                  Center(child: (Text(pdfInfo.inputs.feedName.toString())))
                ]),
                TableRow(children: [
                  Center(child: (Text('Chick Placement Date'))),
                  Center(
                      child: (Text(DateFormat.yMMMEd()
                          .format(pdfInfo.inputs.chickPlacementDate))))
                ]),
                TableRow(children: [
                  Center(child: (Text('Chick Sell Date'))),
                  Center(
                      child: (Text(DateFormat.yMMMEd()
                          .format(pdfInfo.inputs.chickPlacementDate))))
                ]),
              ]))
        ]);
      }));

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/exampsdfd7678le.pdf');

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
