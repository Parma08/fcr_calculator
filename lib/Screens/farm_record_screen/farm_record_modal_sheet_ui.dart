import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:fcr_calculator/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FarmRecordModalSheetUI extends StatefulWidget {
  TextEditingController farmNameController;
  TextEditingController chickPlacementDateController;
  TextEditingController totalPlacedChicksController;
  FarmRecordModalSheetUI(
      {super.key,
      required this.farmNameController,
      required this.chickPlacementDateController,
      required this.totalPlacedChicksController});

  @override
  State<FarmRecordModalSheetUI> createState() => _FarmRecordModalSheetUIState();
}

class _FarmRecordModalSheetUIState extends State<FarmRecordModalSheetUI> {
  DateTime chickPlacementDate = DateTime.now();
  Widget textFieldBuilder(TextEditingController controller, String hintText,
      {TextInputType textInputType = TextInputType.number}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 60,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
          color: const Color(0xFFE4E4E4), borderRadius: BorderRadius.circular(10)),
      child: TextField(
        style: Theme.of(context).textTheme.labelMedium,
        decoration:
            InputDecoration(border: InputBorder.none, hintText: hintText),
        controller: controller,
        keyboardType: textInputType,
      ),
    );
  }

  Widget datetimeFieldBuilder(
      String hintText, TextEditingController controller) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color(0xFFE4E4E4),
        ),
        child: TextField(
          onTap: () {
            openDatePicker(context);
          },
          readOnly: true,
          controller: controller,
          keyboardType: TextInputType.datetime,
          style: Theme.of(context).textTheme.labelMedium,
          decoration:
              InputDecoration(border: InputBorder.none, hintText: hintText),
        ),
      ),
    );
  }

  openDatePicker(BuildContext context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2040));
    if (date != null) {
      chickPlacementDate = date;
      widget.chickPlacementDateController.text =
          DateFormat.yMMMEd().format(date);
      setState(() {});
    }
  }

  bool checkIfInputsAreCorrect() {
    if (widget.farmNameController.text.isEmpty ||
        widget.chickPlacementDateController.text.isEmpty ||
        widget.totalPlacedChicksController.text.isEmpty) {
      return false;
    }
    if ((num.tryParse(widget.totalPlacedChicksController.text) == null)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            textFieldBuilder(widget.farmNameController, "Farm Name",
                textInputType: TextInputType.name),
            const SizedBox(
              height: 10,
            ),
            datetimeFieldBuilder(
                "Chick Placement Date", widget.chickPlacementDateController),
            const SizedBox(
              height: 10,
            ),
            textFieldBuilder(widget.totalPlacedChicksController,
                "Total chicks placed (In Pcs)"),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () async {
                if (!checkIfInputsAreCorrect()) {
                  showErrorDialog(context, "Please enter the inputs correctly");
                  return;
                }
                showLoader(context);
                FarmRecordModal farmRecord = FarmRecordModal(
                    id: const Uuid().v1(),
                    farmName: widget.farmNameController.text,
                    totalChicksPlaced:
                        int.parse(widget.totalPlacedChicksController.text),
                    chickPlacementDate: chickPlacementDate,
                    farmInformation: []);
                String status = await setNewFarmRecord(farmRecord);
                if (status == 'success') {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showSuccessDialog(
                      context, 'New Farm Record added successfully');
                } else {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
                widget.farmNameController.text = "";
                widget.totalPlacedChicksController.text = "";
                widget.chickPlacementDateController.text = "";
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
      ),
    );
  }
}
