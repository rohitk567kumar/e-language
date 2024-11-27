import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/user_auth/sign-in_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        title: Text(
          ("Profile").toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: getResponsiveSizeHieght(context, 0.025)),
            // Profile Image and Name Section
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: getResponsiveSizeHieght(context, 0.08),
                  backgroundColor: Colors.blue.shade200,
                  child: CircleAvatar(
                    radius: getResponsiveSizeHieght(context, 0.07),
                    backgroundImage: const AssetImage(
                        "assets/1.jpg"), // Add a default image or user's profile pic
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: getResponsiveSizeHieght(context, 0.01),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.blue),
                      onPressed: () {
                        // Action to edit the profile picture
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.015)),
            Text(
              "ROHAIT KUMAR", // Username
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 0.065),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.01)),
            Text(
              "techsolutionsintitute@gmail.com", // Email
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, 0.045),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.025)),
            // Edit Profile Button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSizeHieght(context, 0.015)),
              child: ElevatedButton(
                onPressed: () {
                  // Action to edit profile
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(getResponsiveSizeHieght(context, 0.25),
                      getResponsiveSizeWidh(context, 0.13)),
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: getResponsiveSizeHieght(context, 0.015)),
                ),

                //icon: const Icon(Icons.edit),
                child: Text(
                  ("Edit Profile").toUpperCase(),
                  style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 0.045),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.035)),
            // Profile Settings List
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSizeHieght(context, 0.025)),
              child: Column(
                children: [
                  ProfileOption(
                    icon: Icons.account_circle_outlined,
                    title: "Account",
                    onTap: () {
                      // Action for Account settings
                    },
                  ),
                  ProfileOption(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () {
                      // Action for Notification settings
                    },
                  ),
                  ProfileOption(
                    icon: Icons.leaderboard_outlined,
                    title: "Leaderboard",
                    onTap: () {
                      // Action to view Leaderboard
                    },
                  ),
                  ProfileOption(
                    icon: Icons.lock_outline,
                    title: "Privacy",
                    onTap: () {
                      // Action for Privacy settings
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.035)),
            // Logout Button
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getResponsiveSizeHieght(context, 0.035)),
              child: ElevatedButton(
                onPressed: () async {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  await googleSignIn.signOut();
                  Get.offAll(() => const SignInScreen());
                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(getResponsiveSizeHieght(context, 0.25),
                      getResponsiveSizeWidh(context, 0.13)),
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: getResponsiveSizeHieght(context, 0.012)),
                ),
                child: Text(
                  "LOGOUT",
                  style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 0.045),
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: getResponsiveSizeHieght(context, 0.035)),
          ],
        ),
      ),
    );
  }
}

// Reusable Widget for Profile Options
class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon,
              size: getResponsiveSizeHieght(context, 0.04),
              color: AppColors.primaryColor),
          title: Text(
            title,
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, 0.045),
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              size: getResponsiveSizeHieght(context, 0.03), color: Colors.grey),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
