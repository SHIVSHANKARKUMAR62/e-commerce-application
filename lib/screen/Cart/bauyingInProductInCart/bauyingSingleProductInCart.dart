import 'package:admineccomerce/models/cart-model.dart';
import 'package:admineccomerce/models/product-model.dart';
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

class BuyingSingleProductScreen extends StatefulWidget {
  final CartModel cartModel;
  const BuyingSingleProductScreen(
      {Key? key,
        required this.cartModel,
      })
      : super(key: key);

  @override
  State<BuyingSingleProductScreen> createState() => _BuyingSingleProductScreenState();
}

class _BuyingSingleProductScreenState extends State<BuyingSingleProductScreen> {
  Quantity qController = Get.put(Quantity());
  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());
  @override
  Widget build(BuildContext context) {

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
                          return  Column(
                            children: [
                              const Text("Add Your Address.."),
                              Column(
                                children: [
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
                                              padding:
                                              const EdgeInsets.all(
                                                  8.0),
                                              child: SizedBox(
                                                child: Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(
                                                      height: Get.height *
                                                          0.14,
                                                      width:
                                                      Get.width * 0.5,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5),
                                                        child:
                                                        CachedNetworkImage(
                                                            imageUrl:
                                                            widget.cartModel.productImages[
                                                            0],
                                                            // placeholder: (context, url) => const CircularProgressIndicator(),
                                                            fit: BoxFit
                                                                .fill),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0),
                                                          child: Row(
                                                            children: [
                                                              const Text(
                                                                  "Product : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      13)),
                                                              Text(
                                                                  widget
                                                                      .cartModel
                                                                      .productName,
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                      TextOverflow.ellipsis)),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                          Get.height *
                                                              0.01,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  "Quantity : ${widget.cartModel.productQuantity}",
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                      TextOverflow.ellipsis)),
                                                              //Text(cartModel.productQuantity,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                          Get.height *
                                                              0.01,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                  "Rs: ${widget.cartModel.salePrice}",
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                      TextOverflow.ellipsis)),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .only(
                                                                    left:
                                                                    8.0),
                                                                child: Text(
                                                                    widget
                                                                        .cartModel
                                                                        .fullPrice,
                                                                    style: const TextStyle(
                                                                        overflow: TextOverflow.ellipsis,
                                                                        decoration: TextDecoration.lineThrough,
                                                                        color: Colors.grey)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                          Get.height *
                                                              0.01,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(
                                                              left:
                                                              8.0),
                                                          child: Row(
                                                            children: [
                                                              //Text("Total : ${ int.parse(snapshot.data!.docs[index]['productQuantity']) * int.parse(snapshot.data!.docs[index]['salePrice'])}",style: const TextStyle(overflow: TextOverflow.ellipsis)),
                                                              Text(
                                                                  "Total : ${widget.cartModel.fullPrice}",
                                                                  style: const TextStyle(
                                                                      overflow:
                                                                      TextOverflow.ellipsis)),
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
                                  Card(
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: Get.height *
                                              0.14,
                                          width:
                                          Get.width * 0.5,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                                5),
                                            child:
                                            CachedNetworkImage(
                                                imageUrl:
                                                widget.cartModel.productImages[
                                                0],
                                                // placeholder: (context, url) => const CircularProgressIndicator(),
                                                fit: BoxFit
                                                    .fill),
                                          ),
                                        ),
                                        const Text(
                                            "Product : ",
                                            style: TextStyle(
                                                fontSize:
                                                13)),
                                        Text(
                                            widget
                                                .cartModel
                                                .productName,
                                            style: const TextStyle(
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(
                                          height:
                                          Get.height *
                                              0.01,
                                        ),
                                        Text(
                                            "Quantity : ${widget.cartModel.productQuantity}",
                                            style: const TextStyle(
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(
                                          height:
                                          Get.height *
                                              0.01,
                                        ),
                                        Text(
                                            "Rs: ${widget.cartModel.salePrice}",
                                            style: const TextStyle(
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        Padding(
                                          padding: const EdgeInsets
                                              .only(
                                              left:
                                              8.0),
                                          child: Text(
                                              widget
                                                  .cartModel
                                                  .fullPrice,
                                              style: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.grey)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Card(
                                    elevation: 5,
                                    child: Column(
                                      children: [
                                        const Text("Product Quantity: "),
                                        Text(widget.cartModel.productQuantity),
                                        const Text("Product price:"),
                                        Text(widget.cartModel.productTotalPrice),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Container(
                                                height: Get.height * 0.08,
                                                //width: 180,
                                                decoration:
                                                const BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          20)),
                                                  //border: Border.all(color: Colors.black )
                                                ),
                                                child: Center(
                                                    child: Obx(
                                                          () => ListTile(
                                                          title: Text(
                                                              "Price: ${qController.quantity.value * int.parse(widget.cartModel.fullPrice)}",
                                                              style: const TextStyle(
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough)),
                                                          subtitle: Text(
                                                            ("Sale Price: ${qController.quantity.value * int.parse(widget.cartModel.salePrice)}"),
                                                          )),
                                                    )),
                                              ))),
                                      Expanded(
                                        child: IconButton(
                                            onPressed: () {
                                             Get.to(()=>PaymentScreenForCart(cartModel: widget.cartModel, userAddressModel: address));
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
