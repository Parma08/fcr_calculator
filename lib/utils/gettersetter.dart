import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:flutter/material.dart';

List<CalculationDisplayModal> calculationHistory = [];
double fontSize = 0;

void setFontSize(BuildContext context) {
  final mediaQuery = MediaQuery.of(context);
  final textScaleFactor = mediaQuery.textScaleFactor;
  final screenWidth = mediaQuery.size.width;
  final screenHeight = mediaQuery.size.height;
  final smallestDimension =
      screenWidth > screenHeight ? screenHeight : screenWidth;
  fontSize = smallestDimension * 0.035 * textScaleFactor;
}

double get getFontSize {
  return fontSize;
}

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
        Timestamp.fromDate(calculationDisplayModal.inputs.chickSellDate),
    'expectedFCR': calculationDisplayModal.inputs.expectedFCR
  };
}

List<CalculationDisplayModal> get getCalculationHistory {
  return calculationHistory;
}

String getQuickInfo(String item) {
  switch (item) {
    case 'Total Sold Weight(KG)':
      return 'Please enter the total amount of chicken you have sold (in Kilo Grams)';
    case 'Total Sold Bird(Pcs)':
      return 'Please enter the total number of birds you have sold (in Pieces)';
    case 'Total Placed Chicks(Pcs)':
      return 'Please enter the total number of chicks you had placed in your farm (in Pieces)';
    case 'Total Feed Consumed(KG)':
      return 'Please enter the total amount of feed(food) your birds have consumed (in Kilo Grams)';
    case 'Expected FCR':
      return '"Enter your expected FCR (typical good range is between 1.5-1.6), We use it to calculate the feed difference. A negative feed difference means more profits for you, while a positive feed difference means less profits';
    default:
      return '.';
  }
}
