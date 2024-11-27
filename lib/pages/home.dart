import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/models/category-models.dart';
import 'package:e_language/pages/all_categories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'levels_screen.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        title: Text(
          ("E Language").toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .displayLarge
              ?.copyWith(color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.notifications,
              //color: AppColors.primaryColor,
            ),
          )
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(getResponsiveSizeHieght(context, 0.02)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            SizedBox(height: getResponsiveSizeHieght(context, 0.023)),
            _buildSearchBar(context),
            SizedBox(height: getResponsiveSizeHieght(context, 0.013)),
            _buildCategoryTitle(context),
            SizedBox(height: getResponsiveSizeHieght(context, 0.010)),
            ListOfCategory(
                minusVariable: 1), // List of categories from Firestore
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getResponsiveSizeHieght(context, 0.23),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.green.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.green)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: getResponsiveSizeHieght(context, 0.08),
            child: Icon(
              Icons.person,
              size: getResponsiveSizeHieght(context, 0.07),
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(width: getResponsiveSizeHieght(context, 0.02)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome Back!", // Placeholder for user name
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: getResponsiveFontSize(context, 0.062),
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(height: getResponsiveSizeHieght(context, 0.01)),
              Text(
                "Total Points\n1200", // Placeholder for total points
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textColor,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: getResponsiveSizeHieght(context, 0.07),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: "Search the category here",
        ),
      ),
    );
  }

  Widget _buildCategoryTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Category",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        GestureDetector(
          onTap: () => Get.to(() => const AllCotegories()),
          child: Text(
            "See all",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ListOfCategory extends StatefulWidget {
  int minusVariable;
  ListOfCategory({super.key, required this.minusVariable});

  @override
  State<ListOfCategory> createState() => _ListOfCategoryState();
}

class _ListOfCategoryState extends State<ListOfCategory> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('category').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No categories available."));
        }

        return Expanded(
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: snapshot.data!.docs.length - widget.minusVariable,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, categoryIndex) {
              var docData = snapshot.data!.docs[categoryIndex].data()
                  as Map<String, dynamic>;

              LearningCategory learningCategory = LearningCategory(
                categoryId: docData['categoryId'] ??
                    "Unknown ID", 
                name: docData['name'] ?? "Unknown Name", 
                icon: docData['icon'] ??
                    "default_icon.png",
                     // Handle missing icon
                score:   double.tryParse(docData['score']) ?? 0.0, 
                levels: docData['levels'] ??
                    [], 
              );
              // print("Hye it is url of image ${learningCategory.icon}");
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => LevelsScreen(
                      categoryId: learningCategory.categoryId,
                      categoryIndex: categoryIndex,
                      categoryName: learningCategory.name,
                    ),
                  );
                },
                child: Container(
                  margin:
                      EdgeInsets.all(getResponsiveSizeHieght(context, 0.01)),
                  padding:
                      EdgeInsets.all(getResponsiveSizeHieght(context, 0.01)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade500,
                        Colors.lightGreen.shade300
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.green)
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: getResponsiveSizeHieght(context, 0.23),
                        height: getResponsiveSizeWidh(context, 0.23),
                        child: CachedNetworkImage(
                          imageUrl: learningCategory.icon,
                          fit: BoxFit.contain,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      SizedBox(height: getResponsiveSizeHieght(context, 0.023)),
                      Text(
                        learningCategory.name,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
