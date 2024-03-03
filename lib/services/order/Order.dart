import 'package:admineccomerce/models/cart-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controller/cartTotalPrice.dart';
import '../../controller/quantity.dart';
import '../../models/user-model.dart';
import '../../screen/home.dart';
import '../genrate-order-id-service.dart';

class CartBuying extends StatefulWidget {
  final CartModel cartModel;
  final String productId;
  final String cartId;
  final String totalProduct;
  const CartBuying({Key? key,required this.totalProduct,required this.cartModel,required this.productId,required this.cartId}) : super(key: key);

  @override
  State<CartBuying> createState() => _CartBuyingState();
}

class _CartBuyingState extends State<CartBuying> {
  Quantity qController = Get.put(Quantity());
  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ButtonTheme(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: IconButton(
                        onPressed: (){

                        },
                        icon: Container(
                          height: Get.height*0.08,
                          //width: 180,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            //border: Border.all(color: Colors.black )
                          ),
                          child: Center(child: ListTile(
                              title: Text("Price: ${int.parse(widget.cartModel.productQuantity)*int.parse(widget.cartModel.fullPrice)}",style: const TextStyle(decoration: TextDecoration.lineThrough)),
                              subtitle: Text(("Sale Price: ${int.parse(widget.cartModel.productQuantity)*int.parse(widget.cartModel.salePrice)}"),
                              )),
                          )),
                        )),
                Expanded(
                  child: IconButton(
                      onPressed: () async {
                        totalPriceCart.factProductPrice();
                        String orderId = generateOrderId();
                        EasyLoading.show(status: "Adding...");
                        await FirebaseFirestore.instance
                            .collection('orders').doc(orderId)
                            .set({
                          "shopAddress" : "",
                          'lat' : "",
                          'lot' : "",
                          'deliveryBoy' : false,
                          'shop' : false,
                          'orderId' : orderId,
                          'sellerId' : widget.cartModel.ownerUid,
                          'totalProduct' : widget.cartModel.tP,
                          'productId': widget.productId,
                          'ownerUid': widget.cartModel.ownerUid,
                          'productName': widget.cartModel.productName,
                          'categoryName': widget.cartModel.categoryName,
                          'salePrice': widget.cartModel.salePrice,
                          'fullPrice': widget.cartModel.fullPrice,
                          'productImages': widget.cartModel.productImages,
                          'deliveryTime': widget.cartModel.deliveryTime,
                          'isSale': widget.cartModel.isSale,
                          'productDescription': widget.cartModel.productDescription,
                          'createdAt': DateTime.now(),
                          'updatedAt': widget.cartModel.updatedAt,
                          'productQuantity': widget.cartModel.productQuantity,
                          'productTotalPrice': (qController.quantity.value*int.parse(widget.cartModel.salePrice)).toString(),
                          'customerId': FirebaseAuth.instance.currentUser!.uid,
                          'status': false,
                          'customerName': "",
                          'customerPhone': "",
                          'customerAddress': "",
                          'customerDeviceToken': "",
                        }).whenComplete(() async{
                          await FirebaseFirestore.instance.collection("products").doc(widget.cartModel.pId).update({
                            'quantity': (int.parse(widget.cartModel.tP)-int.parse(widget.cartModel.productQuantity) ).toString()
                          }).whenComplete(() async{
                            //delete cart products
                            await FirebaseFirestore.instance
                                .collection('cart')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection('cartOrders')
                                .doc(widget.cartModel.pId.toString())
                                .delete()
                                .then((value) {
                              print('Delete cart Products ${widget.cartModel}.productId.toString()');
                            }).whenComplete(() {
                              Get.snackbar(
                                "Order Confirmed",
                                "Thank you for your order!",
                                backgroundColor: Colors.blue,
                                colorText: Colors.white,
                                duration: const Duration(seconds: 5),
                              );
                              Get.offAll(()=>const Home());});
                          });
                        });
                          // Get.to(()=>const Home());
                          qController.quantity.value = 1;
                          EasyLoading.dismiss();
                      },
                      icon: Container(
                        height: Get.height*0.08,
                        //width: Get.,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.blue),
                        child: const Center(child: Text("Continue")),
                      )),
                ),
              ],
            ),
          )),
      appBar: AppBar(
        title: const Text("Order Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: Get.height*0.26,
                width: Get.width,
                child: Card(
                  elevation: 5,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Delivery Address: ",style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        StreamBuilder(
                          stream:FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("shop").where('uId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
                                child: Text("Add Your Shop First..."),
                              );
                            }

                            if (snapshot.data != null) {
                              return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  var id = snapshot.data!.docs[index].id;
                                  print(id);
                                  UserModel userModel = UserModel(
                                    gstNumber: snapshot.data!.docs[index]['gstNumber'],
                                    shopName: snapshot.data!.docs[index]['shopName'],
                                      longitude: snapshot.data!.docs[index]['longitude'],
                                      latitude: snapshot.data!.docs[index]['latitude'],
                                      uId: FirebaseAuth.instance.currentUser!.uid,
                                      username: snapshot.data!.docs[index]['username'],
                                      email: snapshot.data!.docs[index]['email'],
                                      phone: snapshot.data!.docs[index]['phone'],
                                      userImg: snapshot.data!.docs[index]['userImg'],
                                      userDeviceToken: snapshot.data!.docs[index]['userDeviceToken'],
                                      country: snapshot.data!.docs[index]['country'],
                                      userAddress: snapshot.data!.docs[index]['userAddress'],
                                      street: snapshot.data!.docs[index]['street'],
                                      isAdmin: snapshot.data!.docs[index]['isAdmin'],
                                      isActive: snapshot.data!.docs[index]['isActive'],
                                      createdOn: snapshot.data!.docs[index]['createdOn'],
                                      city: snapshot.data!.docs[index]['city'],
                                      area: snapshot.data!.docs[index]['area'],
                                      deistic: snapshot.data!.docs[index]['deistic']);

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text("Add Address:"),
                                      // ListTile(
                                      //   title: Text(userModel.username),
                                      //   subtitle: Text(userModel.userAddress),
                                      // ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text("Delivery To: ",style: TextStyle(fontWeight: FontWeight.bold)),
                                          TextButton(
                                              style: const ButtonStyle(side: MaterialStatePropertyAll(BorderSide(color: Colors.black))),
                                              onPressed: (){}, child: const Text("Change")),
                                        ],
                                      )
                                    ],
                                  );
                                },
                              );
                            }

                            return Container();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              color: Colors.black12,
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Row(

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: Get.height * 0.14,
                                width: Get.width * 0.5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                      imageUrl: widget.cartModel.productImages[0],
                                      // placeholder: (context, url) => const CircularProgressIndicator(),
                                      fit: BoxFit.fill),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        const Text("Product : ",style: TextStyle(fontSize: 13)),
                                        Text(widget.cartModel.productName,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height*0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text("Quantity : ${widget.cartModel.productQuantity}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                        //Text(cartModel.productQuantity,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),

                                  SizedBox(
                                    height: Get.height*0.01,
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        Text("Rs: ${widget.cartModel.salePrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(widget.cartModel.fullPrice,style: const TextStyle(overflow: TextOverflow.ellipsis,decoration: TextDecoration.lineThrough,color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height*0.01,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Row(
                                      children: [
                                        //Text("Total : ${ int.parse(snapshot.data!.docs[index]['productQuantity']) * int.parse(snapshot.data!.docs[index]['salePrice'])}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                        Text("Total : ${widget.cartModel.fullPrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                        //Text(cartModel.productQuantity,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Card(
              elevation: 5,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Product Quantity: "),
                         Text(widget.cartModel.productQuantity),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Product Price: "),
                        Text((int.parse(widget.cartModel.productQuantity)*int.parse(widget.cartModel.salePrice)).toString()),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Product Total Price: "),
                        Text((int.parse(widget.cartModel.productQuantity)*int.parse(widget.cartModel.fullPrice)).toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
