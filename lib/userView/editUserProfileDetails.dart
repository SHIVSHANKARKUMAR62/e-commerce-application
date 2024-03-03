import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

import '../models/userData.dart';

class EditUserProfileDetails extends StatefulWidget {
  
  final UserData userModel;
  
  const EditUserProfileDetails({Key? key,required this.userModel}) : super(key: key);

  @override
  State<EditUserProfileDetails> createState() => _EditUserProfileDetailsState();
}

class _EditUserProfileDetailsState extends State<EditUserProfileDetails> {

  dynamic image;
  String? fileName;
  dynamic post;
  File? userProfile;
  String? name;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  var nameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.userModel.username.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () async{
                    XFile? selectedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(selectedImage != null){
                      File convertedFile = File(selectedImage.path);
                      setState(() {
                        userProfile = convertedFile;
                        name = selectedImage.name;
                      });
                    }
                  },
                  child: SizedBox(
                      height: Get.height*0.15,
                      width: Get.width*0.5,
                      child: userProfile!=null?Image.file(userProfile!,fit: BoxFit.fill,):widget.userModel.img.isNotEmpty?Image.network(widget.userModel.img,fit: BoxFit.fill,):const Center(child: Icon(Icons.add,color: Colors.white))),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Form(child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    label: Text("Enter Your Name"),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20)))
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Please Enter Name";
                    }else{
                      return null;
                    }
                  },
                )),
              ),

              MaterialButton(
                color: Colors.blue,
                  onPressed: ()async{
                  try{
                    EasyLoading.show(status: "Updating...");
                    if(userProfile != null){
                      Reference ref = FirebaseStorage.instance.ref().child(
                          "shopPicture").child(name!);
                      UploadTask uploadTask = ref.putFile(File(userProfile!
                          .path));
                      TaskSnapshot snapshot = await uploadTask;
                      String downloadUrl = await snapshot.ref
                          .getDownloadURL();
                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                        'img' : downloadUrl,
                        'username' : nameController.text.trim().toString()
                      }).whenComplete(() {
                        EasyLoading.dismiss();
                        Get.back();
                      });
                    }else{
                      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                        'img' : widget.userModel.img,
                        'username' : nameController.text.trim().toString()
                      }).whenComplete(() {
                        Get.back();
                        EasyLoading.dismiss();
                      });
                    }
                  }on FirebaseAuthException catch(e){
                    EasyLoading.dismiss();
                    log(e.code);
                  }
                  },
                child: const Text("Update")
              )
              
            ],
          ),
        ),
      ),
    );
  }
}
