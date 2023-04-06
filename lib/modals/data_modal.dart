class CalculationDisplayModal {
  String id;
  InputsModal inputs;
  double averageWeight;
  double livability;
  double mortality;
  double fcr;
  double cfcr;
  double mortalityCount;

  CalculationDisplayModal({
    required this.id,
    required this.inputs,
    required this.averageWeight,
    required this.livability,
    required this.mortality,
    required this.fcr,
    required this.cfcr,
    required this.mortalityCount,
  }) {}
}

class InputsModal {
  double totalSoldWeight;
  int totalSoldBird;
  int totalPlacedChicks;
  double totalFeedConsumed;
  String? farmerName;
  String? feedName;
  int? age;
  DateTime chickPlacementDate;
  DateTime chickSellDate;

  InputsModal(
      {required this.totalSoldWeight,
      required this.totalSoldBird,
      required this.totalPlacedChicks,
      required this.totalFeedConsumed,
      this.farmerName,
      this.feedName,
      this.age,
      required this.chickPlacementDate,
      required this.chickSellDate});
}
