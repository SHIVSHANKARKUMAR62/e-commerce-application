import 'package:admineccomerce/userView/userOrderDetails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/order-model.dart';
import '../services/genrate-order-id-service.dart';

class UserOrderScreen extends StatefulWidget {
  const UserOrderScreen({Key? key}) : super(key: key);

  @override
  State<UserOrderScreen> createState() => _UserOrderScreenState();
}

class _UserOrderScreenState extends State<UserOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection('orders').where('customerId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("No Orders..."),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    height: Get.height*0.7,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return SizedBox(
                    height: Get.height*0.7,
                    child: const Center(
                      child: Text("No Orders..."),
                    ),
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
                      //print(id);
                      String orderId = generateOrderId();
                      OrderModel orderModel = OrderModel(
                          shopAddress: snapshot.data!.docs[index]['shopAddress'],
                        lot: snapshot.data!.docs[index]['lot'],
                        lat: snapshot.data!.docs[index]['lat'],
                        shop: snapshot.data!.docs[index]['shop'],
                        deliveryBoy: snapshot.data!.docs[index]['deliveryBoy'],
                          orderId: snapshot.data!.docs[index]['orderId'],
                          sellerId: snapshot.data!.docs[index]['sellerId'],
                          totalProduct: snapshot.data!.docs[index]['totalProduct'],
                          productId: snapshot.data!.docs[index]['productId'],
                          categoryId: snapshot.data!.docs[index]['customerId'],
                          productName: snapshot.data!.docs[index]['productName'],
                          categoryName: snapshot.data!.docs[index]['categoryName'],
                          salePrice: snapshot.data!.docs[index]['salePrice'],
                          fullPrice: snapshot.data!.docs[index]['fullPrice'],
                          productImages: snapshot.data!.docs[index]['productImages'],
                          deliveryTime: snapshot.data!.docs[index]['deliveryTime'],
                          isSale: snapshot.data!.docs[index]['isSale'],
                          productDescription: snapshot.data!.docs[index]['productDescription'],
                          createdAt: snapshot.data!.docs[index]['createdAt'],
                          updatedAt: snapshot.data!.docs[index]['updatedAt'],
                          productQuantity: snapshot.data!.docs[index]['productQuantity'],
                          productTotalPrice: snapshot.data!.docs[index]['productTotalPrice'],
                          customerId: snapshot.data!.docs[index]['customerId'],
                          status: snapshot.data!.docs[index]['status'],
                          customerName: snapshot.data!.docs[index]['customerName'],
                          customerPhone: snapshot.data!.docs[index]['customerPhone'],
                          customerAddress: snapshot.data!.docs[index]['customerAddress'],
                          customerDeviceToken: snapshot.data!.docs[index]['customerDeviceToken']);

                      //cartModel = cartModel;
                      return GestureDetector(
                        onTap: (){
                          Get.to(()=>UserOrderDetails(orderModel: orderModel));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            child: Card(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                          height: Get.height*0.15,
                                          width: Get.width*0.01,
                                          imageUrl: orderModel.productImages[0],
                                          // placeholder: (context, url) => const CircularProgressIndicator(),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  Expanded(

                                      child:
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                "Product : ${orderModel.productName}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                Text("Quantity : ${orderModel.productQuantity}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                //Text(cartModel.productQuantity,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                              ],
                                            ),
                                          ),


                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                Text("Rs: ${orderModel.salePrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(orderModel.fullPrice,style: const TextStyle(overflow: TextOverflow.ellipsis,decoration: TextDecoration.lineThrough,color: Colors.grey)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Row(
                                              children: [
                                                //Text("Total : ${ int.parse(snapshot.data!.docs[index]['productQuantity']) * int.parse(snapshot.data!.docs[index]['salePrice'])}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                Text("Total : ${orderModel.productTotalPrice}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                //Text(cartModel.productQuantity,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
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
            ),
          ],
        ),
      ),
    );
  }
}
