import 'package:admineccomerce/screen/productdetails.dart';
import 'package:admineccomerce/screen/productsharing.dart';
import 'package:admineccomerce/screen/searchProduct/SearchProduct.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/categories-model.dart';
import '../models/product-model.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool search = true;
  TextEditingController searchController = TextEditingController();
  String searchPart = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (search == true) {
                    Get.to(()=>const SearchProduct());
                  } else {
                    //searchPart = "";
                    search = true;
                  }
                });
              },
              icon: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("Error"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: Get.height / 5,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text("No Product found!"),
                  );
                }

                if (snapshot.data != null) {
                  return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 2,
                              mainAxisSpacing: 2),
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var id = snapshot.data!.docs[index].id;
                        print(id);
                        ProductModel productModel = ProductModel(
                          isCart: snapshot.data!.docs[index]['isCart'],
                          userUid: snapshot.data!.docs[index]['userUid'],
                            //categoryId: snapshot.data!.docs[index]['categoryId'],
                            quantity: snapshot.data!.docs[index]['quantity'],
                            productName: snapshot.data!.docs[index]
                                ['productName'],
                            categoryName: snapshot.data!.docs[index]
                                ['categoryName'],
                            salePrice: snapshot.data!.docs[index]['salePrice'],
                            fullPrice: snapshot.data!.docs[index]['fullPrice'],
                            productImages: snapshot.data!.docs[index]
                                ['productImages'],
                            deliveryTime: snapshot.data!.docs[index]
                                ['deliveryTime'],
                            isSale: snapshot.data!.docs[index]['isSale'],
                            productDescription: snapshot.data!.docs[index]
                                ['productDescription'],
                            createdAt: snapshot.data!.docs[index]['createdAt'],
                            updatedAt: snapshot.data!.docs[index]['updatedAt']);

                        if (searchPart.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                      productModel: productModel,
                                  id: id,
                                    ));
                              },
                              child: SizedBox(
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.14,
                                        width: Get.width * 0.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  productModel.productImages[0],
                                              // placeholder: (context, url) => const CircularProgressIndicator(),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(productModel.productName,
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                "Rs: ${productModel.salePrice}",
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  productModel.fullPrice,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else if (productModel.productName
                            .toLowerCase()
                            .startsWith(searchPart.toLowerCase())) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                Get.to(() => ProductDetails(
                                  id: id,
                                      productModel: productModel,
                                    ));
                              },
                              child: SizedBox(
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: Get.height * 0.14,
                                        width: Get.width * 0.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  productModel.productImages[0],
                                              // placeholder: (context, url) => const CircularProgressIndicator(),
                                              fit: BoxFit.fill),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(productModel.productName,
                                            style: const TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                                "Rs: ${productModel.salePrice}",
                                                style: const TextStyle(
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                  productModel.fullPrice,
                                                  style: const TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color: Colors.grey)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      });
                }

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}
