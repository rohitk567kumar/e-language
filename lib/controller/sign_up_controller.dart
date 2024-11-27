// ignore_for_file: file_names, unused_field, body_might_complete_normally_nullable, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userCity,
    String userPassword,
    String userConfrimPassword,
    String userDeviceToken,
  ) async {
    if (userPassword != userConfrimPassword) {
      Get.snackbar(
        "Password Mismatch",
        "Password and confirm password do not match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    try {
      EasyLoading.show(
        status: "Please wait...",
        maskType: EasyLoadingMaskType.clear,
      );

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      final User? user = userCredential.user;

      if (user == null) {
        EasyLoading.dismiss();
        Get.snackbar(
          "Error",
          "User creation failed. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }

      await user.sendEmailVerification();

      final UserModel userModel = UserModel(
        uId: user.uid,
        username: userName,
        email: userEmail,
        userImg: " ",
        userDeviceToken: userDeviceToken,
        country: userCity,
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

      EasyLoading.dismiss();
      Get.snackbar(
        "Success",
        "Account created successfully! Please verify your email.",
        snackPosition: SnackPosition.BOTTOM,
      );

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
// import 'package:e_language/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';

// class SignUpController extends GetxController {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<UserCredential?> signUpMethod(
//     String userName,
//     String userEmail,
//     String userCity,
//     String userPassword,
//     String userConfrimPassword,
//     String userDeviceToken,
//   ) async {
//     if (userPassword != userConfrimPassword) {
//       // Validate confirm password
//       Get.snackbar(
//         "Password Mismatch",
//         "Password and confirm password do not match",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return null;
//     }

//     try {
//       EasyLoading.show(
//         status: "Please wait...",
//         maskType: EasyLoadingMaskType.clear,
//       );

//       // Create user with email and password
//       final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
//         email: userEmail,
//         password: userPassword,
//       );

//       final User? user = userCredential.user;

//       // Ensure the user object is not null
//       if (user == null) {
//         EasyLoading.dismiss();
//         Get.snackbar(
//           "Error",
//           "User creation failed. Please try again.",
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return null;
//       }

//       // Send email verification
//       await user.sendEmailVerification();

//       // Create UserModel instance
//       final UserModel userModel = UserModel(
//         uId: user.uid,
//         username: userName,
//         email: userEmail,
//         userImg: " ",
//         userDeviceToken: userDeviceToken,
//         country: userCity,
//         isAdmin: false,
//         isActive: true,
//         createdOn: DateTime.now(),
//       );

//       // Save user data in Firestore
//       await _firestore.collection('users').doc(user.uid).set(userModel.toMap());

//       EasyLoading.dismiss();
//       Get.snackbar(
//         "Success",
//         "Account created successfully! Please verify your email.",
//         snackPosition: SnackPosition.BOTTOM,
//       );

//       return userCredential;
//     } on FirebaseAuthException catch (e) {
//       EasyLoading.dismiss();
//       Get.snackbar(
//         "Error",
//         e.message ?? "An unexpected error occurred.",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return null;
//     } catch (e) {
//       EasyLoading.dismiss();
//       Get.snackbar(
//         "Error",
//         "Something went wrong: $e",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return null;
//     }
//   }
// }
