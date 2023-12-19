class PlaceOrder {
  late String deliveryType;
  late String address;
  late String notes;

  PlaceOrder({
    required this.deliveryType,
    required this.address,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'deliveryType': deliveryType,
      'address': address,
      'notes': notes,
    };
  }

  // Add a factory method to create a PlaceOrder object from JSON data
  factory PlaceOrder.fromJson(Map<String, dynamic> json) {
    return PlaceOrder(
      deliveryType: json["deliveryType"],
      address: json["address"],
      notes: json["notes"],
    );
  }
}
