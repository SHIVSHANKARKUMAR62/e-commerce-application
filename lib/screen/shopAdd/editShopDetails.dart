import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user-model.dart';
import '../home.dart';


class EditShopDetails extends StatefulWidget {
  final UserModel userModel;

  const EditShopDetails({Key? key,required this.userModel}) : super(key: key);

  @override
  State<EditShopDetails> createState() => _EditShopDetailsState();
}

class _EditShopDetailsState extends State<EditShopDetails> {

  dynamic image;
  String? fileName;
  dynamic post;
  File? shopProfile;
  String? name;

  var shopNameController = TextEditingController();
  var shopStateController = TextEditingController();
  var shopPhoneNumberController = TextEditingController();
  var shopStreetController = TextEditingController();
  var shopAddressController = TextEditingController();
  var gstNumberController = TextEditingController();
  var areaController = TextEditingController();
  var deisticController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }


  final _key = GlobalKey<FormState>();

  bool gstHave = false;

  @override
  Widget build(BuildContext context) {
    shopNameController.text = widget.userModel.shopName.toString();
    shopStateController.text = widget.userModel.country.toString();
    shopAddressController.text = widget.userModel.userAddress.toString();
    deisticController.text = widget.userModel.deistic.toString();
    areaController.text = widget.userModel.area.toString();
    shopStreetController.text = widget.userModel.street.toString();
    shopPhoneNumberController.text = widget.userModel.phone.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Shop Details"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async{
                  XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 200);
                  if(selectedImage != null){
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      shopProfile = convertedFile;
                      name = selectedImage.name;
                    });
                  }
                },
                child: Stack(
                  children: [
                    Positioned(child: Container(
                      height: Get.height*0.27,
                      width: double.infinity,
                      color: Colors.blue.shade100,
                    )),
                    Positioned(
                      top: Get.height*0.13,
                      left: Get.width*0.28,
                      child: Center(
                        child: Container(
                          height: Get.height*0.14,
                          width: Get.width*0.4,
                          color: Colors.black,
                          child: shopProfile!=null?Image.file(shopProfile!,fit: BoxFit.fill,):widget.userModel.userImg.isNotEmpty?Image.network(widget.userModel.userImg,fit: BoxFit.fill,):const Center(child: Icon(Icons.add,color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: shopNameController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Name"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Name";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: shopStateController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop State"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop State";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: deisticController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Deistic"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Deistic";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: areaController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Area"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Area";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: shopPhoneNumberController,
                  keyboardType: const TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Phone Number"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Phone Number";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: shopStreetController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Street"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Street";
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
                  controller: shopAddressController,
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Shop Address"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Shop Address";
                    }else{
                      return null;
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Have you GST Number? ",style: TextStyle(fontSize: Get.width*0.05,fontWeight: FontWeight.bold)),
                  Switch(value: gstHave, onChanged: (value){
                    setState(() {
                      if(gstHave==false) {
                        gstHave = true;
                      }else{
                        gstHave = false;
                      }
                    });
                  }),
                ],
              ),
              gstHave?Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: gstNumberController,
                  keyboardType: const TextInputType.numberWithOptions(signed: true,decimal: true),
                  decoration: InputDecoration(
                    //hintText: "Enter Shop Name",
                      label: const Text("Enter Your GST Number"),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter GST Number";
                    }else{
                      return null;
                    }
                  },
                ),
              ):Container(),
              GestureDetector(
                onTap: () async {
                  EasyLoading.show(status: "Updating...");
                  try{
                    if(_key.currentState!.validate() && shopProfile != null ) {
                        Reference ref = FirebaseStorage.instance.ref().child(
                            "shopPicture").child(name!);
                        UploadTask uploadTask = ref.putFile(File(shopProfile!
                            .path));
                        TaskSnapshot snapshot = await uploadTask;
                        String downloadUrl = await snapshot.ref
                            .getDownloadURL();
                        await FirebaseFirestore.instance.collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("shop").doc(FirebaseAuth.instance
                            .currentUser!.uid).update({
                          'shopName': shopNameController.text.trim(),
                          'uId': FirebaseAuth.instance.currentUser!.uid,
                          'username': FirebaseAuth.instance.currentUser!
                              .displayName,
                          'email': FirebaseAuth.instance.currentUser!.email,
                          'phone': shopPhoneNumberController.text,
                          'userImg': downloadUrl,
                          'userDeviceToken': "",
                          'country': shopStateController.text,
                          'userAddress': shopAddressController.text,
                          'street': shopStreetController.text,
                          'isAdmin': widget.userModel.isAdmin,
                          'isActive': widget.userModel.isActive,
                          'city': areaController.text,
                          'longitude': "",
                          'latitude': " ",
                          'deistic': deisticController.text,
                          'area': areaController.text,
                        })
                            .whenComplete(() {
                          EasyLoading.dismiss();
                          Get.offAll(() => const Home());
                        });
                      }else{
                        await FirebaseFirestore.instance.collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection("shop").doc(FirebaseAuth.instance
                            .currentUser!.uid).update({
                          'shopName': shopNameController.text.trim(),
                          'uId': FirebaseAuth.instance.currentUser!.uid,
                          'username': FirebaseAuth.instance.currentUser!
                              .displayName,
                          'email': FirebaseAuth.instance.currentUser!.email,
                          'phone': shopPhoneNumberController.text,
                          'userImg': widget.userModel.userImg,
                          'userDeviceToken': "",
                          'country': shopStateController.text,
                          'userAddress': shopAddressController.text,
                          'street': shopStreetController.text,
                          'city': areaController.text,
                          'longitude': "",
                          'latitude': " ",
                          'deistic': deisticController.text,
                          'area': areaController.text,
                        })
                            .whenComplete(() {
                          EasyLoading.dismiss();
                          Get.offAll(() => const Home());
                        });
                      }
                  }on FirebaseAuthException catch (e){
                    EasyLoading.dismiss();
                    Get.showSnackbar(
                        GetSnackBar(title: "Error",message: "Something is wrong...",backgroundColor: Colors.blue.shade100,)
                    );
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
                    child: Center(child: Text("Create Your Shop",style: TextStyle(fontSize: Get.width*0.05),)),
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
