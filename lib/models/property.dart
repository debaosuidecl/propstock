class Property {
  String id;
  String name;
  String propImage;
  String location;
  double pricePerUnit;
  String currency;
  double amountFunded;
  double totalAmountToFund;
  String propertyType;
  String? furniture;
  String? availability;
  List<dynamic>? facilities;
  String investmentType;
  String status;
  int? bedNumber;
  int? bathNumber;
  int? plotNumber;
  int? landSize;
  List<dynamic>? imagesList;
  String? about;
  double? latitude;
  double? longitude;
  int? availableUnit;
  int? totalUnits;
  int? minHoldingTime;
  int? leverage;
  List<dynamic>? tags;
  String? volatility;
  String? certificateOfOccupancy;
  String? governorConsent;
  String? probateLetterOfAdministration;
  String? excisionGazette;
  int maturitydate;
  Property({
    required this.name,
    required this.id,
    required this.currency,
    required this.propImage,
    required this.location,
    required this.pricePerUnit,
    required this.amountFunded,
    required this.totalAmountToFund,
    required this.propertyType,
    required this.investmentType,
    required this.status,
    this.imagesList,
    this.furniture,
    this.availability,
    this.landSize,
    this.facilities,
    this.bedNumber,
    this.bathNumber,
    this.plotNumber,
    this.about,
    this.longitude,
    this.latitude,
    this.availableUnit,
    this.totalUnits,
    this.minHoldingTime,
    this.leverage,
    this.tags,
    this.volatility,
    this.certificateOfOccupancy,
    this.excisionGazette,
    this.governorConsent,
    this.probateLetterOfAdministration,
    required this.maturitydate,
  });
}
