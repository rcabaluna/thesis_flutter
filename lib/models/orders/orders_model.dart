class OrderSummary {
  late String deliveryType;
  late String address;
  late String notes;

  OrderSummary({
    required this.deliveryType,
    required this.address,
    required this.notes,
  });

  OrderSummary.fromJson(Map<String, dynamic> json) {
    deliveryType = json["deliveryType"];
    address = json["address"];
    notes = json["notes"];
  }
}
