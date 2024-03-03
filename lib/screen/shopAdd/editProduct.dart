import 'dart:io';

import 'package:admineccomerce/models/product-model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../home.dart';

class EditProduct extends StatefulWidget {

  final ProductModel productModel;
  final String id;
  const EditProduct({Key? key,required this.productModel, required this.id}) : super(key: key);

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  bool popular = false;

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final quantityController = TextEditingController();

  File? pImage ;

  var key = GlobalKey<FormState>();

  dynamic image;
  String? fileName;
  dynamic post;

  String? selectValue;
  final imagePicker = ImagePicker();
  List<XFile> images = [];
  List<String> imagesUrls = [];

  @override
  void dispose() {
    // TODO: implement dispose
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = widget.productModel.productName;
    desController.text = widget.productModel.productDescription;
    priceController.text = widget.productModel.salePrice;
    discountController.text = widget.productModel.fullPrice;
    quantityController.text = widget.productModel.quantity;
    popular = widget.productModel.isSale;
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Product"),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Form(
                  key: key,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: "Enter Product Name with units(kg,gram,liter,milliliter)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please fill the product name with units(kg,gram,liter,milliliter)";
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Get.height*0.02,
                      ),
                      TextFormField(
                        controller: desController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Enter Product Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please fill the description";
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Get.height*0.02,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: discountController,
                        decoration: InputDecoration(
                          hintText: "Enter total price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter total price";
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Get.height*0.02,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: InputDecoration(
                          hintText: "Enter sale Price",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter sale price";
                          }else{
                            return null;
                          }
                        },
                      ),
                      SizedBox(
                        height: Get.height*0.02,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: quantityController,
                        decoration: InputDecoration(
                          hintText: "Enter Product quantity",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter the quantity";
                          }else{
                            return null;
                          }
                        },
                      ),
                    ],
                  )
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Product is sale?"),
                  Switch(
                      inactiveThumbColor: Colors.blue,
                      value: popular,
                      onChanged: (value){
                        setState(() {
                          popular = value;
                        });
                      }),
                ],
              ),
              SizedBox(
                height: Get.height*0.02,
              ),
              GestureDetector(

                onTap: () async {
                  if(key.currentState!.validate()){
                    save();
                  }
                },
                child: Container(
                  height: Get.height*0.08,
                  width: Get.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade300
                  ),
                  child: Center(child: Text("Update",style: TextStyle(fontSize: Get.width*0.06),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  pickImages() async{
    final List<XFile> pick = await imagePicker.pickMultiImage();
    if(pick.isNotEmpty){
      setState(() {
        images.addAll(pick);
      });
    }else{
      print("Images not selected");
    }
  }

  Future postImages(XFile? imagesFile) async {
    String urls;
    Reference ref = FirebaseStorage.instance.ref().child("postImages").child(imagesFile!.name);
    await ref.putData(await imagesFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"));
    urls = await ref.getDownloadURL();
    return urls;
  }

  uploadImages() async{
    for(var image in images){
      await postImages(image).then((value) => imagesUrls.add(value));
    }
  }

  save() async {
    EasyLoading.show(status: "Updating...");
    await FirebaseFirestore.instance.collection("products").doc(widget.id).update({
      //'categoryId' : widget.id,
      'productName': nameController.text.trim(),
      'categoryName': widget.productModel.categoryName,
      'salePrice': priceController.text,
      'fullPrice': discountController.text,
      'isSale': popular,
      'productDescription': desController.text,
      'createdAt': DateTime.now(),
      'quantity': quantityController.text,
    }).whenComplete(() {
      // print(FirebaseFirestore.instance.collection("products").path);
      nameController.clear();
      desController.clear();
      priceController.clear();
      discountController.clear();
      setState(() {
        imagesUrls = [];
        images = [];
        popular = false;
      });
      EasyLoading.dismiss();
      Get.offAll(()=>const Home());
    });
  }

}
