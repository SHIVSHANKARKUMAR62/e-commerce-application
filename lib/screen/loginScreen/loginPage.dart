import 'package:admineccomerce/screen/home.dart';
import 'package:admineccomerce/screen/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("Login")),
     body: Column(
       mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: [
         SizedBox(
           width: double.infinity,
          // height: Get.height*0.79,
           child: Image.asset('lottie/happy.png'),
         ),
         SizedBox(
           width: double.infinity,
           //height: Get.height*0.79,
           child: Lottie.asset('lottie/loginLottie.json'),
         ),
         GestureDetector(
           onTap: (){
             signInWithGoogle();
           },
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               width: double.infinity,
               height: Get.height*0.07,
               decoration: BoxDecoration(
                 color: Colors.yellow,
                 borderRadius: BorderRadius.circular(20)
               ),
               child: Center(child: Text("Sign with google",style: TextStyle(fontSize: Get.width*0.06),)),
             ),
           ),
         ),
       ],
     ),
    );
  }

  void signInWithGoogle() async {
    EasyLoading.show(status: "Please Wait...");
    // Trigger the authentication flow
   try{
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );



     // Once signed in, return the UserCredential
     await FirebaseAuth.instance.signInWithCredential(credential).whenComplete(() async {
       if(FirebaseAuth.instance.currentUser==null){
         await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
           'uId': FirebaseAuth.instance.currentUser!.uid,
           'username': FirebaseAuth.instance.currentUser!.displayName,
           'email': FirebaseAuth.instance.currentUser!.email,
           'img': FirebaseAuth.instance.currentUser!.photoURL
         }).whenComplete(() {
           EasyLoading.dismiss();
           Get.offAll(()=>const HomePage());
         });
       }else{
         EasyLoading.dismiss();
         Get.offAll(()=>const HomePage());
       }

     });
   }on FirebaseAuthException catch (e){
     Get.showSnackbar(
      GetSnackBar(title: "Error",message: "Something is wrong...",backgroundColor: Colors.blue.shade100,)
     );
   }
  }

}
