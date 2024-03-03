import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class TotalPriceCart extends GetxController {
  RxDouble totalP = 0.0.obs;
  var totalProduct = 0.0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    factProductPrice();
  }

  void factProductPrice() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("cartOrders")
        .get();
    totalProduct.value = snapshot.docs.length.toDouble();
    double sum = 0.0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      if (data.isNotEmpty && data.containsKey("productTotalPrice")) {
        sum += double.parse((data["productTotalPrice"]));
      }
    }
    final QuerySnapshot<Map<String, dynamic>> snapshot2 = await FirebaseFirestore
        .instance
        .collection('products')
        .get();
    for(int i=0;i<snapshot2.docs.length;i++){
      if(int.parse(snapshot2.docs[i]['quantity'])==0){
        totalP.value = totalP.value - int.parse(snapshot2.docs[i]['salePrice']);
      }
    }
    totalP.value = sum;
    update();
    //print(totalP.value);
  }
}
