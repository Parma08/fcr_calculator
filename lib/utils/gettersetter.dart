import 'package:fcr_calculator/modals/data_modal.dart';

List<CalculationDisplayModal> calculationHistory = [];

void setCalculationHistory(CalculationDisplayModal calculatedData) {
  calculationHistory.add(calculatedData);
}

List<CalculationDisplayModal> get getCalculationHistory {
  return calculationHistory;
}
