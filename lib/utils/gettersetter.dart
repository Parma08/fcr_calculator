import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/modals/data_modal.dart';

List<CalculationDisplayModal> calculationHistory = [];
UserModal userDetails = UserModal(userName: '', userId: '');

void setUserDetails(String name, String id) {
  userDetails = UserModal(userName: name, userId: id);
}

UserModal get getUserDetails {
  return userDetails;
}

Future<String> setCalculationHistory(
    CalculationDisplayModal calculatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getUserDetails.userId)
        .collection('savedData')
        .doc(calculatedData.id)
        .set(getCalculatedDataInJSON(calculatedData));
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  calculationHistory.add(calculatedData);
  return 'success';
}

Map<String, dynamic> getCalculatedDataInJSON(
    CalculationDisplayModal calculationDisplayModal) {
  return {
    'totalSoldWeight': calculationDisplayModal.inputs.totalSoldWeight,
    'totalSoldBird': calculationDisplayModal.inputs.totalSoldBird,
    'totalPlacedChicks': calculationDisplayModal.inputs.totalPlacedChicks,
    'totalFeedConsumed': calculationDisplayModal.inputs.totalFeedConsumed,
    'farmerName': calculationDisplayModal.inputs.farmerName,
    'feedName': calculationDisplayModal.inputs.feedName,
    'chickenPlacementDate':
        Timestamp.fromDate(calculationDisplayModal.inputs.chickPlacementDate),
    'chickenSellDate':
        Timestamp.fromDate(calculationDisplayModal.inputs.chickSellDate)
  };
}

List<CalculationDisplayModal> get getCalculationHistory {
  return calculationHistory;
}
