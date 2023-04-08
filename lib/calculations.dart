import 'package:fcr_calculator/modals/data_modal.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

double calculateAverageWeight(double totalSoldWeight, int totalSoldBirds) {
  print(totalSoldWeight);
  print(totalSoldBirds);
  double averageWeight = totalSoldWeight / totalSoldBirds;
  return averageWeight;
}

double calculateLivabilityPercentage(int totalSoldBirds, int placedChicks) {
  double livability = (totalSoldBirds / placedChicks) * 100;
  return livability;
}

double calculateMortalityPercentage(int totalSoldBirds, int placedChicks) {
  double mortality = 100 - ((totalSoldBirds / placedChicks) * 100);
  return mortality;
}

double calculateFCR(double totalConsumedFeed, double totalSoldWeight) {
  double fcr = (totalConsumedFeed / totalSoldWeight);
  return fcr;
}

double calculateCFCR(double averageWeight, double fcr) {
  double cFCR = (((2 - averageWeight) * 0.25) + fcr);
  return cFCR;
}

double calculateIdealFeedConsumption(
    double expectedFCR, double totalSoldWeight) {
  return expectedFCR * totalSoldWeight;
}

double calculateFeedDifference(
    double expectedFCR, double totalSoldWeight, double totalConsumedFeed) {
  double feedDifference = totalConsumedFeed - (expectedFCR * totalSoldWeight);
  return feedDifference;
}

String numberInputValidation(
    {required TextEditingController totalSoldWeight,
    required TextEditingController totalSoldBird,
    required TextEditingController totalPlacedChicks,
    required TextEditingController totalFeedConsumed,
    required TextEditingController expectedFCR}) {
  if (totalSoldWeight.text.isEmpty ||
      totalSoldBird.text.isEmpty ||
      totalPlacedChicks.text.isEmpty ||
      totalFeedConsumed.text.isEmpty ||
      expectedFCR.text.isEmpty) {
    return 'Kuch chuut gaya h shayad';
  }
  if ((num.tryParse(totalSoldWeight.text) == null) ||
      (num.tryParse(totalSoldBird.text) == null) ||
      (num.tryParse(totalPlacedChicks.text) == null) ||
      (num.tryParse(totalFeedConsumed.text) == null) ||
      num.tryParse(expectedFCR.text) == null) {
    return 'Kahi number galat hai';
  } else if (num.parse(totalSoldWeight.text) < 0 ||
      num.parse(totalSoldBird.text) < 0 ||
      num.parse(totalPlacedChicks.text) < 0 ||
      num.parse(totalFeedConsumed.text) < 0 ||
      num.parse(expectedFCR.text) < 0) {
    return 'Value negative nahi ho sakta';
  }
  return 'success';
}

EffectiveBirdCostModal calculateEffectiveBirdCost(
  EffecitiveBirdCostInputsModal inputs,
) {
  double totalBagsConsumed = inputs.totalFeedConsumed / 50;
  double totalBirdCost = inputs.chickCost * inputs.totalBirdsSold;
  double totalFeedCost = inputs.ratePerBag * totalBagsConsumed;
  double totalCommision = inputs.farmerCommission * inputs.totalBirdsSold;
  double otherExpenses =
      inputs.medicineCost + inputs.labourCost + inputs.farmExpenses;
  double totalExpenses =
      totalFeedCost + totalBirdCost + otherExpenses + totalCommision;

  double costPerBird = totalExpenses / inputs.totalBirdsSold;
  EffectiveBirdCostModal effectiveCost = EffectiveBirdCostModal(
      inputs: inputs,
      id: Uuid().v1(),
      totalBagsConsumed: totalBagsConsumed,
      feedExpenses: totalFeedCost,
      birdExpenses: totalBirdCost,
      totalComission: totalCommision,
      otherExpenses: otherExpenses,
      totalExpenses: totalExpenses,
      effectivePerBirdCost: costPerBird);
  return effectiveCost;
}

String CostAnalysisnumberInputValidation({
  required TextEditingController totalFeedConsumed,
  required TextEditingController bagRate,
  required TextEditingController chicksCost,
  required TextEditingController totalBirdsSold,
  required TextEditingController medicineCost,
  required TextEditingController labourCost,
  required TextEditingController farmExpenses,
  required TextEditingController farmerCommision,
}) {
  if (totalFeedConsumed.text.isEmpty ||
      bagRate.text.isEmpty ||
      chicksCost.text.isEmpty ||
      totalBirdsSold.text.isEmpty ||
      medicineCost.text.isEmpty ||
      labourCost.text.isEmpty ||
      farmExpenses.text.isEmpty ||
      farmerCommision.text.isEmpty) {
    return 'Kuch chuut gaya h shayad';
  }
  if ((num.tryParse(totalFeedConsumed.text) == null) ||
      (num.tryParse(bagRate.text) == null) ||
      (num.tryParse(chicksCost.text) == null) ||
      (num.tryParse(totalBirdsSold.text) == null) ||
      num.tryParse(medicineCost.text) == null ||
      num.tryParse(labourCost.text) == null ||
      num.tryParse(farmExpenses.text) == null ||
      num.tryParse(farmerCommision.text) == null) {
    return 'Kahi number galat hai';
  } else if ((num.parse(totalFeedConsumed.text) < 0) ||
      (num.parse(bagRate.text) < 0) ||
      (num.parse(chicksCost.text) < 0) ||
      (num.parse(totalBirdsSold.text) < 0) ||
      num.parse(medicineCost.text) < 0 ||
      num.parse(labourCost.text) < 0 ||
      num.parse(farmExpenses.text) < 0 ||
      num.parse(farmerCommision.text) < 0) {
    return 'Value negative nahi ho sakta';
  }
  return 'success';
}
