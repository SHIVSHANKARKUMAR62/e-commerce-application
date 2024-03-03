import 'package:admineccomerce/buying/BuyProduct.dart';
import 'package:admineccomerce/homecontroller/homecontroller.dart';
import 'package:admineccomerce/models/product-model.dart';
import 'package:admineccomerce/screen/Cart/cartScreen.dart';
import 'package:admineccomerce/screen/home.dart';
import 'package:admineccomerce/screen/zoomPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../controller/cartTotalPrice.dart';
import '../controller/quantity.dart';
import '../models/cart-model.dart';
import '../models/user-model.dart';

class ProductDetails extends StatefulWidget {
  final ProductModel productModel;
  final String id;
  const ProductDetails({Key? key, required this.productModel, required this.id})
      : super(key: key);

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  HomeController homeController = Get.put(HomeController());
  bool full = true;
  bool fullName = true;
  double? rate = 3.0;
  Quantity qController = Get.put(Quantity());
  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //widget.productModel;
    FirebaseFirestore.instance.collection("products").get();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
    qController.quantity.value = 1;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtonTheme(
          child: Row(
        children: [
          Expanded(
            child: IconButton(
                onPressed: int.parse(widget.productModel.quantity)!=0?() async {
                  int quantityIncrement = 1;
                  totalPriceCart.factProductPrice();
                  EasyLoading.show(status: "Adding...");

                  final DocumentReference documentReference = FirebaseFirestore.instance
                      .collection('cart')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('cartOrders')
                      .doc(widget.id.toString());

                  DocumentSnapshot snapshot = await documentReference.get();

                  if (snapshot.exists) {
                    String currentQuantity = snapshot['productQuantity'];
                    int updatedQuantity = int.parse(currentQuantity) + qController.quantity.value;
                    int totalPrice =  ((int.parse(widget.productModel.salePrice)) *
                        updatedQuantity);
                    if(int.parse(currentQuantity)!=int.parse(widget.productModel.quantity)) {
                      await documentReference.update({
                        'productQuantity': updatedQuantity.toString(),
                        'productTotalPrice': totalPrice.toString()
                      }).whenComplete(() {
                        Get.snackbar(
                          dismissDirection: DismissDirection.horizontal,
                            backgroundColor: Colors.blue,
                            "Product", "${qController.quantity.value} product is added"
                        );
                        qController.quantity.value = 1;
                        EasyLoading.dismiss();
                      });

                      print("product exists");
                    }else{
                      Get.snackbar(
                          dismissDirection: DismissDirection.horizontal,
                        backgroundColor: Colors.blue,
                          "Product", "You add all available product in your cart"
                      );
                      EasyLoading.dismiss();
                    }
                  }else {
                    await FirebaseFirestore.instance.collection('cart').doc(FirebaseAuth.instance.currentUser!.uid).collection("cartOrders").doc(widget.id).set({
                    'isCart' : true,
                      'userAddress' : "",
                    'ownerUid': widget.productModel.userUid,
                    'tP' : widget.productModel.quantity,
                    'pId' : widget.id,
                    'id' : FirebaseAuth.instance.currentUser!.uid,
                    'productName': widget.productModel.productName,
                    'categoryName': widget.productModel.categoryName,
                    'salePrice': widget.productModel.salePrice,
                    'user' : widget.productModel.userUid,
                    'fullPrice': widget.productModel.fullPrice,
                    'productImages': widget.productModel.productImages,
                    'deliveryTime': widget.productModel.deliveryTime,
                    'isSale': widget.productModel.isSale,
                    'productDescription': widget.productModel.productDescription,
                    'createdAt': widget.productModel.createdAt,
                    'updatedAt': widget.productModel.updatedAt,
                    'productQuantity': qController.quantity.value.toString(),
                    'productTotalPrice': (qController.quantity.value*int.parse(widget.productModel.salePrice)).toString(),

                  }).whenComplete(() async{
                    await FirebaseFirestore.instance.collection("products").doc(widget.id).update({
                      'isCart' : true
                    });
                    // Get.to(()=>const Home());
                      Get.snackbar(
                          dismissDirection: DismissDirection.horizontal,
                          backgroundColor: Colors.blue,
                          "Product", "${qController.quantity.value} product is added"
                      );
                    qController.quantity.value = 1;
                    EasyLoading.dismiss();
                  });
                  }
                }:null,
                icon: Container(
                  height: Get.height*0.07,
                  //width: 180,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: int.parse(widget.productModel.quantity)!=0? Colors.red:Colors.greenAccent),
                  child: Center(child: int.parse(widget.productModel.quantity)!=0?const Text("Add Cart"):const Text("No Product Available")),
                )),
          ),
          int.parse(widget.productModel.quantity)!=0?Expanded(
            child: IconButton(
                onPressed: () {
                  Get.to(()=>BuyProduct(
                    id: widget.id,
                    productModel: widget.productModel,
                    pQ: qController.quantity.value.toString(),
                    totalP:(qController.quantity.value*int.parse(widget.productModel.salePrice)).toString() ,));
                },
                icon: Container(
                  height: 50,
                  width: 180,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.blue),
                  child: const Center(child: Text("Buy"),
                )),
          ),):Expanded(child: Container(
            height: Get.height*0.07,
           // width: 180,
          ))
        ],
      )),
      appBar: AppBar(
        // actions: [
        //   IconButton(onPressed: (){
        //     Get.to(()=>const CartScreen());
        //
        //   }, icon: const Icon(Icons.shopping_cart_checkout_rounded))
        // ],
        title: const Text("Product Details"),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarouselSlider(
              items: widget.productModel.productImages
                  .map(
                    (imageUrls) => Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => ZoomPage(
                                imageIndex: imageUrls,
                                name: widget.productModel.productName,
                              ));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.fill,
                            width: Get.width - 10,
                            placeholder: (context, url) => const ColoredBox(
                              color: Colors.white,
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                aspectRatio: 1.5,
                animateToClosest: true,
                autoPlayAnimationDuration: const Duration(seconds: 2),
                //enableInfiniteScroll: false,
                viewportFraction: 1,
                //disableCenter: true,
                pauseAutoPlayOnTouch: true
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: GestureDetector(
              onTap: (){
                setState(() {
                  if (fullName == true) {
                    fullName = false;
                  } else {
                    fullName = true;
                  }
                });
              },
              child: Text(widget.productModel.productName,
                  overflow: fullName==true?TextOverflow.ellipsis:null,
                  style: const TextStyle(fontSize: 25)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: int.parse(widget.productModel.quantity)!=0?Text("Product Quantity: ${widget.productModel.quantity}"):const Text("Out Of Stock",style: TextStyle(color: Colors.red)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, bottom: 8.0),
            child: Row(
              children: [
                Text("Rs: ${widget.productModel.salePrice}",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16)),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(widget.productModel.fullPrice,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey)),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Description", style: TextStyle(fontSize: 20)),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                if (full == true) {
                  full = false;
                } else {
                  full = true;
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(widget.productModel.productDescription,
                  overflow: full == true ? TextOverflow.ellipsis : null,
                  style: const TextStyle(
                    fontSize: 16,
                  )),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text(
                    overflow: TextOverflow.ellipsis,
                    "How many product you want to buy? ",style: TextStyle(fontSize: 20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){
                      qController.decrement();
                    }, icon: const Icon(Icons.exposure_neg_1),
                    color: Colors.blue,
                      style: ButtonStyle(shape: MaterialStateProperty.all(const CircleBorder(side: BorderSide(color: Colors.black)))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Obx(() => Text(qController.quantity.value.toString())),
                    ),
                    IconButton(onPressed: (){
                      if(int.parse(widget.productModel.quantity)!=qController.quantity.value&&int.parse(widget.productModel.quantity)!=0) {
                        qController.increment();
                      }
                    }, icon: const Icon(Icons.exposure_plus_1),
                    color: Colors.blue,
                      style: ButtonStyle(shape: MaterialStateProperty.all(const CircleBorder(side: BorderSide(color: Colors.black)))),
                    ),
                  ],
                )
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Shop Details",style: TextStyle(fontSize: 20)),
          ),

          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').doc(widget.productModel.userUid).collection("shop").snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error"),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: Get.height/5,
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }

              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No Address..."),
                );
              }

              if (snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var id = snapshot.data!.docs[index].id;
                    print(id);
                    UserModel userModel = UserModel(
                      gstNumber: snapshot.data!.docs[index]['gstNumber'],
                      shopName: snapshot.data!.docs[index]['shopName'],
                        longitude: "",
                        latitude: "",
                        uId: snapshot.data!.docs[index]['uId'],
                        username: snapshot.data!.docs[index]['username'],
                        email: snapshot.data!.docs[index]['email'],
                        phone: snapshot.data!.docs[index]['phone'],
                        userImg: snapshot.data!.docs[index]['userImg'],
                        userDeviceToken: "",
                        country: snapshot.data!.docs[index]['country'],
                        userAddress: snapshot.data!.docs[index]['userAddress'],
                        street: snapshot.data!.docs[index]['street'],
                        isAdmin: snapshot.data!.docs[index]['isAdmin'],
                        isActive: snapshot.data!.docs[index]['isActive'],
                        createdOn: snapshot.data!.docs[index]['createdOn'],
                        city: snapshot.data!.docs[index]['email'],
                        area: snapshot.data!.docs[index]['area'],
                        deistic: snapshot.data!.docs[index]['deistic']
                    );
                    String image = userModel.userImg;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: Column(
                          children: [
                            
                            
                            ListTile(
                              title: const Text("Shop Name"),
                              subtitle: Text(userModel.shopName),
                              trailing: Column(
                                children: [
                                  const Text("Shop Image"),
                                  CircleAvatar(child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                        imageUrl: userModel.userImg,
                                        // placeholder: (context, url) => const CircularProgressIndicator(),
                                        fit: BoxFit.fill),
                                  )),
                                ],
                              ),
                            ),
                            ListTile(
                              title: const Text("Shop Address"),
                              subtitle: Text(userModel.userAddress),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return Container();
            },
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Rating",style: TextStyle(fontSize: 20)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: RatingBar.builder(
              initialRating: rate as double,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                });
                print(rate);
              },
            ),
          ),
        ]),
      ),
    );
  }
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.id.toString());

    DocumentSnapshot snapshot = await documentReference.get();

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity'];
      int updatedQuantity = currentQuantity + quantityIncrement;
      double totalPrice = double.parse(widget.productModel.isSale
          ? widget.productModel.salePrice
          : widget.productModel.fullPrice) *
          updatedQuantity;

      await documentReference.update({
        'productQuantity': updatedQuantity,
        'productTotalPrice': totalPrice
      });

      print("product exists");
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId,
          'createdAt': DateTime.now(),
        },
      );
      // 'productQuantity': qController.quantity.value.toString(),
      // 'productTotalPrice': (qController.quantity.value*int.parse(widget.productModel.salePrice)).toString(),

      CartModel cartModel = CartModel(
        isCart: true,
          ownerUid: widget.productModel.userUid,
          tP: widget.productModel.quantity,
          pId: widget.id,
          id: widget.productModel.userUid,
          productName: widget.productModel.productName,
          categoryName: widget.productModel.categoryName,
          salePrice: widget.productModel.salePrice,
          fullPrice: widget.productModel.fullPrice,
          productImages: widget.productModel.productImages,
          deliveryTime: widget.productModel.deliveryTime,
          isSale: widget.productModel.isSale,
          productDescription: widget.productModel.productDescription,
          createdAt: widget.productModel.createdAt,
          updatedAt: widget.productModel.updatedAt,
          productQuantity: quantityIncrement.toString(),
          productTotalPrice: widget.productModel.fullPrice);

      await documentReference.set(cartModel.toMap());

      print("product added");
    }
    }
}
