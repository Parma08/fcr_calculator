import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:intl/intl.dart';

bool isCounterUser = false;
String counterName = "";
List<CounterTransactionDataModal> counterTransactions = [];

void resetAllCounterData() {
  isCounterUser = false;
  counterName = "";
  counterTransactions = [];
}

void setCounterUser(bool value) {
  isCounterUser = value;
}

bool isCounterTypeUser() {
  return isCounterUser;
}

void setCounterName(String name) {
  counterName = name;
}

String getCounterName() {
  return counterName;
}

void setCounterTransactions(List<CounterTransactionDataModal> transactions) {
  counterTransactions = transactions;
}

List<CounterTransactionDataModal> getCounterTransactions() {
  return counterTransactions;
}

Map<String, dynamic> getCounterTransactionsDetailsInJSON(
    CounterTransactionDataModal transaction) {
  if (transaction.narration.isEmpty) {
    return {
      'chickenType': ChickenTypeEnumToStringConvertor(transaction.chickenType),
      'transactionType': CounterTransactionTypeEnumToStringConvertor(
          transaction.counterTransactionType),
      'weight': transaction.weight,
      'pieces': transaction.pieces,
      'price': transaction.price
    };
  } else {
    return {
      'chickenType': ChickenTypeEnumToStringConvertor(transaction.chickenType),
      'transactionType': CounterTransactionTypeEnumToStringConvertor(
          transaction.counterTransactionType),
      'weight': transaction.weight,
      'pieces': transaction.pieces,
      'price': transaction.price,
      'narration': transaction.narration
    };
  }
}

String getFormattedDateForCounterData(DateTime date) {
  return DateFormat('dd-MM-yyyy').format(date);
}
