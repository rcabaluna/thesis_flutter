import 'package:local_marketplace/models/user/user.dart';

class OrderSummary {
  late String deliveryType;
  late String address;
  late String notes;
  late User user;

  OrderSummary({
    required this.deliveryType,
    required this.address,
    required this.notes,
    required this.user,
  });

  // OrderSummary.fromJson(Map<String, dynamic> json) {
  //   deliveryType = json["deliveryType"];
  //   address = json["address"];
  //   notes = json["notes"];
  //   user = json["notes"];
  // }
}
