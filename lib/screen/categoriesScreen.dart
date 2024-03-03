import 'package:admineccomerce/screen/productsharing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/categories-model.dart';

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
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
              child: Text("No category found!"),
            ),
          );
        }

        if (snapshot.data != null) {
          return SizedBox(
            height: Get.height*0.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                var id = snapshot.data!.docs[index].id;
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],
                  categoryName: snapshot.data!.docs[index]['categoryName'],
                  createdAt: snapshot.data!.docs[index]['createdAt'],
                  updatedAt: snapshot.data!.docs[index]['updatedAt'],
                );
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.13,
                          width: Get.width * 0.5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                                imageUrl: categoriesModel.categoryImg,
                                fit: BoxFit.fill),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(categoriesModel.categoryName),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
