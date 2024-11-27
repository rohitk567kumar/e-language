// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInMethod(
      String userEmail, String userPassword) async {
    try {
      EasyLoading.show(status: "Please wait");
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        e.message ?? "An unexpected error occurred.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      EasyLoading.dismiss();
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
}





// // ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';

// class SignInController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 
//   Future<UserCredential?> signInMethod(
//       String userEmail, String userPassword) async {
//     try {
//       EasyLoading.show(status: "Please wait");
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: userEmail,
//         password: userPassword,
//       );

//       EasyLoading.dismiss();
//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       EasyLoading.dismiss();
//       Get.snackbar(
//         "Error",
//         "$e",
//         snackPosition: SnackPosition.BOTTOM,
//         // backgroundColor: AppConstant.appScendoryColor,
//         // colorText: AppConstant.appTextColor,
//       );
//     }
//   }
// }