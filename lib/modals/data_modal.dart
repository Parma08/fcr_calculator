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
      required this.feedDifference});
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

class FarmRecordModal {
  String id;
  String farmName;
  int totalChicksPlaced;
  DateTime chickPlacementDate;
  List<FarmInformationModal> farmInformation;

  FarmRecordModal(
      {required this.farmName,
      required this.id,
      required this.totalChicksPlaced,
      required this.chickPlacementDate,
      required this.farmInformation});
}

class FarmInformationModal {
  DateTime date;
  double feedIntake;
  int mortality;
  double additionalFeed;
  double totalChicksSoldWeight;
  int totalChicksSoldPieces;

  FarmInformationModal(
      {required this.date,
      required this.feedIntake,
      required this.mortality,
      required this.totalChicksSoldPieces,
      required this.totalChicksSoldWeight,
      required this.additionalFeed});
}

enum CounterTransactionType {
  buy,
  sell,
  other;
}

enum ChickenType { bBoiler, cBoiler, layer, cockrail, desi, other }

ChickenType ChickenTypeStringToEnumConvertor(String type) {
  switch (type) {
    case 'B-Boiler':
      return ChickenType.bBoiler;
    case 'C-Boiler':
      return ChickenType.cBoiler;
    case 'Layer':
      return ChickenType.layer;
    case 'Cockrail':
      return ChickenType.cockrail;
    case "Desi":
      return ChickenType.desi;
    default:
      return ChickenType.other;
  }
}

String ChickenTypeEnumToStringConvertor(ChickenType type) {
  switch (type) {
    case ChickenType.bBoiler:
      return 'B-Boiler';
    case ChickenType.cBoiler:
      return 'C-Boiler';
    case ChickenType.other:
      return 'Other';
    case ChickenType.layer:
      return 'Layer';
    case ChickenType.cockrail:
      return 'Cockrail';
    case ChickenType.desi:
      return 'Desi';
  }
}

String CounterTransactionTypeEnumToStringConvertor(
    CounterTransactionType transactionType) {
  switch (transactionType) {
    case CounterTransactionType.buy:
      return 'buy';
    case CounterTransactionType.sell:
      return 'sell';
    default:
      return 'error';
  }
}

CounterTransactionType CounterTransactionTypeStringToEnumConvertor(
    String transactionType) {
  switch (transactionType) {
    case 'buy':
      return CounterTransactionType.buy;
    case 'sell':
      return CounterTransactionType.sell;
    default:
      return CounterTransactionType.other;
  }
}

class CounterTransactionDataModal {
  String id;
  ChickenType chickenType;
  CounterTransactionType counterTransactionType;
  double weight;
  double price;
  int pieces;
  String narration;
  CounterTransactionDataModal(
      {required this.id,
      required this.pieces,
      required this.narration,
      required this.weight,
      required this.chickenType,
      required this.price,
      required this.counterTransactionType});
}
