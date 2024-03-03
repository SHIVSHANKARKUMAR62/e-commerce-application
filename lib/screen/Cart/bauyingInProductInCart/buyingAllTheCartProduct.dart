//buyingAllTheCartProduct

import 'package:admineccomerce/models/cart-model.dart';
import 'package:admineccomerce/models/product-model.dart';
import 'package:admineccomerce/screen/Cart/bauyingInProductInCart/paymentMethodForAllCartProduct.dart';
import 'package:admineccomerce/screen/Cart/bauyingInProductInCart/paymentScreenForCart.dart';
import 'package:admineccomerce/userView/PayemntMethod/paymentScreen.dart';
import 'package:admineccomerce/userView/userAddress.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/cartTotalPrice.dart';
import '../../../controller/quantity.dart';
import '../../../models/userAddressModel.dart';

class BuyingAllTheCartProduct extends StatefulWidget {
  final TotalPriceCart totalPriceCart;
  final int quantity;
  final int outOfStock;
  const BuyingAllTheCartProduct(
      {Key? key,
        required this.outOfStock,
        required this.totalPriceCart,
        required this.quantity,
      })
      : super(key: key);

  @override
  State<BuyingAllTheCartProduct> createState() => _BuyingAllTheCartProductState();
}

class _BuyingAllTheCartProductState extends State<BuyingAllTheCartProduct> {
  // TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.totalPriceCart.factProductPrice();
  }


  @override
  Widget build(BuildContext context) {
    print(widget.quantity);
    print(widget.outOfStock);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Delivery Address: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                            style: const ButtonStyle(
                                side: MaterialStatePropertyAll(
                                    BorderSide(width: 2))),
                            onPressed: () {
                              Get.to(() => const UserAddress());
                            },
                            child: const Text("Change Address"))
                      ],
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("deliverAddress")
                          .where('uid',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text("Error"),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SizedBox(
                            height: Get.height / 5,
                            child: const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return   Column(
                            children: [
                              const Text("Add Your Address.."),
                              Column(
                                children: [
                                  const Divider(
                                    thickness: 2,
                                    color: Colors.black12,
                                  ),
                                  ListTile(
                                    title: const Text("Total Price is: "),
                                    subtitle: Text(widget.totalPriceCart.totalProduct.toString()),
                                  ),
                                ],
                              )
                            ],
                          );
                        }

                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              var id = snapshot.data!.docs[index].id;
                              UserAddressModel address = UserAddressModel(
                                  name: snapshot.data!.docs[index]['name'],
                                  phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                                  uid: snapshot.data!.docs[index]['uid'],
                                  address: snapshot.data!.docs[index]
                                  ['address'],
                                  latitude: snapshot.data!.docs[index]
                                  ['latitude'],
                                  longitude: snapshot.data!.docs[index]
                                  ['longitude']);
                              
                              return Column(
                                children: [
                                  Card(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: const Text("Name is: "),
                                          trailing: Text(address.name),
                                        ),
                                        ListTile(
                                          title: const Text("Phone Number is: "),
                                          trailing: Text(address.phoneNumber),
                                        ),
                                        ListTile(
                                          title: const Text("Address"),
                                          subtitle: Text(address.address),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Colors.black12,
                                  ),
                                  ListTile(
                                    title: const Text("Total Product is: "),
                                    subtitle: Obx(() => Text((widget.totalPriceCart.totalProduct.value - widget.quantity).toString())),
                                  ),
                                  ListTile(
                                    title: const Text("Total Price is: "),
                                    subtitle: Obx(() => Text((widget.totalPriceCart.totalP.value-widget.outOfStock).toString())),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: IconButton(
                                            onPressed: () {
                                              Get.to(()=>PaymentMethodForAllCartProduct(
                                                  totalQuantity: widget.totalPriceCart.totalProduct.value - widget.quantity,
                                                  totalValue: widget.totalPriceCart.totalP.value-widget.outOfStock,
                                                  totalPriceCart: widget.totalPriceCart, userAddressModel: address));
                                            },
                                            icon: Container(
                                              height: Get.height * 0.08,
                                              //width: Get.,
                                              decoration:
                                              const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .all(Radius
                                                      .circular(
                                                      20)),
                                                  color: Colors.blue),
                                              child: const Center(
                                                  child:
                                                  Text("Continue")),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
