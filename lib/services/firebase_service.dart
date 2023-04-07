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

Future<String> getStoredDataFromDB() async {
  try {
    await mainPath
        .collection('savedData')
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
        setCalculationHistory(CalculationDisplayModal(
            id: documentSnapshot.id,
            inputs: InputsModal(
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
    status = await getStoredDataFromDB();
  }
  return status;
}

Future<String> deleteEntryFromDatabase(String id) async {
  try {
    await mainPath.collection('savedData').doc(id).delete();
  } on FirebaseException catch (e) {
    return e.message.toString();
  }
  return 'success';
}
