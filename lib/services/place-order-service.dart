import 'package:admineccomerce/screen/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../models/order-model.dart';
import 'genrate-order-id-service.dart';

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
  required String customerDeviceToken,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  EasyLoading.show(status: "Please Wait..");
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();


      List<QueryDocumentSnapshot> documents = querySnapshot.docs;

      // final QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
      //     .instance
      //     .collection('products')
      //     .get();
      //   for(int j=0;j<querySnapshot.docs.length;j++){
      //     if(int.parse(snapshot2.docs[i]['quantity'])==0&&snapshot2.docs[i]['userUid']==querySnapshot.docs[j]['ownerUid']){
      //       querySnapshot.docs.;
      //     }
      //   }
      // }


      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;

        String orderId = generateOrderId();
        print(data);

        OrderModel cartModel = OrderModel(
          shopAddress: "",
          lat: "",
          lot: "",
          shop: false,
          deliveryBoy: false,
          orderId: orderId,
          sellerId: data['user'],
          totalProduct: data['tP'],
          productId: data['pId'],
          categoryId: data['id'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: (data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
          customerDeviceToken: customerDeviceToken,
        );

        for (var x = 0; x < documents.length; x++) {

          //upload orders
          await FirebaseFirestore.instance
              .collection('orders').doc(orderId)
              .set(cartModel.toMap());

          // product changing
          await FirebaseFirestore.instance.collection("products").doc(cartModel.productId).update({
            'quantity': (int.parse(cartModel.totalProduct)-int.parse(cartModel.productQuantity)).toString()
          }).whenComplete(() => null);
          // Get.to(()=>const Home());

          //delete cart products
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $cartModel.productId.toString()');
          });
        }
      }

      print("Order Confirmed");
      Get.snackbar(
        "Order Confirmed",
        "Thank you for your order!",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      EasyLoading.dismiss();
      Get.offAll(() => const Home());
    } catch (e) {
      print("error $e");
    }
  }
}