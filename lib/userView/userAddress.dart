import 'dart:developer';

import 'package:admineccomerce/models/userAddressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import 'addressController/useraddressController.dart';

class UserAddress extends StatefulWidget {
  const UserAddress({Key? key}) : super(key: key);

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {



  UserAddressController addressController = Get.put(UserAddressController());

  final _key = GlobalKey<FormState>();

  bool gstHave = false;


  @override
  Widget build(BuildContext context) {

    String? total;

    return Scaffold(
      appBar: AppBar(title: const Text("Selected Address")),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: addressController.nameController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Your Name"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Your Name";
                    }else{
                      return null;
                    }
                  },
                ),
              ),Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: addressController.phoneController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Phone Number"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Phone Number";
                    }else{
                      return null;
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 4,
                  controller: addressController.controller,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Address"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Address";
                    }else{
                      return null;
                    }
                  },
                ),
              ),

              GestureDetector(
                onTap: () async {
                    if (_key.currentState!.validate()) {
                      addressController.getLongLang();
                    }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: Get.height*0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blue
                    ),
                    child: Center(child: Text("Add Address",style: TextStyle(fontSize: Get.width*0.05),)),
                  ),
                ),
              ),

              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("address").snapshots(),
                builder: (context, snapshot) {
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
                      child: Text("Add Your Address.."),
                    );
                  }



                  return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var id = snapshot.data!.docs[index].id;
                    UserAddressModel address  = UserAddressModel(
                      phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                      name: snapshot.data!.docs[index]['name'],
                      uid: snapshot.data!.docs[index]['uid'],
                        address: snapshot.data!.docs[index]['address'],
                        latitude: snapshot.data!.docs[index]['latitude'],
                        longitude: snapshot.data!.docs[index]['longitude']);
                    return Card(
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
                            trailing: TextButton(
                                style: const ButtonStyle(side: MaterialStatePropertyAll(BorderSide(width: 2))),
                                onPressed: () async {
                              try{
                                EasyLoading.show( status: "Add Address");
                                await FirebaseFirestore.instance.collection("deliverAddress").doc(
                                    FirebaseAuth.instance.currentUser!.uid).set({
                                  'phoneNumber' : address.phoneNumber,
                                  'name' : address.name,
                                  'address': address.address,
                                  'longitude': address.longitude,
                                  'latitude': address.latitude,
                                  'uid' : address.uid}).whenComplete(() {
                                  EasyLoading.dismiss();
                                });
                              }on FirebaseAuthException catch(e){
                                EasyLoading.dismiss();
                                log(e.code);
                              }
                            },child: const Text("Deliver Address")),
                          )
                        ],
                      ),
                    );
                  }
                  );

              },)

            ],
          ),
        ),
      ),
    );
  }
}
