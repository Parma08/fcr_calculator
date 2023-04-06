class CalculationDisplayModal {
  String id;
  InputsModal inputs;
  double averageWeight;
  double livability;
  double mortality;
  double fcr;
  double cfcr;
  double mortalityCount;
  int age;

  CalculationDisplayModal({
    required this.id,
    required this.inputs,
    required this.averageWeight,
    required this.livability,
    required this.mortality,
    required this.fcr,
    required this.cfcr,
    required this.mortalityCount,
    required this.age,
  }) {}
}

class InputsModal {
  double totalSoldWeight;
  int totalSoldBird;
  int totalPlacedChicks;
  double totalFeedConsumed;
  String? farmerName;
  String? feedName;
  DateTime chickPlacementDate;
  DateTime chickSellDate;

  InputsModal(
      {required this.totalSoldWeight,
      required this.totalSoldBird,
      required this.totalPlacedChicks,
      required this.totalFeedConsumed,
      this.farmerName,
      this.feedName,
      required this.chickPlacementDate,
      required this.chickSellDate});
}

class UserModal {
  String userName;
  String userId;

  UserModal({required this.userName, required this.userId});
}
