// ignore_for_file: file_names, unused_local_variable, unused_field, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/widget/bottom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

class GoogleSignInController with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.show(status: "Please wait..");
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        final User? user = userCredential.user;

        if (user != null) {
          UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName ?? "No name",
              email: user.email ?? "No email",
              userImg: user.photoURL ?? "No image",
              userDeviceToken: " ",
              country: " ",
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now().toIso8601String());

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set(userModel.toMap());
          EasyLoading.dismiss();

          Get.snackbar("Success", "Successfully logged in as ${user.email}");

          Get.offAll(() => const MyBottomBar());
        }
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("error $e");
    }
  }
}




// // ignore_for_file: file_names, unused_local_variable, unused_field, avoid_print
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:e_language/widget/bottom_widget.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// import '../models/user_model.dart';

// class GoogleSignInController with ChangeNotifier {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> signInWithGoogle(BuildContext context) async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();

//       if (googleSignInAccount != null) {
//         EasyLoading.show(status: "Please wait..");
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;

//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );

//         final UserCredential userCredential =
//             await _auth.signInWithCredential(credential);

//         final User? user = userCredential.user;

//         if (user != null) {
//           UserModel userModel = UserModel(
//               uId: user.uid,
//               username: user.displayName.toString(),
//               email: user.email.toString(),
//               userImg: user.photoURL.toString(),
//               userDeviceToken: " ",
//               country: " ",
//               isAdmin: false,
//               isActive: true,
//               createdOn: DateTime.now().toIso8601String());

//           await FirebaseFirestore.instance
//               .collection('users')
//               .doc(user.uid)
//               .set(userModel.toMap());
//           EasyLoading.dismiss();

//           Get.snackbar("Sucess", "successfully login by ${user.email}");

//           // ignore: use_build_context_synchronously
//           Get.offAll(() => const MyBottomBar());
//         }
//       }
//     } catch (e) {
//       EasyLoading.dismiss();
//       print("error $e");
//     }
//   }
// }