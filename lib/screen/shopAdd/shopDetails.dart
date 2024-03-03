import 'package:admineccomerce/models/user-model.dart';
import 'package:admineccomerce/screen/shopAdd/editShopDetails.dart';
import 'package:admineccomerce/screen/shopAdd/orderSCreen.dart';
import 'package:admineccomerce/screen/productScreen.dart';
import 'package:admineccomerce/screen/shopAdd/allOrdersScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/userData.dart';
import '../Cart/CategoriesAll.dart';
import '../categories.dart';
import '../product.dart';
import 'product.dart';
import 'acceptedOrder.dart';

class ShopDetails extends StatefulWidget {
  final UserData userData;
  final String uid;
  const ShopDetails({Key? key,required this.userData,required this.uid}) : super(key: key);

  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Shop")),
      body: SingleChildScrollView(
        child: Column(
          children: [
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

                                  if(userModel.isActive){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ListTile(
                                              title: const Text("Your Shop Address"),
                                              subtitle: Text(userModel.userAddress),
                                            ),
                                            const Divider(
                                              thickness: 2,
                                              color: Colors.black,
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>const AllOrderScreen());
                                              },
                                              leading: const Icon(Icons.food_bank_outlined,),
                                              title: const Text("All Orders"),
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>const OrderScreen());
                                              },
                                              leading: const Icon(Icons.food_bank_outlined,color: Colors.red,),
                                              title: const Text("Not Accepted Orders"),
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>const AcceptedOrder());
                                              },
                                              leading: const Icon(Icons.food_bank_outlined,color: Colors.blue,),
                                              title: const Text("Accepted Orders"),
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>userModel.isAdmin? const CategoriesScreen():const CategroiesAll(),);
                                                //Get.to(()=>const CategoriesScreen());
                                              },
                                              leading: const Icon(Icons.shopping_bag_outlined),
                                              title: const Text("Share Your Dish"),
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>EditShopDetails(userModel: userModel,));
                                              },
                                              leading: const Icon(Icons.edit),
                                              title: const Text("Edit Your Shop Details"),
                                            ),
                                            ListTile(
                                              onTap: (){
                                                Get.to(()=>ProductPartAdmin(id: id,));
                                              },
                                              leading: const Icon(Icons.production_quantity_limits),
                                              title: const Text("Your Product"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }else if(userModel.isAdmin){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: Get.height*0.4,
                                            width: Get.width*0.5,
                                            child: userModel.userImg.isEmpty?const Center(child: Text("No Image")):Image.network(userModel.userImg),
                                          ),
                                          Text("Hello Mr/Mrs ${userModel.username}"),
                                          const Text("Thank You For Joining..."),
                                          const Text("Please wait for owner response..."),
                                          const Text("Very Soon They Give You Approble For Selling Your Product...")

                                        ],
                                      ),
                                    );
                                  }
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
