import 'package:flutter/cupertino.dart';
import 'package:local_marketplace/models/location_/region.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/models/seller/seller.dart';
import 'package:local_marketplace/models/user/user.dart';
import 'package:local_marketplace/services/locations_service.dart';
import 'package:local_marketplace/services/shop/shop_service.dart';
import 'package:local_marketplace/services/user/user.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNotifier extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  final UserService _userService = UserService();
  final ShopService _shopService = ShopService();
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  set isLoggedIn(bool isLoggedIn) {
    _isLoggedIn = isLoggedIn;
    notifyListeners();
  }

  //currentUser
  User _currentUser = User();
  User get currentUser => _currentUser;

  set currentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  String _currentToken = "";
  String get currentToken => _currentToken;

  set currentToken(String token) {
    _currentToken = token;
    notifyListeners();
  }

//province seters and get array

  List<Location> _province = [];
  List<Location> get province => _province;

  set province(List<Location> province) {
    _province = province;
    notifyListeners();
  }

  Future getProvince() async {
    final result = await _locationService.getAllProvince();
    province = result;
  }

//municipalities setters and array

  List<Location> _municipalities = [];
  List<Location> get municipalities => _municipalities;

  set municipalities(List<Location> municipalities) {
    _municipalities = municipalities;
    notifyListeners();
  }


  List<Location> _cities = [];
  List<Location> get cities => _cities;

  set cities(List<Location> cities) {
    _cities = cities;
    notifyListeners();
  }



  List<Location> _munCity = [];
  List<Location> get munCity => _munCity;

  set munCity(List<Location> munCity) {
    _munCity = munCity;
    notifyListeners();
  }

  Future getMunCityByProvince(String code) async {
    final municipalities =
        await _locationService.getAllMunicipalitiesByProvince(code);
    final cities = await _locationService.getAllCityByProvince(code);
    //Combine 2 arrays
    final combineMunCity = [...municipalities, ...cities];
    munCity = combineMunCity;
    return munCity;
  }
//barangay

  List<Location> _barangay = [];
  List<Location> get barangay => _barangay;

  set barangay(List<Location> barangay) {
    _barangay = barangay;
    notifyListeners();
  }

  Future getBarangayByCityOrMunicipality(String code) async {
    final result =
        await _locationService.getAllBarangayByMunicipalityOrCity(code);
    barangay = result;
    return barangay;
  }

  Future init() async {
    try {
      await fetchUserDetails();
    } catch (e) {
      rethrow;
    }
  }

  Future fetchUserDetails() async {
    try {
      final result = await _userService.getUserDetails();
      currentUser = User(
          fullName: result["fullName"],
          phoneNumber: result["phoneNumber"],
          address: result["address"]);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future saveAccessToken(String token) async {
    currentToken = token;
    isLoggedIn = true;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('accessToken', token);
  }

  Seller? _myShop;
  Seller? get myShop => _myShop;

  set myShop(Seller? seller) {
    _myShop = seller;
    notifyListeners();
  }

  Future getMyShop() async {
    try {
      final result = await _shopService.getMySellerDetails();
      myShop = Seller.fromJson(result);
    } catch (e) {}
  }

  List<ProductBySeller> _myLiveProducts = [];
  List<ProductBySeller> get myLiveProducts => _myLiveProducts;

  set myLiveProducts(List<ProductBySeller> products) {
    _myLiveProducts = products;
    notifyListeners();
  }

  List<ProductBySeller> _mySoldOutProducts = [];
  List<ProductBySeller> get mySoldOutProducts => _mySoldOutProducts;

  set mySoldOutProducts(List<ProductBySeller> products) {
    _mySoldOutProducts = products;
    notifyListeners();
  }

  Future getLiveProducts() async {
    try {
      final result = await _shopService.getMyProducts("live");
      print("printing result");
      print(result);
      myLiveProducts = result;
    } catch (e) {
      print(e);
    }
  }

  Future getSoldOutProducts() async {
    try {
      final result = await _shopService.getMyProducts("sold");
      mySoldOutProducts = result;
    } catch (e) {}
  }
}
