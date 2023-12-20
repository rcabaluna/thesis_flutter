class OrderSummary {
  final String deliveryType;
  final String address;
  final String notes;

  OrderSummary({
    required this.deliveryType,
    required this.address,
    required this.notes,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) {
    return OrderSummary(
        deliveryType: json["deliveryType"],
        address: json["address"],
        notes: json["notes"]);
  }
}
