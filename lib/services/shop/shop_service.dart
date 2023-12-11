import 'package:local_marketplace/common/core/network/endpoint.dart';
import 'package:local_marketplace/common/core/network/index.dart';
import 'package:dio/dio.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/models/seller/seller.dart';
import 'package:path/path.dart';

class ShopService {
  final NetworkService _networkService = NetworkService();

  Future saveSeller(CroppedFile? croppedFile, Map<String, dynamic> data) async {
    try {
      if (croppedFile != null) {
        String fileName = basename(croppedFile.path);
        List<int> bytes = await croppedFile.readAsBytes();
        var formData = FormData.fromMap({
          ...data,
          "image": MultipartFile.fromBytes(bytes, filename: fileName),
        });
        await _networkService.postRequest(SHOP_URL, body: formData);
      } else {
        await _networkService.postRequest(SHOP_URL, body: data);
      }
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  Future getMySellerDetails() async {
    try {
      final response = await _networkService.getRequest(SHOP_URL);
      return response;
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future addProducts(FormData formData) async {
    try {
      const url = "$SHOP_URL/add-product";
      await _networkService.postRequest(url, body: formData);
    } on DioException catch (e) {
      rethrow;
    }
  }

  Future<List<ProductBySeller>> getMyProducts(String param) async {
    var url = "$SHOP_URL/product-$param";

    try {
      final result = await _networkService.getRequest(url);
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(result);
      return data.map((json) {
        Product product = Product.fromJson(json["productId"]);
        Seller seller = Seller.fromJson(json["sellerId"]);
        var urls = (json["imageUrls"] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return ProductBySeller(
            product: product,
            id: json["_id"],
            seller: seller,
            price: json["price"],
            imageUrls: urls,
            qty: json["quantity"]);
      }).toList();
    } on DioException catch (e) {
      rethrow;
    }
  }


}
