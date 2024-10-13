import 'package:fcr_calculator/Screens/farm_record_screen/farm_information_screen/add_today_farm_info_modal_sheet_ui.dart';
import 'package:fcr_calculator/Screens/farm_record_screen/farm_information_screen/quick_fcr_calculation_modal_sheet_ui.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service.dart';
import 'package:fcr_calculator/table_display.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmInformationScreen extends StatefulWidget {
  FarmRecordModal farmRecord;
  FarmInformationScreen({super.key, required this.farmRecord});

  @override
  State<FarmInformationScreen> createState() => _FarmInformationScreenState();
}

class _FarmInformationScreenState extends State<FarmInformationScreen> {
  int showWhichData = 0; // 0 -> Bird Data, 1 -> Feed Data, 2 -> Saled Data
  double totalFeedInStock = 0;
  double totalFeedConsumed = 0;
  int totalMortality = 0;
  int totalChicksSoldPieces = 0;
  double totalChicksSoldWeight = 0;
  TextEditingController mortalityController = TextEditingController();
  TextEditingController additionalFeedController =
      TextEditingController(text: '0');
  TextEditingController dateController =
      TextEditingController(text: DateFormat.yMMMd().format(DateTime.now()));
  TextEditingController feedConsumedController = TextEditingController();
  TextEditingController totalChicksSoldWeightController =
      TextEditingController(text: '0');
  TextEditingController totalChicksSoldPiecesController =
      TextEditingController(text: '0');
  @override
  void initState() {
    doFarmDataCalculations();
    widget.farmRecord.farmInformation.sort((a, b) => a.date.compareTo(b.date));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    mortalityController.dispose();
    additionalFeedController.dispose();
    feedConsumedController.dispose();
    dateController.dispose();
    totalChicksSoldPiecesController.dispose();
    totalChicksSoldWeightController.dispose();
  }

