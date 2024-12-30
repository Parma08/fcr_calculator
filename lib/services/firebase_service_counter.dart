import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:fcr_calculator/utils/counter_gettersetter.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:intl/intl.dart';

var mainPath = FirebaseFirestore.instance.collection('counter_users');

Future<bool> checkIsCounterUser() async {
  try {
    var counterUsers = await mainPath.get();
    for (var user in counterUsers.docs) {
      if (user.id == getUserId()) {
        setCounterUser(true);
        return true;
      }
    }
    setCounterUser(false);
    return false;
  } on FirebaseException catch (e) {
    print("ERROR ---> ${e.message}");
    rethrow;
  }
}

Future<String> initializeCounterDataFromDB() async {
  var status = await getCounterDetailsFromDB();
  if (status == 'success') {
    status = await getTransactionsDetailsFromDB(DateTime.now());
  }
  return status;
}

Future<String> getCounterDetailsFromDB() async {
  try {
    await mainPath.doc(getUserId()).get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map counterDetails = snapshot.data() as Map;
        setCounterName(counterDetails['name']);
      }
    });
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }
  return 'success';
}

Future<String> getTransactionsDetailsFromDB(DateTime date) async {
  try {
    String formattedDate = getFormattedDateForCounterData(date);
    await mainPath
        .doc(getUserId())
        .collection(formattedDate)
        .get()
        .then((QuerySnapshot querySnapshot) {
      List<CounterTransactionDataModal> transactions = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map documentData = documentSnapshot.data() as Map;

        String id = documentSnapshot.id;
        String chickenType = documentData['chickenType'];
        double weight = documentData['weight'];
        String transactionType = documentData["transactionType"] ?? 'buy';
        double price = documentData['price'];
        int pieces = documentData['pieces'];
        String narration = documentData["narration"] ?? '';

        transactions.add(CounterTransactionDataModal(
            narration: narration,
            id: id,
            price: price,
            pieces: pieces,
            weight: weight,
            chickenType: ChickenTypeStringToEnumConvertor(chickenType),
            counterTransactionType:
                CounterTransactionTypeStringToEnumConvertor(transactionType)));
      }
      setCounterTransactions(transactions);
    });
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }
  return 'success';
}

Future<String> storeTransactionToDB(
    DateTime date, CounterTransactionDataModal transactionDataModal) async {
  String formattedDate = getFormattedDateForCounterData(date);
  try {
    await mainPath
        .doc(getUserId())
        .collection(formattedDate)
        .doc(transactionDataModal.id)
        .set(getCounterTransactionsDetailsInJSON(transactionDataModal));
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }
  return 'success';
}

Future<String> deleteCounterTransactionFromDB(
    DateTime date, CounterTransactionDataModal transactionDataModal) async {
  String formattedDate = getFormattedDateForCounterData(date);
  try {
    await mainPath
        .doc(getUserId())
        .collection(formattedDate)
        .doc(transactionDataModal.id)
        .delete();
  } on FirebaseException catch (e) {
    print('ERROR - ${e.message}');
    return e.message.toString();
  }
  return 'success';
}
