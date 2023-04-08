class CalculationDisplayModal {
  String id;
  FCRInputsModal inputs;
  double averageWeight;
  double livability;
  double mortality;
  double fcr;
  double cfcr;
  double mortalityCount;
  int age;
  double idealFeedConsumption;
  double feedDifference;

  CalculationDisplayModal(
      {required this.id,
      required this.inputs,
      required this.averageWeight,
      required this.livability,
      required this.mortality,
      required this.fcr,
      required this.cfcr,
      required this.mortalityCount,
      required this.age,
      required this.idealFeedConsumption,
      required this.feedDifference}) {}
}

class FCRInputsModal {
  double totalSoldWeight;
  int totalSoldBird;
  int totalPlacedChicks;
  double totalFeedConsumed;
  String? farmerName;
  String? feedName;
  DateTime chickPlacementDate;
  DateTime chickSellDate;
  double expectedFCR;

  FCRInputsModal(
      {required this.totalSoldWeight,
      required this.totalSoldBird,
      required this.totalPlacedChicks,
      required this.totalFeedConsumed,
      this.farmerName,
      this.feedName,
      required this.chickPlacementDate,
      required this.expectedFCR,
      required this.chickSellDate});
}

class UserModal {
  String userName;
  String userId;

  UserModal({required this.userName, required this.userId});
}

class EffecitiveBirdCostInputsModal {
  double totalFeedConsumed;
  double ratePerBag;
  double chickCost;
  double totalBirdsSold;
  double medicineCost;
  double labourCost;
  double farmExpenses;
  double farmerCommission;

  EffecitiveBirdCostInputsModal({
    required this.totalFeedConsumed,
    required this.ratePerBag,
    required this.chickCost,
    required this.totalBirdsSold,
    required this.medicineCost,
    required this.labourCost,
    required this.farmExpenses,
    required this.farmerCommission,
  });
}

class EffectiveBirdCostModal {
  EffecitiveBirdCostInputsModal inputs;
  String id;
  double feedExpenses;
  double birdExpenses;
  double totalComission;
  double totalExpenses;
  double effectivePerBirdCost;
  double totalBagsConsumed;
  // double profitLoss;
  double otherExpenses;

  EffectiveBirdCostModal({
    required this.id,
    required this.inputs,
    required this.totalBagsConsumed,
    required this.feedExpenses,
    required this.birdExpenses,
    required this.totalComission,
    required this.otherExpenses,
    required this.totalExpenses,
    required this.effectivePerBirdCost,
    // required this.profitLoss,
  });
}
