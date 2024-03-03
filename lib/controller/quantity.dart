import 'package:get/get.dart';

class Quantity extends GetxController{
  var quantity = 1.obs;
  void increment(){
    quantity.value++;
  }
  void decrement(){
    if(quantity>1) {
      quantity.value -= 1;
    }
  }
}