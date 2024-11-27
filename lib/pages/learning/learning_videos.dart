import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideosLearningScreen extends StatefulWidget {
  final String initialVideoId;
  final String lessonName;
  final String categoryId;
  final String levelId;
  final String lessonId;
  final int lessonIndex;

  const VideosLearningScreen({
    Key? key,
    required this.initialVideoId,
    required this.lessonName,
    required this.categoryId,
    required this.lessonId,
    required this.lessonIndex,
    required this.levelId,
  }) : super(key: key);

  @override
  State<VideosLearningScreen> createState() => _VideosLearningScreenState();
}

class _VideosLearningScreenState extends State<VideosLearningScreen> {
  late YoutubePlayerController playerController;
  final FlutterTts flutterTts = FlutterTts();
  double videoProgress = 0.0;
  Duration videoDuration = Duration.zero;
  Duration videoPosition = Duration.zero;
  bool isClicked = true;
  String lessonText = "Loading...";

  Future<void> fetchLessonText() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot lessonSnapshot = await firestore
          .collection('category')
          .doc(widget.categoryId)
          .collection("levels")
          .doc(widget.levelId)
          .collection("lessons")
          .orderBy("createdAt")
          .get();

      setState(() {
        lessonText = lessonSnapshot.docs[widget.lessonIndex]["text"] ??
            "No text is defined";
      });
    } catch (e) {
      setState(() {
        lessonText = "Error loading lesson";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    playerController = YoutubePlayerController(
      initialVideoId: widget.initialVideoId,
      flags: YoutubePlayerFlags(
        hideControls: !isClicked,
        loop: false,
        autoPlay: true,
        forceHD: true,
        mute: false,
      ),
    )..addListener(_onPlayerStateChange);

    fetchLessonText();
  }

  Future<void> updateLessonScore({
    required String categoryid,
    required String levelid,
    required String lessonid,
    required double newScore,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot lessonSnapshot = await firestore
          .collection('category')
          .doc(categoryid)
          .collection("levels")
          .doc(levelid)
          .collection("lessons")
          .doc(lessonid)
          .get();

      if (lessonSnapshot.exists) {
        Map<String, dynamic> lessonsData =
            lessonSnapshot.data() as Map<String, dynamic>;

        lessonsData['lessonscore'] = newScore.toString();
        lessonsData['isLessonComplete'] = newScore > 0.9;

        await firestore
            .collection('category')
            .doc(categoryid)
            .collection("levels")
            .doc(levelid)
            .collection("lessons")
            .doc(lessonid)
            .update(lessonsData);

        print("Lesson score updated successfully");
      } else {
        Get.snackbar("Message", "Lesson not found");
      }
    } catch (e) {
      Get.snackbar("Message", "Error updating lesson score: $e");
      print("Error updating lesson score: $e");
    }
  }

  void _onPlayerStateChange() {
    setState(() {
      videoPosition = playerController.value.position;
      videoDuration = playerController.value.metaData.duration;

      if (videoDuration.inSeconds > 0) {
        videoProgress = videoPosition.inSeconds / videoDuration.inSeconds;

        updateLessonScore(
          categoryid: widget.categoryId,
          levelid: widget.levelId,
          lessonid: widget.lessonId,
          newScore: videoProgress,
        );
      }
    });
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    playerController.dispose();
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.green),
        ),
        elevation: 1.0,
        title: Text(
          widget.lessonName,
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Video Player Section
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: YoutubePlayer(controller: playerController),
              ),
              const SizedBox(height: 20),

              // Progress Indicator
              LinearPercentIndicator(
                percent: videoProgress,
                lineHeight: 10.0,
                progressColor: Colors.green,
                backgroundColor: Colors.grey.shade300,
                barRadius: const Radius.circular(10),
                trailing: Text(
                  "${(videoProgress * 100).toStringAsFixed(1)}%",
                  style: TextStyle(color: Colors.grey.shade700),
                ),
              ),
              const SizedBox(height: 20),

              // Lesson Text Section with Card Design
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        ("Introduction").toUpperCase(),
                        //textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              lessonText,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              _speak(lessonText); // Speak the lesson text
                              setState(() {
                                isClicked = !isClicked;
                              });
                            },
                            child: isClicked
                                ? Lottie.asset("assets/speaker.json", width: 50)
                                : IconButton(
                                    icon: const Icon(Icons.stop,
                                        color: Colors.red),
                                    onPressed: () {
                                      flutterTts.stop();
                                      setState(() {
                                        isClicked = !isClicked;
                                      });
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 3D Model Section
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade200.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3D Learning Section",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Here will be 3D models to help you understand the topic more deeply.",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 10),
                    Placeholder(
                      fallbackHeight: 150,
                      color: Colors.grey,
                      strokeWidth: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
