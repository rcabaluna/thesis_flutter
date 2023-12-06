class Location {
  late String name;
  late String code;

  Location({required this.name, required this.code});

  Location.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    code = json["code"];
  }
}
