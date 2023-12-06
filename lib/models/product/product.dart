class Product {
  late String id;
  late String imageUrl;
  late num price;
  late String name;
  late String unit;

  Product(
      {required this.imageUrl,
      required this.price,
      required this.name,
      required this.unit,
      required this.id});

  Product.fromJson(Map<String, dynamic> json) {
    imageUrl = json["imageUrl"];
    price = json["price"];
    name = json["name"];
    unit = json["unit"];
    id = json["_id"];
  }
}
