// ignore_for_file: must_be_immutable
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/pages/Learning&Test_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LevelsScreen extends StatelessWidget {
  String categoryName;
  int categoryIndex;
  String categoryId;
  LevelsScreen(
      {super.key,
      required this.categoryName,
      required this.categoryIndex,
      required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          ("$categoryName - Level").toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // here the data list of levels will bee show
            LevelsFetchingDataFireBase(
                categoryId: categoryId,
                categoryIndex: categoryIndex,
                categoryName: categoryName)
          ],
        ),
      ),
    );
  }
}

// Card for level
class LevelCard extends StatelessWidget {
  final String levelName;
  final String icon;
  final double progress;

  const LevelCard({
    super.key,
    required this.levelName,
    required this.icon,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          EdgeInsets.symmetric(vertical: getResponsiveFontSize(context, 0.03)),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(getResponsiveFontSize(context, 0.04)),
        child: Row(
          children: [
            Icon(getIconForCategory(icon),
                size: getResponsiveSizeHieght(context, 0.056),
                color: Theme.of(context).primaryColor),
            SizedBox(width: getResponsiveSizeWidh(context, 0.05)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    levelName,
                    style: TextStyle(
                      fontSize: getResponsiveFontSize(context, 0.055),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: getResponsiveFontSize(context, 0.03)),
                  LinearProgressIndicator(
                    value: progress,
                    color: AppColors.secondaryColor,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  SizedBox(height: getResponsiveFontSize(context, 0.03)),
                  Text("${(progress * 100).toStringAsFixed(0)}% Completed"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData getIconForCategory(String iconName) {
  switch (iconName) {
    case 'school':
      return Icons.school;
    case 'book':
      return Icons.book;
    case 'star':
      return Icons.star;
    default:
      return Icons.help_outline; // Default icon if the name doesn't match
  }
}

class LevelsFetchingDataFireBase extends StatefulWidget {
  final int categoryIndex;
  final String categoryName;
  final String categoryId;

  const LevelsFetchingDataFireBase({
    super.key,
    required this.categoryIndex,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  State<LevelsFetchingDataFireBase> createState() =>
      _LevelsFetchingDataFireBaseState();
}

class _LevelsFetchingDataFireBaseState
    extends State<LevelsFetchingDataFireBase> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('category') 
          .doc(widget.categoryId) 
          .collection("levels")
          .orderBy("createdAt") 
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No levels available."));
        }

        return Expanded(
          child: ListView.builder(
            itemCount:
                snapshot.data!.docs.length, // Count the documents in 'levels'
            itemBuilder: (context, levelIndex) {
              var levelDoc = snapshot.data!.docs[levelIndex];
              var levelData = levelDoc.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => Get.to(
                  () => MyLearningScreen(
                    levelId: levelData["levelId"],
                    categoryId: widget.categoryId,
                    categoryIndex: widget.categoryIndex,
                    levelIndex: levelIndex,
                    categoryName: widget.categoryName,
                    levelName:
                        levelData["level"], 
                  ),
                ),
                child: LevelCard(
                  levelName:
                      levelData["level"], 
                  icon: levelData["icon"],
                  progress: double.tryParse(levelData["levelscore"]) ??
                      0.0,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
