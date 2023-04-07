import 'package:flutter/material.dart';

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
