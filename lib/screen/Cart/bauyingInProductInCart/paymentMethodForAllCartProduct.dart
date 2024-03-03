//paymentMethodForAllCartProduct

import 'package:admineccomerce/models/cart-model.dart';
import 'package:admineccomerce/models/product-model.dart';
import 'package:admineccomerce/models/userAddressModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../controller/cartTotalPrice.dart';
import '../../../services/genrate-order-id-service.dart';
import '../../../services/place-order-service.dart';
import '../../home.dart';


class PaymentMethodForAllCartProduct extends StatefulWidget {
  final double totalQuantity;
  final double totalValue;
  final TotalPriceCart totalPriceCart;
  final UserAddressModel userAddressModel;
  const PaymentMethodForAllCartProduct({Key? key,required this.totalQuantity,required this.totalValue,required this.totalPriceCart,required this.userAddressModel}) : super(key: key);

  @override
  State<PaymentMethodForAllCartProduct> createState() => _PaymentMethodForAllCartProductState();
}

class _PaymentMethodForAllCartProductState extends State<PaymentMethodForAllCartProduct> {

  TotalPriceCart totalPriceCart = Get.put(TotalPriceCart());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalPriceCart.factProductPrice();
    print(totalPriceCart.totalP.value);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: ListTile(
                   title: const Text("Total Price is:"),
                  subtitle: Text(widget.totalValue.toString()),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text("Total Product is:"),
                  subtitle: Text(widget.totalQuantity.toString()),
                ),
              ),
              Card(
                child: ListTile(
                  onTap: (){
                    placeOrder(context: context,customerPhone: widget.userAddressModel.phoneNumber,customerName: widget.userAddressModel.name,customerDeviceToken: "",customerAddress: widget.userAddressModel.address);
                  },
                  title: const Text("Cash On Delivery"),
                  trailing: const Icon(Icons.payment),
                ),
              ),
               Card(
                child: ListTile(
                  onTap: (){},
                  title: const Text("Online Payment"),
                  trailing: const Icon(Icons.payments_sharp),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

