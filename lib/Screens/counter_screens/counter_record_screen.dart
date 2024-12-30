import 'package:fcr_calculator/Screens/counter_screens/counter_record_modal_sheet_ui.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service_counter.dart';
import 'package:fcr_calculator/table_display.dart';
import 'package:fcr_calculator/utils/counter_gettersetter.dart';
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
  String selectedState = 'buy';
  List<CounterTransactionDataModal> filterCounterTransactions() {
    List<CounterTransactionDataModal> filteredTransactions = [];
    for (var element in getCounterTransactions()) {
      if (selectedState == 'buy') {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(getCounterName()),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        backgroundColor: Colors.blue,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.price_change_rounded),
            label: 'Sell',
            onTap: () async {
              var newDataAdded = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return CounterRecordModalSheetUI(
                      counterTransactionType: CounterTransactionType.sell,
                    );
                  });
              if (newDataAdded) {
                showLoader(context);
                selectedDate = DateTime.now();
                String status =
                    await getTransactionsDetailsFromDB(selectedDate);
                Navigator.of(context).pop();
                if (status != 'success') {
                  showErrorDialog(context, status);
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
                      counterTransactionType: CounterTransactionType.buy,
                    );
                  });
              if (newDataAdded) {
                showLoader(context);
                selectedDate = DateTime.now();
                String status =
                    await getTransactionsDetailsFromDB(selectedDate);
                Navigator.of(context).pop();
                if (status != 'success') {
                  showErrorDialog(context, status);
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
                          selectedState = 'sell';
                        });
                      },
                      child: Text(
                        "Sell",
                        style: TextStyle(
                            fontSize: 18,
                            color: selectedState == 'sell'
                                ? Colors.blueGrey
                                : Colors.blueAccent,
                            fontWeight: selectedState == 'sell'
                                ? FontWeight.bold
                                : FontWeight.normal),
                      )),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          selectedState = 'buy';
                        });
                      },
                      child: Text("Buy",
                          style: TextStyle(
                              fontSize: 18,
                              color: selectedState == 'buy'
                                  ? Colors.blueGrey
                                  : Colors.blueAccent,
                              fontWeight: selectedState == 'buy'
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
