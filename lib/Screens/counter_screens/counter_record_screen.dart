import 'package:fcr_calculator/Screens/counter_screens/counter_record_delete_for_a_date_ui.dart';
import 'package:fcr_calculator/Screens/counter_screens/counter_record_modal_sheet_ui.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service_counter.dart';
import 'package:fcr_calculator/table_display.dart';
import 'package:fcr_calculator/utils/counter_gettersetter.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

class CounterRecordScreen extends StatefulWidget {
  const CounterRecordScreen({super.key});

  @override
  State<CounterRecordScreen> createState() => _CounterRecordScreenState();
}

class _CounterRecordScreenState extends State<CounterRecordScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedCounterTransactionTypeState = 'sell';
  bool shouldShowTransactionsInfo = true;
  Map<String, num> bBoilerQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> cBoilerQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> layerQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> cockrailQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> desiQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> totalBirdsSold = {'pieces': 0, 'weight': 0};
  Map<String, num> totalBirdsBought = {'pieces': 0, 'weight': 0};
  Map<String, num> totalBirdsLeft = {'pieces': 0, 'weight': 0};
  Map<String, num> othersQuantity = {'pieces': 0, 'weight': 0};
  Map<String, num> totalBirdsRemaining = {'pieces': 0, 'weight': 0};
  Map<String, num> totalBirds = {'pieces': 0, 'weight': 0};

  @override
  void initState() {
    computeCounterData();
    super.initState();
  }

  void resetAllCounterDataValues() {
    bBoilerQuantity = {'pieces': 0, 'weight': 0};
    cBoilerQuantity = {'pieces': 0, 'weight': 0};
    layerQuantity = {'pieces': 0, 'weight': 0};
    cockrailQuantity = {'pieces': 0, 'weight': 0};
    desiQuantity = {'pieces': 0, 'weight': 0};
    totalBirdsSold = {'pieces': 0, 'weight': 0};
    totalBirdsBought = {'pieces': 0, 'weight': 0};
    totalBirdsLeft = {'pieces': 0, 'weight': 0};
    othersQuantity = {'pieces': 0, 'weight': 0};
    totalBirdsRemaining = {'pieces': 0, 'weight': 0};
    totalBirds = {'pieces': 0, 'weight': 0};
  }

  void doCounterDataCalculations(CounterTransactionDataModal element) {
    if (element.chickenType == ChickenType.bBoiler) {
      bBoilerQuantity['pieces'] =
          (bBoilerQuantity['pieces'] ?? 0) + element.pieces;
      bBoilerQuantity['weight'] =
          (bBoilerQuantity['weight'] ?? 0) + element.weight;
    } else if (element.chickenType == ChickenType.cBoiler) {
      cBoilerQuantity['pieces'] =
          (cBoilerQuantity['pieces'] ?? 0) + element.pieces;
      cBoilerQuantity['weight'] =
          (cBoilerQuantity['weight'] ?? 0) + element.weight;
    } else if (element.chickenType == ChickenType.cockrail) {
      cockrailQuantity['pieces'] =
          (cockrailQuantity['pieces'] ?? 0) + element.pieces;
      cockrailQuantity['weight'] =
          (cockrailQuantity['weight'] ?? 0) + element.weight;
    } else if (element.chickenType == ChickenType.desi) {
      desiQuantity['pieces'] = (desiQuantity['pieces'] ?? 0) + element.pieces;
      desiQuantity['weight'] = (desiQuantity['weight'] ?? 0) + element.weight;
    } else if (element.chickenType == ChickenType.layer) {
      layerQuantity['pieces'] = (layerQuantity['pieces'] ?? 0) + element.pieces;
      layerQuantity['weight'] = (layerQuantity['weight'] ?? 0) + element.weight;
    } else if (element.chickenType == ChickenType.other) {
      othersQuantity['pieces'] =
          (othersQuantity['pieces'] ?? 0) + element.pieces;
      othersQuantity['weight'] =
          (othersQuantity['weight'] ?? 0) + element.weight;
    }
  }

  void computeCounterData() {
    resetAllCounterDataValues();

    for (var element in getCounterTransactions()) {
      if (element.counterTransactionType == CounterTransactionType.buy) {
        totalBirdsBought['pieces'] =
            (totalBirdsBought['pieces'] ?? 0) + element.pieces;
        totalBirdsBought['weight'] =
            (totalBirdsBought['weight'] ?? 0) + element.weight;
      } else if (element.counterTransactionType ==
          CounterTransactionType.sell) {
        totalBirdsSold['pieces'] =
            (totalBirdsSold['pieces'] ?? 0) + element.pieces;
        totalBirdsSold['weight'] =
            (totalBirdsSold['weight'] ?? 0) + element.weight;
      }
      if (selectedCounterTransactionTypeState == 'buy') {
        if (element.counterTransactionType == CounterTransactionType.buy) {
          doCounterDataCalculations(element);
        }
      } else if (selectedCounterTransactionTypeState == 'sell') {
        if (element.counterTransactionType == CounterTransactionType.sell) {
          doCounterDataCalculations(element);
        }
      }
    }
  }

  List<CounterTransactionDataModal> filterCounterTransactions() {
    List<CounterTransactionDataModal> filteredTransactions = [];
    for (var element in getCounterTransactions()) {
      if (selectedCounterTransactionTypeState == 'buy') {
        if (element.counterTransactionType == CounterTransactionType.buy) {
          filteredTransactions.add(element);
        }
      } else {
        if (element.counterTransactionType == CounterTransactionType.sell) {
          filteredTransactions.add(element);
        }
      }
    }
    return filteredTransactions;
  }

  Widget topInfoTileBuilder(String keyName, String keyValue,
      {Color color = Colors.brown}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(getCounterName().toUpperCase()),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        backgroundColor: Colors.blue,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.delete_forever),
            label: 'Delete',
            onTap: () async {
              var dataDeleted = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return CounterRecordDeleteForAParticularDate();
                  });
              if (dataDeleted != null) {
                showLoader(context);
                selectedDate = DateTime.now();
                String status =
                    await getTransactionsDetailsFromDB(selectedDate);
                Navigator.of(context).pop();
                if (status != 'success') {
                  showErrorDialog(context, status);
                } else {
                  computeCounterData();
                }
                setState(() {});
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.price_change_rounded),
            label: 'Sell',
            onTap: () async {
              var newDataAdded = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return CounterRecordModalSheetUI(
                      preSelectedDate: selectedDate,
                      counterTransactionType: CounterTransactionType.sell,
                    );
                  });
              if (newDataAdded != null) {
                showLoader(context);
                selectedDate = DateTime.now();
                String status =
                    await getTransactionsDetailsFromDB(selectedDate);
                Navigator.of(context).pop();
                if (status != 'success') {
                  showErrorDialog(context, status);
                } else {
                  computeCounterData();
                }
                setState(() {});
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.shopping_cart),
            label: 'Buy',
            onTap: () async {
              var newDataAdded = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return CounterRecordModalSheetUI(
                      preSelectedDate: selectedDate,
                      counterTransactionType: CounterTransactionType.buy,
                    );
                  });
              if (newDataAdded != null) {
                showLoader(context);
                selectedDate = DateTime.now();
                String status =
                    await getTransactionsDetailsFromDB(selectedDate);
                Navigator.of(context).pop();
                if (status != 'success') {
                  showErrorDialog(context, status);
                } else {
                  computeCounterData();
                }
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    shouldShowTransactionsInfo = !shouldShowTransactionsInfo;
                  });
                },
                child: !shouldShowTransactionsInfo
                    ? Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          "Show transactions Data",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      )
                    : SizedBox(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Total Birds Remaining",
                                "${(totalBirdsBought['pieces'] ?? 0) - (totalBirdsSold['pieces'] ?? 0)} Pcs | ${(totalBirdsBought['weight'] ?? 0) - (totalBirdsSold['weight'] ?? 0)} Kgs",
                                color: Colors.red),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Total Birds Sold",
                                "${totalBirdsSold['pieces']} Pcs | ${totalBirdsSold['weight']} Kgs",
                                color: Colors.green),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Total Birds Bought",
                                "${totalBirdsBought['pieces']} Pcs | ${totalBirdsBought['weight']} Kgs",
                                color: Colors.blueGrey),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("B Boiler",
                                "${bBoilerQuantity['pieces']} Pcs | ${bBoilerQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("C Boiler",
                                "${cBoilerQuantity['pieces']} Pcs | ${cBoilerQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Cockrail",
                                "${cockrailQuantity['pieces']} Pcs | ${cockrailQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Layer",
                                "${layerQuantity['pieces']} Pcs | ${layerQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Desi",
                                "${desiQuantity['pieces']} Pcs | ${desiQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                            topInfoTileBuilder("Others",
                                "${othersQuantity['pieces']} Pcs | ${othersQuantity['weight']} Kgs"),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
              ),
              Container(
                child: TextButton(
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2040));
                    if (newDate != null) {
                      showLoader(context);
                      String status =
                          await getTransactionsDetailsFromDB(newDate);
                      Navigator.of(context).pop();
                      if (status != 'success') {
                        showErrorDialog(context, status);
                      } else {
                        computeCounterData();
                      }
                      setState(() {
                        selectedDate = newDate;
                      });
                    }
                  },
                  child: Text(
                    DateFormat("dd-MM-yyy").format(selectedDate),
                    textScaleFactor: 1.5,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCounterTransactionTypeState = 'sell';
                          computeCounterData();
                        });
                      },
                      child: Text(
                        "Sell",
                        style: TextStyle(
                            fontSize: 18,
                            color: selectedCounterTransactionTypeState == 'sell'
                                ? Colors.deepPurple
                                : Colors.blueAccent,
                            fontWeight:
                                selectedCounterTransactionTypeState == 'sell'
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedCounterTransactionTypeState = 'buy';
                          computeCounterData();
                        });
                      },
                      child: Text("Buy",
                          style: TextStyle(
                              fontSize: 18,
                              color:
                                  selectedCounterTransactionTypeState == 'buy'
                                      ? Colors.deepPurple
                                      : Colors.blueAccent,
                              fontWeight:
                                  selectedCounterTransactionTypeState == 'buy'
                                      ? FontWeight.bold
                                      : FontWeight.normal)))
                ],
              ),
              TableDisplayCounterSellInfo(
                counterTransactionsData: filterCounterTransactions(),
                deleteCallback: (counterTransactionData) async {
                  String deletionCOnfirmation =
                      await showDeleteConfirmationModal(context,
                          "Are you sure you want to delete this entry?");
                  if (deletionCOnfirmation == 'delete') {
                    showLoader(context);
                    String status = await deleteCounterTransactionFromDB(
                        selectedDate, counterTransactionData);
                    if (status == 'success') {
                      status = await getTransactionsDetailsFromDB(selectedDate);
                      if (status != 'success') {
                        showErrorDialog(context, status);
                      } else {
                        computeCounterData();
                      }
                    } else {
                      showErrorDialog(context, status);
                    }
                    Navigator.of(context).pop();
                    showSuccessDialog(context, "Data deleted successfully");
                    setState(() {});
                  }
                },
              ),
              SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
