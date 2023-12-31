import 'package:local_marketplace/models/seller/seller.dart';

class OrderDetails {
  final String id;
  final String orderId;
  final int quantity;
  final int total;
  final String status;
  final String createdAt;
  final String updatedAt;
  final Seller seller;

  OrderDetails({
    required this.id,
    required this.orderId,
    required this.quantity,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.seller,
  });

  get userId => null;

  // factory OrderDetails.fromJson(Map<String, dynamic> json) {
  //   return OrderDetails(
  //     id: json['_id'],
  //     orderId: json['orderId'],
  //     quantity: json['quantity'],
  //     total: json['total'].toDouble(),
  //     status: json['status'],
  //     createdAt: json['createdAt'],
  //     updatedAt: json['updatedAt'],
  //   );
  // }
}
