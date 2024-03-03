import 'package:admineccomerce/models/product-model.dart';
import 'package:admineccomerce/models/userAddressModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/cartTotalPrice.dart';
import '../../controller/quantity.dart';
import '../../screen/home.dart';
import '../../services/genrate-order-id-service.dart';

class PaymentScreen extends StatefulWidget {
  final ProductModel productModel;
  final String productQuantity;
  final String productTotalPrice;
  final String productId;
  final UserAddressModel userAddressModel;
  const PaymentScreen({Key? key,required this.userAddressModel,required this.productId,required this.productQuantity,required this.productModel,required this.productTotalPrice,}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  Quantity qController = Get.put(Quantity());
  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // CachedNetworkImage(
            //     imageUrl:
            //     widget.productModel.productImages[
            //     0],
            //     fit: BoxFit
            //         .fill),
            Card(
              child: ListTile(
                title: Text("Product (${widget.productQuantity})Price"),
                trailing: Text("Rs: ${widget.productTotalPrice}"),
              ),
            ),
             Card(
              child: ListTile(
                onTap: ()async {
                  totalPriceCart.factProductPrice();
                  String orderId = generateOrderId();
                  EasyLoading.show(status: "Buying...");
                  await FirebaseFirestore.instance
                      .collection('orders').doc(orderId)
                      .set({
                    'shopAddress' : "",
                    'deliveryBoy' : false,
                    'shop' : false,
                    'lot' : widget.userAddressModel.longitude,
                    'lat' : widget.userAddressModel.latitude,
                    'orderId' : orderId,
                    'sellerId' : widget.productModel.userUid,
                    'totalProduct' : widget.productModel.quantity,
                    'productId': widget.productId,
                    'ownerUid': widget.productModel.userUid,
                    'productName': widget.productModel.productName,
                    'categoryName': widget.productModel.categoryName,
                    'salePrice': widget.productModel.salePrice,
                    'fullPrice': widget.productModel.fullPrice,
                    'productImages': widget.productModel.productImages,
                    'deliveryTime': widget.productModel.deliveryTime,
                    'isSale': widget.productModel.isSale,
                    'productDescription': widget.productModel.productDescription,
                    'createdAt': DateTime.now(),
                    'updatedAt': widget.productModel.updatedAt,
                    'productQuantity': widget.productQuantity,
                    'productTotalPrice': widget.productTotalPrice,
                    'customerId': FirebaseAuth.instance.currentUser!.uid,
                    'status': false,
                    'customerName': widget.userAddressModel.name,
                    'customerPhone': widget.userAddressModel.phoneNumber,
                    'customerAddress': widget.userAddressModel.address,
                    'customerDeviceToken': "",
                  }).whenComplete(() async{
                    await FirebaseFirestore.instance.collection("products").doc(widget.productId).update({
                      'quantity': (int.parse(widget.productModel.quantity) - int.parse(widget.productQuantity)).toString()
                    }).whenComplete(()async {

                      await
                      Get.snackbar(
                        "Order Successful",
                        "Thank you for your order!",
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 5),
                      );
                      Get.offAll(()=>const Home());});
                  });
// Get.to(()=>const Home());
                  qController.quantity.value = 1;
                  EasyLoading.dismiss();
                },
                title: const Text("Cash On Delivery"),
                trailing: const Icon(Icons.payment),
              ),
            ),
            const Card(
              child: ListTile(
                title: Text("Online Payment"),
                trailing: Icon(Icons.payments_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

