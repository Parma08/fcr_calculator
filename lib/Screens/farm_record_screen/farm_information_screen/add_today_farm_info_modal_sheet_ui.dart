import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTodayFarmInfoMoodalSheetUI extends StatefulWidget {
  TextEditingController dateController;
  TextEditingController mortalityController;
  TextEditingController feedConsumedController;
  TextEditingController additionalFeedController;
  TextEditingController totalChicksSoldWeightController;
  TextEditingController totalChicksSoldPiecesController;
  FarmRecordModal farmRecord;
  AddTodayFarmInfoMoodalSheetUI(
      {super.key,
      required this.farmRecord,
      required this.dateController,
      required this.mortalityController,
      required this.feedConsumedController,
      required this.additionalFeedController,
      required this.totalChicksSoldWeightController,
      required this.totalChicksSoldPiecesController});

  @override
  State<AddTodayFarmInfoMoodalSheetUI> createState() =>
      _AddTodayFarmInfoMoodalSheetUIState();
}

class _AddTodayFarmInfoMoodalSheetUIState
    extends State<AddTodayFarmInfoMoodalSheetUI> {
  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();

    widget.additionalFeedController.text = '0';
    widget.totalChicksSoldPiecesController.text = '0';
    widget.totalChicksSoldWeightController.text = '0';
    widget.dateController.text = DateFormat.yMMMd().format(DateTime.now());
    widget.feedConsumedController.text = '';
    widget.mortalityController.text = '';
    preFillFieldsIfRecordExistsForTheSelectedDate();
  }

  openDatePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2040));
    if (date != null) {
      selectedDate = date;
      setState(() {
        preFillFieldsIfRecordExistsForTheSelectedDate();
      });
    }
  }

  void preFillFieldsIfRecordExistsForTheSelectedDate() {
    widget.dateController.text = DateFormat.yMMMd().format(selectedDate);
    widget.additionalFeedController.text = '0';
    widget.totalChicksSoldPiecesController.text = '0';
    widget.totalChicksSoldWeightController.text = '0';
    widget.feedConsumedController.text = '';
    widget.mortalityController.text = '';
    for (var i = 0; i < widget.farmRecord.farmInformation.length; i++) {
      var info = widget.farmRecord.farmInformation;
      if (info[i].date.day == selectedDate.day &&
          info[i].date.month == selectedDate.month &&
          info[i].date.year == selectedDate.year) {
        widget.mortalityController.text = info[i].mortality.toString();
        widget.feedConsumedController.text = info[i].feedIntake.toString();
        widget.additionalFeedController.text =
            info[i].additionalFeed.toString();
        widget.totalChicksSoldPiecesController.text =
            info[i].totalChicksSoldPieces.toString();
        widget.totalChicksSoldWeightController.text =
            info[i].totalChicksSoldWeight.toString();
        break;
      }
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
          Container(
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
              readOnly: inputType == TextInputType.datetime ? true : false,
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
    if (widget.dateController.text.isEmpty ||
        widget.mortalityController.text.isEmpty ||
        widget.feedConsumedController.text.isEmpty ||
        widget.additionalFeedController.text.isEmpty ||
        widget.totalChicksSoldPiecesController.text.isEmpty ||
        widget.totalChicksSoldWeightController.text.isEmpty) {
      return false;
    }
    if ((num.tryParse(widget.mortalityController.text) == null) ||
        (num.tryParse(widget.feedConsumedController.text) == null) ||
        (num.tryParse(widget.additionalFeedController.text) == null) ||
        (num.tryParse(widget.totalChicksSoldPiecesController.text) == null) ||
        (num.tryParse(widget.totalChicksSoldWeightController.text) == null)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(widget.dateController, "Date",
              inputType: TextInputType.datetime),
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(
              widget.feedConsumedController, "Total Feed (In Kgs)"),
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(widget.mortalityController, "Mortality (In Pcs)"),
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(
            widget.additionalFeedController,
            "New Feed (in Kgs)",
          ),
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(
            widget.totalChicksSoldPiecesController,
            "Chicks Sold (in Pcs)",
          ),
          const SizedBox(
            height: 10,
          ),
          labelFieldsBuilder(
            widget.totalChicksSoldWeightController,
            "Chicks Sold (in Kgs)",
          ),
          const SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () async {
              if (!checkIfInputsAreCorrect()) {
                showErrorDialog(context, "Please enter the inputs correctly");
                return;
              }
              for (var i = 0;
                  i < widget.farmRecord.farmInformation.length;
                  i++) {
                var info = widget.farmRecord.farmInformation;
                if (info[i].date.day == selectedDate.day &&
                    info[i].date.month == selectedDate.month &&
                    info[i].date.year == selectedDate.year) {
                  final confirmationData = await showDeleteConfirmationModal(
                      context,
                      "Data for this date already exists. Do you want to delete that and use this data instead?");
                  if (confirmationData != "delete") {
                    return;
                  }
                  widget.farmRecord.farmInformation.removeAt(i);
                  break;
                }
              }
              showLoader(context);

              widget.farmRecord.farmInformation.add(FarmInformationModal(
                  date: selectedDate,
                  additionalFeed:
                      double.parse(widget.additionalFeedController.text),
                  feedIntake: double.parse(widget.feedConsumedController.text),
                  mortality: int.parse(widget.mortalityController.text),
                  totalChicksSoldPieces:
                      int.parse(widget.totalChicksSoldPiecesController.text),
                  totalChicksSoldWeight: double.parse(
                      widget.totalChicksSoldWeightController.text)));

              String status =
                  await addInfoToExistingFarmRecord(widget.farmRecord);
              if (status == 'success') {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showSuccessDialog(
                    context, 'New Farm Record added successfully');
              } else {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                showErrorDialog(context, "Something went wrong");
              }
              widget.additionalFeedController.text = '0';
              widget.totalChicksSoldPiecesController.text = '0';
              widget.totalChicksSoldWeightController.text = '0';
              widget.dateController.text =
                  DateFormat.yMMMd().format(DateTime.now());
              widget.feedConsumedController.text = '';
              widget.mortalityController.text = '';
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
                    'Create New Entry',
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
