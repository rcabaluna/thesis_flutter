// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/models/productbyseller/product_by_seller.dart';
import 'package:local_marketplace/notifiers/app_notifier.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';
import 'package:provider/provider.dart';

class ShopProductScreen extends StatefulWidget {
  ShopProductScreenState createState() => ShopProductScreenState();
}

class ShopProductScreenState extends State<ShopProductScreen> {
  @override
  void initState() {
    getIt<AppNotifier>().getLiveProducts();
    getIt<AppNotifier>().getSoldOutProducts();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Products"),
          leading: IconButton(
            onPressed: () {
              getIt<NavigationService>()
                  .navigateTo(shopProfileRoute, arguments: {});
            },
            icon: const Icon(Icons.arrow_back),
          ),
          bottom: const TabBar(tabs: [Text("Live"), Text("Sold Out")]),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: Consumer<AppNotifier>(
                    builder: (_, notifier, __) {
                      print(notifier.myLiveProducts.length);
                      return Column(
                        children: [
                          Expanded(
                            child: Container(
                              child: _buildProductListBuilder(
                                  notifier.myLiveProducts),
                            ),
                          ),
                          SizedBox(
                            height: 60,
                          )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: Text("Sold Out List"),
            )
          ],
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              onPressed: () {
                getIt<NavigationService>()
                    .navigateTo(addProductRoute, arguments: {});
              },
              child: Text(
                'Add Product',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildProductListBuilder(List<ProductBySeller> datas) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: datas.length,
        itemBuilder: (context, index) {
          ProductBySeller data = datas[index];
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(data.imageUrls.first))),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.product.name),
                    Text("P ${data.product.price.toStringAsFixed(2)}"),
                    Text("Stocks: ${data.qty}")
                  ],
                )
              ],
            ),
          );
        });
  }
}
