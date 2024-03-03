import 'package:admineccomerce/models/user-model.dart';
import 'package:flutter/material.dart';


class UserProduct extends StatefulWidget {
  final UserModel userModel;
  const UserProduct({Key? key,required this.userModel}) : super(key: key);

  @override
  State<UserProduct> createState() => _UserProductState();
}

class _UserProductState extends State<UserProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Product")),
    );
  }
}
