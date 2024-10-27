import 'package:fcr_calculator/Screens/farm_record_screen/farm_information_screen/farm_information_screen.dart';
import 'package:fcr_calculator/Screens/farm_record_screen/farm_record_modal_sheet_ui.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FarmRecordScreen extends StatefulWidget {
  const FarmRecordScreen({super.key});

  @override
  State<FarmRecordScreen> createState() => _FarmRecordScreenState();
}

class _FarmRecordScreenState extends State<FarmRecordScreen> {
  // DateTime chickPlacementDate = DateTime.now();
  TextEditingController farmNameController = TextEditingController();
  TextEditingController chickPlacementDateController = TextEditingController();
  TextEditingController totalPlacedChicksController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    farmNameController.dispose();
    chickPlacementDateController.dispose();
    totalPlacedChicksController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Farm Records"),
        centerTitle: true,
        elevation: 0,
      ),
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
                    return FarmRecordModalSheetUI(
                      farmNameController: farmNameController,
                      chickPlacementDateController:
                          chickPlacementDateController,
                      totalPlacedChicksController: totalPlacedChicksController,
                    );
                  });
              setState(() {});
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height -
            (MediaQuery.of(context).padding.top +
                AppBar().preferredSize.height),
        child: getFarmRecords.isEmpty
            ? const Center(
                child: Text("No Farm Records to show"),
              )
            : LayoutBuilder(
                builder: (_, constraints) => ListView.builder(
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () async {
                        await Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return FarmInformationScreen(
                            farmRecord: getFarmRecords[index],
                          );
                        }));
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).primaryColorLight,
                                  blurRadius: 4)
                            ]),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                      DateFormat.yMMMd().format(
                                          getFarmRecords[index]
                                              .chickPlacementDate),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "(${DateTime.now().difference(getFarmRecords[index].chickPlacementDate).inDays} days)",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.teal),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: constraints.maxWidth * 0.7,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Text(
                                        getFarmRecords[index].farmName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 1)),
                                  child: Text(
                                    getFarmRecords[index]
                                        .totalChicksPlaced
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.blueGrey),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: getFarmRecords.length,
                ),
              ),
      ),
    );
  }
}
