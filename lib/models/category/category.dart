class Category {
  late String name;
  late String id;
  Category({required this.name, required this.id});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    name = json["name"];
  }
}
