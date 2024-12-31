import 'package:fcr_calculator/services/firebase_service_counter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CounterRecordDeleteForAParticularDate extends StatefulWidget {
  const CounterRecordDeleteForAParticularDate({super.key});

  @override
  State<CounterRecordDeleteForAParticularDate> createState() =>
      _CounterRecordDeleteForAParticularDateState();
}

class _CounterRecordDeleteForAParticularDateState
    extends State<CounterRecordDeleteForAParticularDate> {
  DateTime selectedDate = DateTime.now().subtract(const Duration(days: 1));
  @override
  void initState() {
    selectedDate = DateTime.now().subtract(const Duration(days: 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Delete record for a particular date",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040));
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: Text(
                DateFormat('dd-MM-yyy').format(selectedDate),
                style: const TextStyle(fontSize: 18),
              )),
          GestureDetector(
            onTap: () async {
              String deletionConfirmation = await showDeleteConfirmationModal(
                  context,
                  "Are you sure you want to delete ALL entries for ${DateFormat("dd-MM-yyyy").format(selectedDate)}");
              if (deletionConfirmation == 'delete') {
                showLoader(context);
                String status = await deleteAllCounterTransactionForADateFromDB(
                    selectedDate);
                if (status == 'success') {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                  showSuccessDialog(context,
                      "All the data for the selected date has been deleted");
                } else {
                  Navigator.of(context).pop();
                  showErrorDialog(context, status);
                }
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
                    'Delete entry for selected date',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
