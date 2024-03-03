import 'package:admineccomerce/models/user-model.dart';
import 'package:admineccomerce/screen/Cart/CategoriesAll.dart';
import 'package:admineccomerce/screen/categories.dart';
import 'package:admineccomerce/screen/categoriesScreen.dart';
import 'package:admineccomerce/screen/loginScreen/loginPage.dart';
import 'package:admineccomerce/screen/product.dart';
import 'package:admineccomerce/screen/productScreen.dart';
import 'package:admineccomerce/screen/shopAdd/shop.dart';
import 'package:admineccomerce/screen/shopAdd/shopDetails.dart';
import 'package:admineccomerce/screen/userProductScreen/userProductScreen.dart';
import 'package:admineccomerce/userView/editUserProfileDetails.dart';
import 'package:admineccomerce/userView/userOrder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cartTotalPrice.dart';
import '../models/userData.dart';
import '../widget/BannerWidget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPriceCart.factProductPrice();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.blue.shade100,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').where('uId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
                child: Text("No user found..."),
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
                  UserData userModel = UserData(
                      uId: snapshot.data!.docs[index]['uId'],
                      username: snapshot.data!.docs[index]['username'],
                      email: snapshot.data!.docs[index]['email'],
                    img: snapshot.data!.docs[index]['img']
                  );
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: Get.height*0.14,
                            width: Get.width*0.3,
                            //child: Image.asset("lottie/img.png",fit: BoxFit.fill,),
                            child:  userModel.img.isEmpty?Image.asset("lottie/img.png",fit: BoxFit.fill,):Image.network(snapshot.data!.docs[index]['img'],fit: BoxFit.fill),
                          ),
                          Padding(
                            padding: const EdgeInsets.all( 8.0),
                            child: Text(userModel.username,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(userModel.email,style: const TextStyle(overflow: TextOverflow.ellipsis)),
                          ),
                          const Divider(
                            thickness: 2,
                            color: Colors.black,
                          ),
                          ListTile(
                            onTap: (){
                              Get.to(()=>const UserOrderScreen());
                            },
                            leading: const Icon(Icons.food_bank_outlined),
                            title: const Text("Your Order"),
                          ),
                          ListTile(
                            onTap: (){
                              Get.to(()=>Shop(userData: userModel,uid: id,));
                            },
                            leading: const Icon(Icons.shop),
                            title: const Text("Add Your Shop"),
                          ),
                          ListTile(
                            onTap: (){
                              Get.to(()=>EditUserProfileDetails(userModel : userModel));
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text("Edit Your Profile"),
                          ),
                          ListTile(
                            onTap: (){
                              Get.to(()=>ShopDetails(uid: id,userData: userModel,));
                            },
                            leading: const Icon(Icons.shop_two_outlined),
                            title: const Text("Your Shop"),
                          ),
                          ListTile(
                            onTap: ()async {
                              await FirebaseAuth.instance.signOut().whenComplete(() => Get.offAll(()=>const LoginPage()));
                            },
                            leading: const Icon(Icons.food_bank_outlined),
                            title: const Text("Log Out"),
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
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Foodie"),
      ),
      body:  SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height / 90.0,
            ),
            //banners
            const BannerWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Categories",style: TextStyle(fontSize: 20),),
                  TextButton(onPressed: (){
                    Get.to(()=>const CategroiesAll());
                  }, child: const Text("See All",))
                ],
              ),
            ),
            const AllCategoriesScreen(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Products",style: TextStyle(fontSize: 20),),
                  TextButton(onPressed: (){
                    Get.to(()=>const Product());
                  }, child: const Text("See All",))
                ],
              ),
            ),
            const ProductScreen(),

            //heading
            // HeadingWidget(
            //   headingTitle: "Categories",
            //   headingSubTitle: "According to your budget",
            //   onTap: () => Get.to(() => AllCategoriesScreen()),
            //   buttonText: "See More >",
            // ),

            // CategoriesWidget(),

            //heading
            // HeadingWidget(
            //   headingTitle: "Flash Sale",
            //   headingSubTitle: "According to your budget",
            //   onTap: () => Get.to(() => AllFlashSaleProductScreen()),
            //   buttonText: "See More >",
            // ),

            // FlashSaleWidget(),
            //
            // //heading
            // HeadingWidget(
            //   headingTitle: "All Products",
            //   headingSubTitle: "According to your budget",
            //   onTap: () => Get.to(() => AllProductsScreen()),
            //   buttonText: "See More >",
            // ),

            // AllProductsWidget(),
          ],
        ),
      ),
    );
  }
}

// StreamBuilder(
//                         //   stream: FirebaseFirestore.instance.collection('users').where('uId',isEqualTo: FirebaseAuth.instance.currentUser!.uid).snapshots(),
//                         //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                         //     if (snapshot.hasError) {
//                         //       return const Center(
//                         //         child: Text("Error"),
//                         //       );
//                         //     }
//                         //     if (snapshot.connectionState == ConnectionState.waiting) {
//                         //       return SizedBox(
//                         //         height: Get.height/5,
//                         //         child: const Center(
//                         //           child: CupertinoActivityIndicator(),
//                         //         ),
//                         //       );
//                         //     }
//                         //
//                         //     if (snapshot.data!.docs.isEmpty) {
//                         //       return const Center(
//                         //         child: Text("No user found..."),
//                         //       );
//                         //     }
//                         //
//                         //     if (snapshot.data != null) {
//                         //       return ListView.builder(
//                         //         itemCount: snapshot.data!.docs.length,
//                         //         shrinkWrap: true,
//                         //         physics: const BouncingScrollPhysics(),
//                         //         itemBuilder: (context, index) {
//                         //           var id = snapshot.data!.docs[index].id;
//                         //           print(id);
//                         //           UserData userModel = UserData(
//                         //             uId: snapshot.data!.docs[index]['uId'],
//                         //             username: snapshot.data!.docs[index]['username'],
//                         //             email: snapshot.data!.docs[index]['email'],
//                         //           );
//                         //           return Padding(
//                         //             padding: const EdgeInsets.all(8.0),
//                         //             child: SizedBox(
//                         //               child: Column(
//                         //                 crossAxisAlignment: CrossAxisAlignment.center,
//                         //                 children: [
//                         //                   SizedBox(
//                         //                     child: ListTile(
//                         //                       onTap: (){
//                         //                         //Get.to(()=>userModel.isAdmin? const CategoriesScreen():const CategroiesAll(),);
//                         //                         Get.to(()=>const CategoriesScreen());
//                         //                       },
//                         //                       leading: const Icon(Icons.shopping_bag_outlined),
//                         //                       title: const Text("Share Product"),
//                         //                     ),
//                         //                   )
//                         //                 ],
//                         //               ),
//                         //             ),
//                         //           );
//                         //         },
//                         //       );
//                         //     }
//                         //
//                         //     return Container();
//                         //   },
//                         // ),
