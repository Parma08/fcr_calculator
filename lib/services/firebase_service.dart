import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/calculations.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:firebase_auth/firebase_auth.dart';

String userId = FirebaseAuth.instance.currentUser!.uid;
var mainPath = FirebaseFirestore.instance.collection('users').doc(userId);

Future<String> getUserDetailsFromDB() async {
  try {
    await mainPath.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map userDetails = snapshot.data() as Map;
        setUserDetails(userDetails['name'], userId);
      }
    });
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }
  return 'success';
}

Future<String> getStoredFCRDataFromDB() async {
  try {
    await mainPath
        .collection('savedFCRData')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map documentData = documentSnapshot.data() as Map;

        double totalSoldWeight = documentData['totalSoldWeight'];
        int totalSoldBird = documentData['totalSoldBird'];
        int totalPlacedChicks = documentData['totalPlacedChicks'];
        double totalFeedConsumed = documentData['totalFeedConsumed'];
        double expectedFCR = documentData['expectedFCR'];
        DateTime chickPlacementDate =
            documentData['chickenPlacementDate'].toDate();
        DateTime chickSellDate = documentData['chickenSellDate'].toDate();
        String feedName = documentData['feedName'];
        String farmerName = documentData['farmerName'];

        double averageWeight =
            calculateAverageWeight(totalSoldWeight, totalSoldBird);
        double livability =
            calculateLivabilityPercentage(totalSoldBird, totalPlacedChicks);
        double mortality =
            calculateMortalityPercentage(totalSoldBird, totalPlacedChicks);
        double fcr = calculateFCR(totalFeedConsumed, totalSoldWeight);
        double cfcr = calculateCFCR(averageWeight, fcr);
        double mortalityCount = ((totalPlacedChicks / 100) * mortality);

        int age = chickSellDate.difference(chickPlacementDate).inDays;
        double feedDifference = calculateFeedDifference(
            expectedFCR, totalSoldWeight, totalFeedConsumed);
        double idealFeedConsumption =
            calculateIdealFeedConsumption(expectedFCR, totalSoldWeight);
        setfcrCalculationHistory(CalculationDisplayModal(
            id: documentSnapshot.id,
            inputs: FCRInputsModal(
                totalSoldWeight: totalSoldWeight,
                totalSoldBird: totalSoldBird,
                totalPlacedChicks: totalPlacedChicks,
                totalFeedConsumed: totalFeedConsumed,
                chickPlacementDate: chickPlacementDate,
                chickSellDate: chickSellDate,
                farmerName: farmerName,
                expectedFCR: expectedFCR,
                feedName: feedName),
            averageWeight: averageWeight,
            age: age,
            livability: livability,
            mortality: mortality,
            fcr: fcr,
            cfcr: cfcr,
            feedDifference: feedDifference,
            idealFeedConsumption: idealFeedConsumption,
            mortalityCount: mortalityCount));
      }
    });
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }

  return 'success';
}

Future initializeDataFromDB() async {
  var status = await getUserDetailsFromDB();
  if (status == 'success') {
    status = await getStoredFCRDataFromDB();
    if (status == 'success') {
      status = await getStoredCostAnalysisDataFromDB();
    }
  }
  return status;
}

Future<String> deleteFCREntryFromDatabase(String id) async {
  try {
    await mainPath.collection('savedFCRData').doc(id).delete();
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  return 'success';
}

Future<String> getStoredCostAnalysisDataFromDB() async {
  try {
    await mainPath
        .collection('savedCostAnalysisData')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map documentData = documentSnapshot.data() as Map;

        double chickCost = documentData['chickCost'];
        double farmExpenses = documentData['farmExpenses'];
        double farmerCommision = documentData['farmerCommision'];
        double labourCost = documentData['labourCost'];
        double medicineCost = documentData['medicineCost'];
        double ratePerBag = documentData['ratePerBag'];
        double totalBirdsSold = documentData['totalBirdsSold'];
        double totalFeedConsumed = documentData['totalFeedConsumed'];
        EffectiveBirdCostModal effectiveBirdCost = calculateEffectiveBirdCost(
            EffecitiveBirdCostInputsModal(
                totalFeedConsumed: totalFeedConsumed,
                ratePerBag: ratePerBag,
                chickCost: chickCost,
                totalBirdsSold: totalBirdsSold,
                medicineCost: medicineCost,
                labourCost: labourCost,
                farmExpenses: farmExpenses,
                farmerCommission: farmerCommision));
        getCostAnalysisHistory.add(effectiveBirdCost);
      }
    });
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }

  return 'success';
}

Future<String> deleteCostAnalysisEntryFromDatabase(String id) async {
  try {
    await mainPath.collection('savedCostAnalysisData').doc(id).delete();
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  return 'success';
}
