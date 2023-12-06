class Seller {
  late String shopName;
  late String imageUrl;
  late String address;

  Seller(
      {required this.shopName, required this.imageUrl, required this.address});

  Seller.fromJson(Map<String, dynamic> json) {
    imageUrl = json["imageUrl"];
    shopName = json["shopName"];
    address = json["address"];
  }
}
