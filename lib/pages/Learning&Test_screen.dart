// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/constant/app-constant.dart';
import 'package:e_language/pages/exersice/mcqs_screen.dart';
import 'package:e_language/pages/learning/learning_videos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MyLearningScreen extends StatefulWidget {
  String levelName;
  int categoryIndex;
  int levelIndex;
  String levelId;
  String categoryId;
  String categoryName;
  MyLearningScreen(
      {Key? key,
      required this.categoryIndex,
      required this.levelId,
      required this.levelName,
      required this.categoryName,
      required this.levelIndex,
      required this.categoryId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyLearningScreenState createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.primaryColor),
        title: Text(
          ("${widget.categoryName} - ${widget.levelName}").toUpperCase(),
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Column(
        children: [
          _buildTabs(),
          Expanded(
              child: _buildTabContent(
            categoryId: widget.categoryId,
            levelId: widget.levelId,
            categoryIndex: widget.categoryIndex,
            levelIndex: widget.levelIndex,
          )),
        ],
      ),
    );
  }

// this is the widget of two tabs
  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      indicatorColor: Theme.of(context).primaryColor,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey,
      tabs: const [
        Tab(icon: Icon(Icons.menu_book), text: 'Learning Materials'),
        Tab(icon: Icon(Icons.quiz), text: 'Mock Tests'),
      ],
    );
  }

  Widget _buildTabContent(
      {required int categoryIndex,
      required levelIndex,
      required categoryId,
      required levelId}) {
    return TabBarView(
      controller: _tabController,
      children: [
        ListofLessons(
            categoryId: categoryId,
            categoryIndex: widget.categoryIndex,
            levelId: levelId,
            levelIndex: widget.levelIndex),
        _buildMockTests(),
      ],
    );
  }

  // THIS IS LIST OF LESSON FOR EXERCISE

  Widget _buildMockTests() {
    return FutureBuilder(
      future: fetchLessons(widget.categoryId, widget.levelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("no lessons list are"),
          );
        }

        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, lessonIndex) {
            return GestureDetector(
              onTap: () => Get.to(() => const MultipleChoiceExerciseScreen()),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                        colors: [Colors.green.shade800, Colors.green.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Exercise No ${lessonIndex + 1}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// LIST OF LESSON IS BEING DISPLAYED AT LEARNING SCREEN AFTER CLICK ON ANY LEVEL
class ListofLessons extends StatefulWidget {
  final String categoryId;
  final int categoryIndex;
  final String levelId;
  final int levelIndex;

  const ListofLessons(
      {Key? key,
      required this.categoryId,
      required this.categoryIndex,
      required this.levelId,
      required this.levelIndex})
      : super(key: key);

  @override
  State<ListofLessons> createState() => _ListofLessonsState();
}

class _ListofLessonsState extends State<ListofLessons> {
  bool isCurrentLessonLocked = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: fetchLessons(widget.categoryId, widget.levelId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No lessons available."),
          );
        }

        // Fetching levels data and storing in List of Maps
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: fetchLevels(widget.categoryId),
          builder: (context, levelSnapshot) {
            if (levelSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!levelSnapshot.hasData || levelSnapshot.data!.isEmpty) {
              return const Center(child: Text("No levels found."));
            }

            var levels = levelSnapshot.data!; // List of levels

            // Building lessons list
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, lessonIndex) {
                var lessonDoc = snapshot.data!.docs[lessonIndex];

                var lessonData = lessonDoc.data() as Map<String, dynamic>;

                // Logic for locking/unlocking lessons based on level and lesson score
                if (widget.levelIndex == 0) {
                  if (lessonIndex == 0) {
                    isCurrentLessonLocked = true;
                  } else {
                    isCurrentLessonLocked = double.tryParse(snapshot
                            .data!.docs[lessonIndex - 1]["lessonscore"])! >
                        0.9;
                  }
                } else //if (widget.levelIndex > 0)
                {
                  if (double.tryParse(
                          levels[widget.levelIndex - 1]["levelscore"] ?? '0')! >
                      0.9) {
                    if (lessonIndex == 0) {
                      isCurrentLessonLocked = true;
                    } else {
                      isCurrentLessonLocked = double.tryParse(snapshot
                              .data!.docs[lessonIndex - 1]["lessonscore"])! >
                          0.9;
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: isCurrentLessonLocked
                        ? Colors.green.shade800
                        : Colors.grey,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.play_arrow,
                            color: isCurrentLessonLocked
                                ? Colors.green.shade800
                                : Colors.grey),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Lesson No ${lessonIndex + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        lessonData["lesson"] ?? "Unnamed Lesson",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      onTap: isCurrentLessonLocked
                          ? () => Get.to(() => VideosLearningScreen(
                              lessonId: lessonData["lessonId"],
                              categoryId: widget.categoryId,
                              levelId: widget.levelId,
                              lessonIndex: lessonIndex,
                              initialVideoId: lessonData["video"],
                              lessonName: lessonData["lesson"]))
                          : null,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

Future<List<Map<String, dynamic>>> fetchLevels(String categoryId) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("category")
      .doc(categoryId)
      .collection("levels")
      .orderBy("createdAt")
      .get();

  // Returning the levels data as a List of Maps
  return snapshot.docs
      .map((doc) => doc.data() as Map<String, dynamic>)
      .toList();
}

Future<QuerySnapshot> fetchLessons(String categoryid, String levelid) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection("category")
      .doc(categoryid)
      .collection("levels")
      .doc(levelid)
      .collection("lessons")
      .orderBy("createdAt")
      .get();

  // Returning the collections of lessons in the QuerySnapshot form
  return snapshot;
}
