import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/category/category.dart';
import 'package:local_marketplace/models/product/product.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/notifiers/category/category_notifier.dart';
import 'package:local_marketplace/notifiers/product/product_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';

class ProductsListScreen extends StatefulWidget {
  ProductsListScreenState createState() => ProductsListScreenState();
}

class ProductsListScreenState extends State<ProductsListScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 32),
            child: Text(
              "Shop By Categories",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Consumer<CategoryNotifier>(
            builder: (_, data, __) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: buildCategoryList(
                    [Category(name: "All", id: "0"), ...data.categories]),
              );
            },
          ),
          Expanded(child: Consumer<ProductNotifier>(
            builder: (_, data, __) {
              return buildProductList(data.productsBySeller);
            },
          ))
        ],
      ),
    );
  }

  Widget buildCategoryList(List<Category> categories) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 28),
        itemBuilder: (_, index) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: buildCategoryButton(categories[index].name),
              )
            ],
          );
        });
  }

  Widget buildCategoryButton(String name) {
    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xff00AE11)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)))),
        child: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ));
  }

  Widget buildProductList(List<ProductBySeller> datas) {
    return GridView.count(
      padding: const EdgeInsets.only(left: 32, right: 20, bottom: 10, top: 20),
      childAspectRatio: 0.75,
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      children: [for (var data in datas) buildProductContainer(data)],
    );
  }

  Widget buildProductContainer(ProductBySeller data) {
    return GestureDetector(
      onTap: () {
        getIt<ProductNotifier>().productBySeller = data;
        getIt<NavigationService>()
            .navigateTo(productDetailRoute, arguments: {});
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 24, 17, 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffE5E5E5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(data.imageUrls.first))),
              ),
            ),
            Text(
              data.product.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            Text(
              "Php ${data.price.toStringAsFixed(2)}/${data.product.unit}",
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Color(0xff929292)),
            ),
          ],
        ),
      ),
    );
  }
}
