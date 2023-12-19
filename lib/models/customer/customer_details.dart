class CustomerDetails {
  String? fullName;
  String? address;
  String? phoneNumber;

  CustomerDetails({this.fullName, this.address, this.phoneNumber});

  CustomerDetails.fromJson(Map<String, dynamic> json) {
    fullName = json['fullname'];
    address = json['address'];
    phoneNumber = json['phoneNumber'];
  }
}
