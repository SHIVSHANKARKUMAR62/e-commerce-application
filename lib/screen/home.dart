import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../homecontroller/homecontroller.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          elevation: 10,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.black.withOpacity(.60),
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: (value) {
            // Respond to item press.
            controller.changeMethod(value);
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: "Cart"
            ),

            BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: "Categories"
            ),
          ],
        );
      }),
      body: Scaffold(
        body: Obx(() {
          return HomeController.pages[controller.selectedIndex.value];
        }),
      ),
    );
  }
}
