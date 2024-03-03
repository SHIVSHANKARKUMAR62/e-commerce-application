import 'package:admineccomerce/models/order-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/user-model.dart';

class UserOrderDetails extends StatefulWidget {

  final OrderModel orderModel;

  const UserOrderDetails({Key? key,required this.orderModel}) : super(key: key);

  @override
  State<UserOrderDetails> createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
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
              Text("Shop Details",style: TextStyle(fontSize: Get.width*0.06)),
              Card(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('users').doc(widget.orderModel.sellerId).collection("shop").snapshots(),
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
                                      subtitle: Text(userModel.shopName)
                                  ),
                                  ListTile(
                                    title: const Text("Shop Address"),
                                    subtitle: Text(userModel.userAddress)
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
              ),
              Text("Orders Details",style: TextStyle(fontSize: Get.width*0.06)),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Order Id Is: "),
                      subtitle: Text(widget.orderModel.orderId),
                    ),
                    ListTile(
                      title: const Text("Name of Product: "),
                      subtitle: Text(widget.orderModel.productName),
                    ),
                    ListTile(
                      title: const Text("Number of Products: "),
                      subtitle: Text(widget.orderModel.productQuantity),
                    ),
                    ListTile(
                      title: const Text("Products Price: "),
                      subtitle: Text(widget.orderModel.productTotalPrice),
                    ),
                    ListTile(
                      title: const Text("Is Your Product Accepted By Seller ?"),
                      trailing: widget.orderModel.shop?Text("Accepted",style: TextStyle(color: Colors.blue,fontSize: Get.width*0.04)):Text("Not Accepted",style: TextStyle(color: Colors.red,fontSize: Get.width*0.04)),
                    ),
                  ],
                ),
              ),
              Text("Delivery Boy's Details",style: TextStyle(fontSize: Get.width*0.06)),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text("Is Your Product Accepted By Delivery Boy ?"),
                      trailing: widget.orderModel.deliveryBoy?Text("Accepted",style: TextStyle(color: Colors.blue,fontSize: Get.width*0.04)):Text("Not Accepted",style: TextStyle(color: Colors.red,fontSize: Get.width*0.04)),
                    ),
                    ListTile(
                      title: const Text("Number: "),
                      trailing: widget.orderModel.deliveryBoy?Text("6299028270",style: TextStyle(color: Colors.blue,fontSize: Get.width*0.04)):Text("Not Accepted",style: TextStyle(color: Colors.red,fontSize: Get.width*0.04)),
                    ),
                    ListTile(
                      title: const Text("Live Location of Delivery boy ?"),
                      trailing: IconButton(onPressed: (){}, icon: const Icon(Icons.start)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
