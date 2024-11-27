import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/user_auth/sign-in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/sign_up_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userFname = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userConfrimPassword = TextEditingController();
  final SignUpController signUpController = SignUpController();

  void _conditionsOnText() async {
    String userfullname = userFname.text.trim();
    String useremail = userEmail.text.trim();
    String usercity = userCity.text.trim();
    String userpassword = userPassword.text.trim();
    String userconfrimpass = userConfrimPassword.text.trim();
    String userDeviceToken = " ";

    if (_formKey.currentState!.validate()) {
      if (userfullname.isEmpty ||
          useremail.isEmpty ||
          usercity.isEmpty ||
          userpassword.isEmpty ||
          userconfrimpass.isEmpty) {
        _showDailogueMsg("please fill the fields");
      } else {
        if (userpassword != userconfrimpass) {
          _showDailogueMsg("please right the same password");

          userConfrimPassword.clear();
        } else {
          UserCredential? userCredential = await signUpController.signUpMethod(
              userfullname,
              useremail,
              usercity,
              userpassword,
              userconfrimpass,
              userDeviceToken);

          if (userCredential != null) {
            Get.snackbar(
              "Verification email sent",
              "Please check your email",
            );
            userFname.clear();
            userEmail.clear();
            userCity.clear();
            userPassword.clear();
            userConfrimPassword.clear();

            FirebaseAuth.instance.signOut();
            Get.offAll(() => const SignInScreen());
          }
        }
      }
    }
  }

  void _showDailogueMsg(String msg) {
    Get.snackbar("Message", msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: Text(
          ('Sign Up').toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.025)),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a new account',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.045)),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextField(
                          controller: userFname,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: const Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: getResponsiveSizeHieght(context, 0.025)),
                        TextField(
                          controller: userEmail,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: getResponsiveSizeHieght(context, 0.025)),
                        TextField(
                          controller: userCity,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: 'City',
                            prefixIcon: const Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: getResponsiveSizeHieght(context, 0.025)),
                        TextField(
                          keyboardType: TextInputType.visiblePassword,
                          controller: userPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: getResponsiveSizeHieght(context, 0.025)),
                        TextField(
                          controller: userConfrimPassword,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confrim passsword',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: getResponsiveSizeHieght(context, 0.025)),
                SizedBox(
                  width: double.infinity,
                  height: getResponsiveSizeHieght(context, 0.07),
                  child: ElevatedButton(
                    onPressed: () {
                      _conditionsOnText();
                    },
                    child: const Text('Sign Up'),
                  ),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.035)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
