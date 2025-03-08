import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/ui/score_page.dart';
import 'package:vibration/vibration.dart';

import '../resources/classes/app_data.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  AppData controller = Get.find<AppData>();
  int currentQuestion = 0;
  int score = 0;

  bool isPressed = false;
  String selectedAnswer = '';

  AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Quiz")),
      body: Column(
        children: [
          SafeArea(bottom: false, child: SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: size.width * .4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple[100],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text("Question: ${currentQuestion + 1}"),
                ),
                Container(
                  width: size.width * .4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.deepPurple[400],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text("Score: $score", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          GetBuilder(
            init: AppData(),
            builder: (controller) {
              return Column(
                children: [
                  Text(
                    controller.quiz[currentQuestion].word,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      for (int i = 0; i < 4; i++)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[400]!),
                              color: isPressed
                                  ? controller.quiz[currentQuestion].options[i] == controller.quiz[currentQuestion].answer
                                      ? Colors.green[200]
                                      : selectedAnswer == controller.quiz[currentQuestion].options[i]
                                          ? Colors.red[200]
                                          : Colors.white
                                  : Colors.white,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            alignment: Alignment.center,
                            child: Text(controller.quiz[currentQuestion].options[i]),
                          ),
                          onPressed: () async {
                            if (isPressed) return;
                            selectedAnswer = controller.quiz[currentQuestion].options[i];
                            if (controller.quiz[currentQuestion].options[i] == controller.quiz[currentQuestion].answer) score++;
                            setState(() => isPressed = true);
                            bool isCorrect = selectedAnswer == controller.quiz[currentQuestion].answer;
                            playFeedback(isCorrect);
                            await Future.delayed(Duration(milliseconds: 1200));
                            if (currentQuestion + 1 == controller.quiz.length) {
                              Get.to(() => ScorePage(score: score, totalQuestions: controller.quiz.length));
                              return;
                            }
                            currentQuestion = (currentQuestion + 1) % controller.quiz.length;
                            setState(() => isPressed = false);
                          },
                        ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  void playFeedback(bool isCorrect) async {
    try {
      // play sound based on the answer
      String path = isCorrect ? 'sounds/correct1.wav' : 'sounds/wrong1.wav';
      await player.play(AssetSource(path));
      // vibration based on the answer
      // Vibrate on incorrect answers
      if (await Vibration.hasVibrator()) {
        if (isCorrect) {
          // Light vibration for correct answer
          Vibration.vibrate(duration: 100, amplitude: 100);
        } else {
          // Stronger vibration for incorrect answer
          Vibration.vibrate(duration: 250, amplitude: 1000);
        }
      }
    } catch (e, f) {
      print("$e\n$f");
    }
  }
}
