import 'package:admineccomerce/screen/Cart/cartScreen.dart';
import 'package:admineccomerce/screen/categories.dart';
import 'package:admineccomerce/screen/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screen/Cart/CategoriesAll.dart';

class HomeController extends GetxController{
  var selectedIndex = 0.obs;
  static const List<Widget> pages = <Widget>[
    HomePage(),
    CartScreen(),
    CategroiesAll()
  ];


  changeMethod(value){
    selectedIndex.value = value;
  }

}