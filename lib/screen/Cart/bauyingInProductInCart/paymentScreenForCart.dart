import 'package:admineccomerce/models/cart-model.dart';
import 'package:admineccomerce/models/product-model.dart';
import 'package:admineccomerce/models/userAddressModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/cartTotalPrice.dart';
import '../../../services/genrate-order-id-service.dart';
import '../../home.dart';


class PaymentScreenForCart extends StatefulWidget {
  final CartModel cartModel;
  final UserAddressModel userAddressModel;
  const PaymentScreenForCart({Key? key,required this.cartModel,required this.userAddressModel}) : super(key: key);

  @override
  State<PaymentScreenForCart> createState() => _PaymentScreenForCartState();
}

class _PaymentScreenForCartState extends State<PaymentScreenForCart> {

  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // CachedNetworkImage(
              //     imageUrl:
              //     widget.cartModel.productImages[
              //     0],
              //     fit: BoxFit
              //         .fill),
              Card(
                child: ListTile(
                  title: Text("Product (${widget.cartModel.productQuantity})Price"),
                  trailing: Text("Rs: ${widget.cartModel.productTotalPrice}"),
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
                      'sellerId' : widget.cartModel.ownerUid,
                      'totalProduct' : widget.cartModel.productQuantity,
                      'productId': widget.cartModel.pId,
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
                      'productTotalPrice': widget.cartModel.productTotalPrice,
                      'customerId': FirebaseAuth.instance.currentUser!.uid,
                      'status': false,
                      'customerName': widget.userAddressModel.name,
                      'customerPhone': widget.userAddressModel.phoneNumber,
                      'customerAddress': widget.userAddressModel.address,
                      'customerDeviceToken': "",
                    }).whenComplete(() async{
                      await FirebaseFirestore.instance.collection("products").doc(widget.cartModel.pId).update({
                        'quantity': (int.parse(widget.cartModel.tP) - int.parse(widget.cartModel.productQuantity)).toString()
                      }).whenComplete(() {
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
                   // qController.quantity.value = 1;
                    EasyLoading.dismiss();
                  },
                  title: Text("Cash On Delivery"),
                  trailing: Icon(Icons.payment),
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
      ),
    );
  }
}

