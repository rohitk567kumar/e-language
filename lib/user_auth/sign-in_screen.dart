import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/user_auth/sign-up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/get_user_data_controller.dart';
import '../controller/google_sign_in_controller.dart';
import '../controller/sign_in_controller.dart';
import '../widget/bottom_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleSignInController googleSignInController =
      GoogleSignInController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  final SignInController signInController = SignInController();
  final GetUserDataController getUserDataController = GetUserDataController();

  void _conditionsOnText() async {
    if (_formKey.currentState!.validate()) {
      String useremail = userEmail.text.trim();
      String userpassword = userPassword.text.trim();

      if (useremail.isEmpty || userpassword.isEmpty) {
        _showDailogueMsg("please give the following credentials");
      } else {
        UserCredential? userCredential =
            await signInController.signInMethod(useremail, userpassword);
        // var userData =
        //     await getUserDataController.getUserData(userCredential!.user!.uid);

        if (userCredential != null) {
          if (userCredential.user!.emailVerified) {
            Get.snackbar(
              "Success",
              "Login successfully!",
            );
            Get.offAll(() => const MyBottomBar());
          } else {
            _showDailogueMsg("Please verify your email before login");
          }
        } else {
          _showDailogueMsg("Please try again");
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
      appBar: AppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.02)),
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
                Text(
                  'Sign in to continue',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.045)),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: userEmail,
                          // validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "please enter data";
                          //   }
                          //   return null;
                          // },
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
                      ],
                    )),
                SizedBox(height: getResponsiveSizeHieght(context, 0.010)),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      //do here
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.026)),
                SizedBox(
                  width: double.infinity,
                  height: getResponsiveSizeHieght(context, 0.07),
                  child: ElevatedButton(
                    onPressed: () {
                      _conditionsOnText();
                    },
                    child: const Text('Sign In'),
                  ),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
                Center(
                  child: Text(
                    'OR',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
                SizedBox(
                  width: double.infinity,
                  height: getResponsiveSizeHieght(context, 0.07),
                  child: OutlinedButton.icon(
                    icon: Image.asset(
                      'assets/google.png',
                      height: getResponsiveSizeHieght(context, 0.03),
                    ),
                    label: const Text('Sign In with Google'),
                    onPressed: () =>
                        googleSignInController.signInWithGoogle(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(width: 1, color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: getResponsiveSizeHieght(context, 0.026)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'),
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
