
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/services/firebase_service_counter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class CounterRecordModalSheetUI extends StatefulWidget {
  CounterTransactionType counterTransactionType;
  DateTime preSelectedDate;
  CounterRecordModalSheetUI(
      {super.key,
      required this.preSelectedDate,
      required this.counterTransactionType});

  @override
  State<CounterRecordModalSheetUI> createState() =>
      _CounterRecordModalSheetUIState();
}

class _CounterRecordModalSheetUIState extends State<CounterRecordModalSheetUI> {
  late DateTime selectedDate;
  ChickenType? chickenType;

  TextEditingController dateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  TextEditingController piecesEditingController = TextEditingController();
  TextEditingController narrationController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedDate = widget.preSelectedDate;
    weightController.text = '0';
    priceEditingController.text = '0';
    piecesEditingController.text = '0';
    dateController.text = DateFormat.yMMMd().format(selectedDate);
  }

  openDatePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2040));
    if (date != null) {
      setState(() {
        selectedDate = date;
        dateController.text = DateFormat.yMMMd().format(selectedDate);
      });
    }
  }

  Widget labelFieldsBuilder(TextEditingController controller, String labelName,
      {TextInputType inputType = TextInputType.number}) {
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
          labelName == "Chicken type"
              ? DropdownButton(
                  value: chickenType,
                  items: ChickenType.values.map((e) {
                    return DropdownMenuItem(
                        value: e,
                        child: Text(ChickenTypeEnumToStringConvertor(e)));
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      chickenType = val;
                    });
                  })
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 50,
                  width: 130,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE4E4E4),
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    onTap: inputType == TextInputType.datetime
                        ? () async {
                            await openDatePicker(context);
                          }
                        : null,
                    readOnly:
                        inputType == TextInputType.datetime ? true : false,
                    style: Theme.of(context).textTheme.labelMedium,
                    decoration: const InputDecoration(border: InputBorder.none),
                    controller: controller,
                    keyboardType: inputType,
                  ),
                )
        ],
      ),
    );
  }

  bool checkIfInputsAreCorrect() {
    if (dateController.text.isEmpty ||
        weightController.text.isEmpty ||
        priceEditingController.text.isEmpty ||
        piecesEditingController.text.isEmpty ||
        chickenType == null) {
      return false;
    }
    if ((num.tryParse(weightController.text) == null) ||
        (num.tryParse(priceEditingController.text) == null) ||
        (num.tryParse(piecesEditingController.text) == null)) {
      return false;
    }
    return true;
  }

  String giveFormattedStringOfEntryForShare(
      CounterTransactionDataModal counterModal) {
    String shareString =
        "*New Entry*\n*Entry Type* - ${counterModal.counterTransactionType == CounterTransactionType.buy ? "Buy" : "Sell"}\n*Quantity* - ${counterModal.weight} Kgs | ${counterModal.pieces} Pcs\n*Type* - ${counterModal.chickenType.name.toUpperCase()}\n*Extra Information* - ${counterModal.narration}";

    return shareString;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.87,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            labelFieldsBuilder(dateController, "Date",
                inputType: TextInputType.datetime),
            const SizedBox(
              height: 10,
            ),
            labelFieldsBuilder(weightController, "Total Weight (In Kgs)"),
            const SizedBox(
              height: 10,
            ),
            labelFieldsBuilder(priceEditingController, "Price (In Rs)"),
            const SizedBox(
              height: 10,
            ),
            labelFieldsBuilder(piecesEditingController, "Quantity (In Pcs)"),
            const SizedBox(
              height: 10,
            ),
            labelFieldsBuilder(piecesEditingController, "Chicken type"),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                    border: InputBorder.none, hintText: 'Narration'),
                controller: narrationController,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                if (!checkIfInputsAreCorrect()) {
                  showErrorDialog(context, "Please enter the inputs correctly");
                  return;
                }

                showLoader(context);
                CounterTransactionDataModal counterTransactionDataModal =
                    CounterTransactionDataModal(
                        id: const Uuid().v1(),
                        narration: narrationController.text,
                        pieces: int.parse(piecesEditingController.text),
                        weight: double.parse(weightController.text),
                        chickenType: chickenType as ChickenType,
                        price: double.parse(priceEditingController.text),
                        counterTransactionType: widget.counterTransactionType ==
                                CounterTransactionType.buy
                            ? CounterTransactionType.buy
                            : CounterTransactionType.sell);
                String status = await storeTransactionToDB(
                    selectedDate, counterTransactionDataModal);

                if (status == 'success') {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                  showSuccessDialog(
                      context, 'New Farm Record added successfully');
                  Share.share(giveFormattedStringOfEntryForShare(
                      counterTransactionDataModal));
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showErrorDialog(context, "Something went wrong");
                }

                selectedDate = DateTime.now();
                weightController.text = '0';
                priceEditingController.text = '0';
                piecesEditingController.text = '0';
                dateController.text = DateFormat.yMMMd().format(selectedDate);
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
                    child: Text(
                      'Create New ${widget.counterTransactionType == CounterTransactionType.buy ? 'Buy' : 'Sell'} Entry',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
