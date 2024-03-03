import 'package:admineccomerce/controller/cartTotalPrice.dart';
import 'package:admineccomerce/controller/quantity.dart';
import 'package:admineccomerce/models/cart-model.dart';
import 'package:admineccomerce/services/order/Order.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../buying/BuyProduct.dart';
import '../../models/product-model.dart';
import '../../services/place-order-service.dart';
import '../home.dart';
import '../productdetails.dart';
import 'bauyingInProductInCart/bauyingSingleProductInCart.dart';
import 'bauyingInProductInCart/buyingAllTheCartProduct.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Quantity qController = Get.put(Quantity());
  bool addBuy = false;
  bool full = true;
  int? cartQuantity;
  int i = 0;
  //late CartModel cartModel;
  // List pId = [];
  
  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //print(cartModel);
    totalPriceCart.factProductPrice();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }



  @override
  Widget build(BuildContext context) {
    int quantity = 0;
    int outOfStock = 0;
    int pQuantity = 0;
    return Scaffold(
      appBar: AppBar(
         title: const Text("My Cart"),
      ),
      bottomNavigationBar: Container(
        height: Get.height*0.1614,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(child: Container(
                      height: Get.height*0.06,
                      //width: Get.width*0.2,
                      decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                      ),
                      child: const Center(child: Text("Total Price: ")),
                    )),
                    SizedBox(
                      width: Get.width*0.05,
                    ),
                    Expanded(child: Center(
                      child: Container(
                        height: Get.height*0.06,
                        //width: 50,
                        decoration: const BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Center(child: Obx(() {
                          print(outOfStock);
                          if(totalPriceCart.totalProduct.value == 0){
                            outOfStock = 0;
                            // return const Center(child: Text("No Cart Present",overflow: TextOverflow.ellipsis,));
                         return Text((totalPriceCart.totalP.value-outOfStock).toString());
                          }else{
                            return Text((totalPriceCart.totalP.value-outOfStock).toString());
                          }

                        })),
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    if (totalPriceCart.totalProduct.value == 0) {
                      null;
                    } else {
                      if (quantity == 0) {
                        Get.to(() =>
                            BuyingAllTheCartProduct(
                              totalPriceCart: totalPriceCart,
                              quantity: pQuantity,
                              outOfStock: outOfStock,));
                      } else {
                        pQuantity = 0;
                        outOfStock = 0;
                        Get.to(() =>
                            BuyingAllTheCartProduct(
                              totalPriceCart: totalPriceCart,
                              quantity: pQuantity,
                              outOfStock: outOfStock,));
                      }
                      qController.quantity.value = 1;
                    }
                  },
                  child: Container(
                    height: Get.height*0.06,
                    //width: Get.width*0.2,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: const Center(child: Text("Buy All Cart Product")),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: totalPriceCart.totalP.value==0?const Center(child: Text("No Cart"),):StreamBuilder(
        stream: FirebaseFirestore.instance.collection('products').where('isCart',isEqualTo: true).snapshots(),
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
              child: Text("No Product found!"),
            );
          }


          if (snapshot.data != null) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                // var id = snapshot.data!.docs[index].id;
                // print(id);
                ProductModel productModel = ProductModel(
                  //categoryId: snapshot.data!.docs[index]['categoryId'],
                    isCart: snapshot.data!.docs[index]['isCart'],

                    userUid: snapshot.data!.docs[index]['userUid'],
                    quantity: snapshot.data!.docs[index]['quantity'],
                    productName: snapshot.data!.docs[index]['productName'],
                    categoryName: snapshot.data!.docs[index]['categoryName'] ,
                    salePrice: snapshot.data!.docs[index]['salePrice'],
                    fullPrice: snapshot.data!.docs[index]['fullPrice'],
                    productImages: snapshot.data!.docs[index]['productImages'],
                    deliveryTime: snapshot.data!.docs[index]['deliveryTime'],
                    isSale: snapshot.data!.docs[index]['isSale'],
                    productDescription: snapshot.data!.docs[index]['productDescription'],
                    createdAt: snapshot.data!.docs[index]['createdAt'],
                    updatedAt: snapshot.data!.docs[index]['updatedAt']);


                return StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('cart').doc(FirebaseAuth.instance.currentUser!.uid).collection("cartOrders")
                      .where('isCart',isEqualTo: true).where('productName',isEqualTo: productModel.productName)
                      .where('ownerUid',isEqualTo: productModel.userUid).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snap) {
                    if (snap.hasError) {
                      return const Center(
                        child: Text("Error"),
                      );
                    }
                    if (snap.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: Get.height*0.7,
                        child: Center(
                          child: Container(),
                        ),
                      );
                    }

                    if (snap.data!.docs.isEmpty) {
                      return Container();
                    }

                    if (snap.data != null) {
                      return ListView.builder(
                        itemCount: snap.data!.docs.length,
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var id = snap.data!.docs[index].id;
                          //print(id);
                          CartModel cartModel = CartModel(
                              isCart: snap.data!.docs[index]['isCart'],
                              ownerUid: snap.data!.docs[index]['ownerUid'],
                              tP: snap.data!.docs[index]['tP'],
                              pId: snap.data!.docs[index]['pId'],
                              id: snap.data!.docs[index]['id'],
                              productName: snap.data!.docs[index]['productName'],
                              categoryName: snap.data!.docs[index]['categoryName'] ,
                              salePrice: snap.data!.docs[index]['salePrice'],
                              fullPrice: snap.data!.docs[index]['fullPrice'],
                              productImages: snap.data!.docs[index]['productImages'],
                              deliveryTime: snap.data!.docs[index]['deliveryTime'],
                              isSale: snap.data!.docs[index]['isSale'],
                              productDescription: snap.data!.docs[index]['productDescription'],
                              createdAt: snap.data!.docs[index]['createdAt'],
                              updatedAt: snap.data!.docs[index]['updatedAt'],
                              productQuantity: snap.data!.docs[index]['productQuantity'],
                              productTotalPrice: snap.data!.docs[index]['productTotalPrice']);

                          if(int.parse(productModel.quantity)==0) {
                            pQuantity = int.parse(
                                cartModel.productQuantity);
                            quantity =
                                int.parse(productModel.quantity);
                            outOfStock = int.parse(
                                cartModel.productTotalPrice)
                                .toInt();
                            totalPriceCart.factProductPrice();
                          }

                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                                color: Colors.red,
                                child: const Icon(Icons.delete)),
                            key: ValueKey(snapshot.data!.docs[index]),
                            onDismissed: (DismissDirection direction)async{
                              //totalPriceCart.factProductPrice();
                              totalPriceCart.totalProduct.value -= quantity;
                              totalPriceCart.factProductPrice();
                              await FirebaseFirestore.instance.collection('cart').doc(FirebaseAuth.instance.currentUser!.uid).collection("cartOrders").doc(id).delete();


                              //outOfStock!=0? totalPriceCart.factProductPrice():null;
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: (){
                                  Get.to(()=>ProductDetails(productModel: productModel,id: id,));
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                  height: Get.height*0.15,
                                                  width: Get.height*0.3,
                                                  imageUrl: cartModel.productImages[0],
                                                  // placeholder: (context, url) => const CircularProgressIndicator(),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          Expanded(

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                      overflow: TextOverflow.ellipsis,
                                                      "Name:  ${productModel.productName}",),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        "Product Quantity:  ${cartModel.productQuantity}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: int.parse(productModel.quantity)!=0?Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        "Available Quantity: ${productModel.quantity}",style: const TextStyle(overflow: TextOverflow.ellipsis)):const Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        "Out Of Stock",style: TextStyle(color: Colors.red)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Text("Rs: ${productModel.salePrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Text(productModel.fullPrice,style: const TextStyle(overflow: TextOverflow.ellipsis,decoration: TextDecoration.lineThrough,color: Colors.grey)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 8.0,top: 7),
                                                    child: Text("Total Price: ${cartModel.productTotalPrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    return Container();
                  },
                );

              },
            );
          }

          return Container();
        },
      ),
    );
  }
}