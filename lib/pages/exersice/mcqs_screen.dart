import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MultipleChoiceExerciseScreen extends StatefulWidget {
  const MultipleChoiceExerciseScreen({Key? key}) : super(key: key);

  @override
  State<MultipleChoiceExerciseScreen> createState() =>
      _MultipleChoiceExerciseScreenState();
}

class _MultipleChoiceExerciseScreenState
    extends State<MultipleChoiceExerciseScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _animation;

  final int _timeLimitInSeconds =
      300; // Set countdown time limit here (e.g., 300 seconds = 5 minutes)
  late int _remainingTimeInSeconds;
  Timer? _timer;

  int _currentQuestionIndex = 0;
  int _selectedIndex = -1;
  bool _isOptionLocked = false;
  int _score = 0;
  int _correctAnswerIndex = 0;
  List<String> _shuffledOptions = [];

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is the capital of France?",
      "options": ["Berlin", "Madrid", "Paris", "Rome"],
      "answer": "2"
    },
    {
      "question": "Which planet is known as the Red Planet?",
      "options": ["Earth", "Venus", "Mars", "Jupiter"],
      "answer": "2"
    },
    {
      "question": "Which is the largest mammal?",
      "options": ["Elephant", "Blue Whale", "Giraffe", "Shark"],
      "answer": "1"
    },
  ];

  @override
  void initState() {
    super.initState();
    _remainingTimeInSeconds = _timeLimitInSeconds; // Initialize countdown time

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(_animationController);

    _startTimer();
    _shuffleOptions();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTimeInSeconds > 0) {
        setState(() {
          _remainingTimeInSeconds--;
        });
      } else {
        timer.cancel();
        Navigator.of(context)
            .pop(); // Return to previous screen when time is up
      }
    });
  }

  void _shuffleOptions() {
    final options =
        List<String>.from(_questions[_currentQuestionIndex]['options']);
    final correctAnswerText =
        options[int.parse(_questions[_currentQuestionIndex]['answer'])];
    options.shuffle(Random());

    setState(() {
      _shuffledOptions = options;
      _correctAnswerIndex = options.indexOf(correctAnswerText);
      _animationController.reset();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildTimer() {
    int minutes = _remainingTimeInSeconds ~/ 60;
    int seconds = _remainingTimeInSeconds % 60;

    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
        style: const TextStyle(
          fontSize: 24,
          color: Colors.amber,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade800, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimer(),
            const SizedBox(height: 20),
            _buildQuestion(),
            const SizedBox(height: 20),
            SlideTransition(position: _animation, child: _buildOptions()),
            const SizedBox(height: 30),
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestion() {
    return Text(
      _questions[_currentQuestionIndex]['question'],
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(_shuffledOptions.length, (index) {
        return GestureDetector(
          onTap: _isOptionLocked
              ? null
              : () {
                  setState(() {
                    _selectedIndex = index;
                    _checkAnswer(index);
                    _isOptionLocked = true;
                  });
                },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? Colors.green.withOpacity(0.3)
                  : Colors.grey[700],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _selectedIndex == index ? Colors.green : Colors.white,
              ),
            ),
            child: ListTile(
              title: Text(
                _shuffledOptions[index],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _selectedIndex == -1 ? null : _nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedIndex == -1 ? Colors.grey : Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: const Text(
        "NEXT",
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _checkAnswer(int index) {
    if (index == _correctAnswerIndex) {
      setState(() {
        _score++;
      });
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedIndex = -1;
        _isOptionLocked = false;
        _shuffleOptions();
      });
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quiz Completed", style: TextStyle(fontSize: 24)),
        content: Text(
          "You scored $_score out of ${_questions.length}",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetQuiz();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _score = 0;
      _currentQuestionIndex = 0;
      _selectedIndex = -1;
      _isOptionLocked = false;
      _remainingTimeInSeconds = _timeLimitInSeconds;
      _shuffleOptions();
    });
    _startTimer();
  }
}
