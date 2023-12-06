// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:local_marketplace/common/dependency_locator.dart';
import 'package:local_marketplace/routes/constants.dart';
import 'package:local_marketplace/services/common/navigation_service.dart';

class MyRatingScreen extends StatefulWidget {
  MyRatingScreenState createState() => MyRatingScreenState();
}

class MyRatingScreenState extends State<MyRatingScreen> {
  late double _productRating;
  late double _shopRating;
  @override
  void initState() {
    super.initState();
    _productRating = 0;
    _shopRating = 0;
  }

  void _handleProductTap(double selectedRating) {
    setState(() {
      _productRating = selectedRating;
    });
    print('Selected Rating: $_productRating');
  }

  void _handleShopTap(double selectedRating) {
    setState(() {
      _shopRating = selectedRating;
    });
    print('Selected Rating: $_shopRating');
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Products"),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back),
          ),
          bottom: const TabBar(tabs: [Text("To Rate"), Text("Complete")]),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: buildOrderContainer(),
              ),
            ),
            Center(
              child: buildCompleteRateOrder(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOrderContainer() {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.store_outlined,
              size: 30,
              color: Colors.green,
            ),
            Text("Shop Name")
          ],
        ),
        Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://www.organics.ph/cdn/shop/products/chili-labuyo-100grams-fruits-vegetables-fresh-produce-126835_800x.jpg?v=1601484492'), // Replace with your actual image path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$19.99",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                      Text("X2"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                getIt<NavigationService>()
                    .navigateTo(rateOrderRoute, arguments: {});
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(120, 40)),
              child: Text(
                'Rate',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildCompleteRateOrder() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 30,
                  color: Colors.green,
                ),
                Text(
                  "Shop Name",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit_document,
                    size: 30,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://www.organics.ph/cdn/shop/products/chili-labuyo-100grams-fruits-vegetables-fresh-produce-126835_800x.jpg?v=1601484492'), // Replace with your actual image path
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Product Name",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$19.99",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                          Text("X2"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Product Ratings: ",
                            style: TextStyle(fontSize: 9),
                          ),
                          buildProductStarRating()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Shop Rating: ",
                            style: TextStyle(fontSize: 9),
                          ),
                          buildShopStarRating()
                        ],
                      ),
                      buildImageContainer()
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double rating = index + 1.0;
        return GestureDetector(
          onTap: () => _handleProductTap(rating),
          child: Icon(
            index < _productRating.floor()
                ? Icons.star
                : index < _productRating
                    ? Icons.star_half
                    : Icons.star_border,
            size: 15.0,
            color: _productRating >= rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget buildShopStarRating() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        double rating = index + 1.0;
        return GestureDetector(
          onTap: () => _handleShopTap(rating),
          child: Icon(
            index < _shopRating.floor()
                ? Icons.star
                : index < _shopRating
                    ? Icons.star_half
                    : Icons.star_border,
            size: 15.0,
            color: _shopRating >= rating ? Colors.amber : Colors.grey,
          ),
        );
      }),
    );
  }

  Widget buildImageContainer() {
    final List<String> imageUrls = [
      'http://t1.gstatic.com/images?q=tbn:ANd9GcRkGqYiY11eRquUhLKsSVKKuecRTac1K92_JP4tYld766MA5hTlzqQxZBKG0cFg9tI_tVrr5g',
      'http://t1.gstatic.com/images?q=tbn:ANd9GcRkGqYiY11eRquUhLKsSVKKuecRTac1K92_JP4tYld766MA5hTlzqQxZBKG0cFg9tI_tVrr5g',
      'http://t1.gstatic.com/images?q=tbn:ANd9GcRkGqYiY11eRquUhLKsSVKKuecRTac1K92_JP4tYld766MA5hTlzqQxZBKG0cFg9tI_tVrr5g'

      // Add more image URLs as needed
    ];
    return Container(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            height: 40, // Set the height as per your requirement
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
