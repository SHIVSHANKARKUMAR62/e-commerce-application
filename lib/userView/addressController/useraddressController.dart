
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class UserAddressController extends GetxController{


  var controller = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var latitude = "".obs;
  var longitude = "".obs;

  void getLongLang() async {
    try {
      EasyLoading.show(status: "Adding...");
      List<Location> locations = await locationFromAddress(controller.text);
      latitude.value = locations.last.latitude.toString();
      longitude.value = locations.last.longitude.toString();
      await FirebaseFirestore.instance.collection("users").doc(
          FirebaseAuth.instance.currentUser!.uid).collection("address").add({
        'name' : nameController.value.text.toString(),
        'phoneNumber' : phoneController.value.text.toString(),
        'address': controller.value.text.toString(),
        'longitude': longitude.value.toString(),
        'latitude': latitude.value.toString(),
        'uid' : FirebaseAuth.instance.currentUser!.uid
      }).whenComplete(() async {
        await FirebaseFirestore.instance.collection("deliverAddress").doc(
            FirebaseAuth.instance.currentUser!.uid).set({
          'name' : nameController.value.text.toString(),
          'phoneNumber' : phoneController.value.text.toString(),
          'address': controller.value.text.toString(),
          'longitude': longitude.value.toString(),
          'latitude': latitude.value.toString(),
          'uid' : FirebaseAuth.instance.currentUser!.uid
        }).whenComplete(() {
          controller.clear();
          Get.back();
          EasyLoading.dismiss();
        });
      });
    } on FirebaseAuthException catch (e) {
      log(e.code);
    }
  }}