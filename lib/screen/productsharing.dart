import 'dart:io';
import 'dart:math';

import 'package:admineccomerce/screen/home.dart';
import 'package:admineccomerce/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class ProductSharing extends StatefulWidget {
  final data,id;

  const ProductSharing({Key? key,required this.data,required this.id}) : super(key: key);

  @override
  State<ProductSharing> createState() => _ProductSharingState();
}

class _ProductSharingState extends State<ProductSharing> {

  bool popular = false;

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  TextEditingController nameController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(FirebaseFirestore.instance.collection("products").doc().id);
  }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Product"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              images.isNotEmpty?SizedBox(
                height: 300,
                width: 800,
                child: GridView.builder(
                  primary: false,
                  itemCount: images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 3,crossAxisSpacing: 3),
                  itemBuilder: (context, index) {
                  return Image.file(File(images[index].path),fit: BoxFit.fill,);
                },),
              ):Container(),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: const ButtonStyle(shape: MaterialStatePropertyAll(StadiumBorder(side: BorderSide()))),
                    onPressed: (){
                  pickImages();
                }, child: const Text("Pic Images")),
              ),
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
                          hintText: "Enter sale price",
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
                  child: Center(child: Text("Add Product",style: TextStyle(fontSize: Get.width*0.06),)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  pickImages() async{
    final List<XFile> pick = await imagePicker.pickMultiImage(imageQuality: 500);
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
    EasyLoading.show(status: "Adding...");
    await uploadImages();
    await FirebaseFirestore.instance.collection("products").add({
      //'categoryId' : widget.id,
      'isCart' : false,
      'productName': nameController.text.trim(),
      'categoryName': widget.data["categoryName"],
      'salePrice': priceController.text,
      'fullPrice': discountController.text,
      'productImages': imagesUrls,
      'deliveryTime': "",
      'isSale': popular,
      'productDescription': desController.text,
      'createdAt': DateTime.now(),
      'updatedAt': "",
      'quantity': quantityController.text,
      'pId' : widget.id,
      'userUid' : FirebaseAuth.instance.currentUser!.uid
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
      Get.to(()=>const Home());
    });
  }

}
