import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fcr_calculator/utils/gettersetter.dart';

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