  Widget topInfoTileBuilder(String keyName, String keyValue,
      {Color color = Colors.black}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyName,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            width: 30,
          ),
          Text(
            keyValue,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color),
          )
        ],
      ),
    );
  }

  void doFarmDataCalculations() {
    double totalFeed = 0;
    totalFeedConsumed = 0;
    totalMortality = 0;
    totalChicksSoldPieces = 0;
    totalChicksSoldWeight = 0;

    for (var i = 0; i < widget.farmRecord.farmInformation.length; i++) {
      var info = widget.farmRecord.farmInformation[i];
      totalFeed = totalFeed + info.additionalFeed;
      totalFeedConsumed = totalFeedConsumed + info.feedIntake;
      totalMortality = totalMortality + info.mortality;
      totalChicksSoldWeight =
          totalChicksSoldWeight + info.totalChicksSoldWeight;
      totalChicksSoldPieces =
          totalChicksSoldPieces + info.totalChicksSoldPieces;
    }
    totalFeedInStock = totalFeed - totalFeedConsumed;
  }

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
            onPressed: () async {
              await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (ctx) {
                    return AddTodayFarmInfoMoodalSheetUI(
                      farmRecord: widget.farmRecord,
                      dateController: dateController,
                      feedConsumedController: feedConsumedController,
                      additionalFeedController: additionalFeedController,
                      mortalityController: mortalityController,
                      totalChicksSoldPiecesController:
                          totalChicksSoldPiecesController,
                      totalChicksSoldWeightController:
                          totalChicksSoldWeightController,
                    );
                  });
              setState(() {
                widget.farmRecord.farmInformation
                    .sort((a, b) => a.date.compareTo(b.date));

                doFarmDataCalculations();
              });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return QuickFCRCalculationModalSheetUI(
                          totalFeedConsumption: totalFeedConsumed,
                          totalNumberOfBirds:
                              (widget.farmRecord.totalChicksPlaced -
                                  totalChicksSoldPieces));
                    });
              },
              icon: const Text(
                "FCR",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
              )),
          IconButton(
              onPressed: () async {
                final confirmationData = await showDeleteConfirmationModal(
                  context,
                  'Are you sure you want to delete?',
                );
                if (confirmationData == 'delete') {
                  var status = await deleteFarmDataRecordFromDatabase(
                      widget.farmRecord.id);
                  if (status == 'success') {
                    getFarmRecords.removeWhere(
                        (element) => element.id == widget.farmRecord.id);
                    Navigator.of(context).pop();
                  } else {
                    showErrorDialog(context, status);
                  }
                }
              },
              icon: const Icon(Icons.delete_forever))
        ],
        title: Text(widget.farmRecord.farmName),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            topInfoTileBuilder("Total Chicks Placed",
                "${widget.farmRecord.totalChicksPlaced} Pcs"),
            const Divider(),
            topInfoTileBuilder("Total Feed In Stock",
                "${totalFeedInStock.toStringAsFixed(2)} Kgs",
                color: Colors.blueAccent),
            const Divider(),
            topInfoTileBuilder("Total Feed Consumed",
                "${totalFeedConsumed.toStringAsFixed(2)} Kgs",
                color: Colors.brown),
            const Divider(),
            topInfoTileBuilder("Total Mortality", "$totalMortality Pcs",
                color: Colors.red),
            const Divider(),
            topInfoTileBuilder("Remaining Birds",
                "${widget.farmRecord.totalChicksPlaced - (totalMortality + totalChicksSoldPieces)} Pcs",
                color: Colors.green),
            const Divider(),
            topInfoTileBuilder("Total Birds Sold",
                "$totalChicksSoldPieces Pcs / ${totalChicksSoldWeight.toStringAsFixed(2)} Kgs",
                color: Colors.blueGrey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        showWhichData = 0;
                      });
                    },
                    child: Text(
                      'Bird Data',
                      style: showWhichData == 0
                          ? const TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                          : const TextStyle(),
                    )),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showWhichData = 1;
                    });
                  },
                  child: Text('Feed Data',
                      style: showWhichData == 1
                          ? const TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)
                          : const TextStyle()),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        showWhichData = 2;
                      });
                    },
                    child: Text('Sales Data',
                        style: showWhichData == 2
                            ? const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)
                            : const TextStyle()))
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.52,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.farmRecord.farmInformation.isEmpty
                        ? const Text("No data to show")
                        : showWhichData == 0
                            ? TableDisplayFarmInformation(
                                farmRecord: widget.farmRecord)
                            : showWhichData == 1
                                ? TableDisplayAdditionalFeedInfo(
                                    farmInformation:
                                        widget.farmRecord.farmInformation)
                                : TableDisplaySalesInfo(
                                    farmInformation:
                                        widget.farmRecord.farmInformation,
                                  ),
                  ],
                ),
              ),
            ),
            widget.farmRecord.farmInformation.isEmpty
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton(
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2040));
                            if (selectedDate != null) {
                              final confirmationData =
                                  await showDeleteConfirmationModal(
                                context,
                                'Are you sure you want to delete entry for \n ${DateFormat.yMMMd().format(selectedDate)}?',
                              );
                              if (confirmationData != "delete") {
                                return;
                              } else {
                                for (var i = 0;
                                    i <
                                        widget
                                            .farmRecord.farmInformation.length;
                                    i++) {
                                  var info = widget.farmRecord.farmInformation;
                                  if (info[i].date.day == selectedDate.day &&
                                      info[i].date.month ==
                                          selectedDate.month &&
                                      info[i].date.year == selectedDate.year) {
                                    widget.farmRecord.farmInformation
                                        .removeAt(i);
                                    break;
                                  }
                                }
                                showLoader(context);
                                String status =
                                    await addInfoToExistingFarmRecord(
                                        widget.farmRecord);
                                if (status == 'success') {
                                  Navigator.of(context).pop();
                                  showSuccessDialog(context,
                                      'Farm Record for \n ${DateFormat.yMMMd().format(selectedDate)}  has been deleted successfully');
                                  setState(() {});
                                } else {
                                  showErrorDialog(
                                      context, "Something went wrong");
                                }
                              }
                            }
                          },
                          child: const Text(
                            "Delete an Entry",
                            style: TextStyle(
                                color: Colors.orangeAccent,
                                fontWeight: FontWeight.w900),
                          )),
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
