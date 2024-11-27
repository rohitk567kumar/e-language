import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_language/pages/exersice/mcqs_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ExerciseLessons extends StatefulWidget {
  String categoryId;
  String levelName;
  String categoryName;

  String levelId;

  ExerciseLessons(
      {super.key,
      required this.categoryId,
      required this.levelName,
      required this.levelId,
      required this.categoryName});

  @override
  State<ExerciseLessons> createState() => _ExerciseLessonsState();
}

class _ExerciseLessonsState extends State<ExerciseLessons> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.green),
          title: Text(
            "${widget.categoryName} - ${widget.levelName}",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection("category")
              .doc(widget.categoryId)
              .collection("levels")
              .doc(widget.levelId)
              .collection("lessons")
              .get(),
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
                            colors: [
                              Colors.green.shade800,
                              Colors.green.shade400
                            ],
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
        ));
  }
}
