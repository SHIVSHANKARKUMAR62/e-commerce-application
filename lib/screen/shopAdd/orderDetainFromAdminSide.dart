// orderDetainFromAdminSide


import 'package:admineccomerce/models/order-model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/user-model.dart';

class OrderDetainFromAdminSide extends StatefulWidget {

  final OrderModel orderModel;
  final String id;
  final UserModel userModel;

  const OrderDetainFromAdminSide({Key? key,required this.orderModel,required this.id,required this.userModel}) : super(key: key);

  @override
  State<OrderDetainFromAdminSide> createState() => _OrderDetainFromAdminSideState();
}

class _OrderDetainFromAdminSideState extends State<OrderDetainFromAdminSide> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ...List.generate(widget.orderModel.productImages.length, (index) =>Card(
                child: CachedNetworkImage(
                    imageUrl: widget.orderModel.productImages[index],
                    // placeholder: (context, url) => const CircularProgressIndicator(),
                    fit: BoxFit.fill),
              ) ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Product Name is: "),
                      Text(widget.orderModel.productName),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Text("Product Quantity: "),
                      Text(widget.orderModel.productQuantity),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Text("Product Total Price is: "),
                      Text(widget.orderModel.productTotalPrice),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Text("Customer Name: "),
                      Text(widget.orderModel.customerName),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Text("Customer Number: "),
                      Text(widget.orderModel.customerPhone),
                      const Divider(
                        color: Colors.black,
                      ),
                      const Text("Customer Address: "),
                      Text(widget.orderModel.customerAddress),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () async {
                    EasyLoading.show(status: "Please Wait...");
                    if(widget.orderModel.shop==false) {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(widget.id)
                          .update({
                        'shopAddress' : widget.userModel.userAddress,
                        'shop': true,
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                        Get.back();
                      });
                    }else{
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(widget.id)
                          .update({
                        'shopAddress' : "",
                        'shop': false,
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                        Get.back();
                      });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: Get.height*0.06,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: widget.orderModel.shop? Colors.blue:Colors.red,
                      ),
                      child: Center(child: widget.orderModel.shop? const Text("Accept Order"):const Text("Order Not Accepted")),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
