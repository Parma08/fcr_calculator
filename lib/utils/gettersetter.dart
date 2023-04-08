import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:flutter/material.dart';

List<CalculationDisplayModal> fcrCalculationHistory = [];
List<EffectiveBirdCostModal> costAnalysisHistory = [];
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

Future<String> setfcrCalculationHistory(
    CalculationDisplayModal calculatedData) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getUserDetails.userId)
        .collection('savedFCRData')
        .doc(calculatedData.id)
        .set(getFCRUserInputDataInJSON(calculatedData));
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  fcrCalculationHistory.add(calculatedData);
  return 'success';
}

Map<String, dynamic> getFCRUserInputDataInJSON(
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

List<CalculationDisplayModal> get getfcrCalculationHistory {
  return fcrCalculationHistory;
}

String getQuickInfo(String item) {
  switch (item) {
    case 'Total Sold Weight\n(in KG)':
      return 'Please enter the total amount of chicken you have sold (in Kilo Grams)';
    case 'Total Sold Bird\n(in Pcs)':
      return 'Please enter the total number of birds you have sold (in Pieces)';
    case 'Total Placed Chicks\n(in Pcs)':
      return 'Please enter the total number of chicks you had placed in your farm (in Pieces)';
    case 'Total Feed Consumed\n(in KG)':
      return 'Please enter the total amount of feed(food) your birds have consumed (in Kilo Grams)';
    case 'Expected FCR':
      return 'Enter your expected FCR (typical good range is between 1.5-1.6), We use it to calculate the feed difference. A negative feed difference means more profits for you, while a positive feed difference means less profits';
    default:
      return '.';
  }
}

List<String> getCostAnalysisUnit(String title) {
  if (title == 'Total Feed Consumed') {
    return ['', 'KG'];
  } else if (title == 'Total Birds Sold') {
    return ['', 'Pcs'];
  } else if (title == 'Effective Bird Cost') {
    return ['Rs', '/bird'];
  }
  return ['Rs', '/-'];
}

List<String> getFCRCalucaltionUnit(String title) {
  if (title == 'Total Sold Bird' ||
      title == 'Total Placed Chicks' ||
      title == 'Mortality Count') {
    return ['', 'Pcs'];
  } else if (title == 'Livability %' || title == 'Mortality %') {
    return ['', '%'];
  } else if (title == 'Farmer Name' ||
      title == 'Feed Name' ||
      title == 'Chick Placement Date' ||
      title == 'Chick Sell Date' ||
      title == 'FCR' ||
      title == 'CFCR') {
    return ['', ''];
  } else if (title == 'Age') {
    return ['', 'days'];
  }
  return ['', 'Kgs'];
}

Future<String> setCostAnalysisHistory(EffectiveBirdCostModal analysis) async {
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getUserDetails.userId)
        .collection('savedCostAnalysisData')
        .doc(analysis.id)
        .set(getCostAnalysisUserInputDataInJSON(analysis.inputs));
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  costAnalysisHistory.add(analysis);
  return 'success';
}

Map<String, dynamic> getCostAnalysisUserInputDataInJSON(
    EffecitiveBirdCostInputsModal inputs) {
  return {
    'totalFeedConsumed': inputs.totalFeedConsumed,
    'ratePerBag': inputs.ratePerBag,
    'chickCost': inputs.chickCost,
    'totalBirdsSold': inputs.totalBirdsSold,
    'medicineCost': inputs.medicineCost,
    'labourCost': inputs.labourCost,
    'farmExpenses': inputs.farmExpenses,
    'farmerCommision': inputs.farmerCommission,
  };
}

List<EffectiveBirdCostModal> get getCostAnalysisHistory {
  return costAnalysisHistory;
}
