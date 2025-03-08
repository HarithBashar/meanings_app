import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/ui/quiz/score_page.dart';
import 'package:vibration/vibration.dart';

import '../../resources/classes/app_data.dart';

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
  bool isCorrect = false;

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
                  child: Text.rich(
                    TextSpan(
                      text: "Question: ",
                      children: [
                        TextSpan(
                          text: "${currentQuestion + 1}",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextSpan(text: "/${controller.quiz.length}"),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: size.width * .4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isPressed
                        ? isCorrect
                            ? Colors.green[300]
                            : Colors.red[300]
                        : Colors.deepPurple[400],
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
                    controller.quiz[currentQuestion].word.capitalizeFirst!,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: [
                      for (int i = 0; i < 4; i++)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]!),
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
                            child: Text(controller.quiz[currentQuestion].options[i].capitalizeFirst!),
                          ),
                          onPressed: () async {
                            if (isPressed) return;
                            selectedAnswer = controller.quiz[currentQuestion].options[i];
                            if (controller.quiz[currentQuestion].options[i] == controller.quiz[currentQuestion].answer) score++;
                            isCorrect = selectedAnswer == controller.quiz[currentQuestion].answer;
                            setState(() => isPressed = true);
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
      if (controller.useSound) {
        String path = isCorrect ? 'sounds/correct1.wav' : 'sounds/wrong1.wav';
        await player.play(AssetSource(path));
      }

      if (controller.useVibration && await Vibration.hasVibrator()) {
        if (isCorrect) {
          Vibration.vibrate(duration: 100, amplitude: 100);
        } else {
          Vibration.vibrate(duration: 250, amplitude: 1000);
        }
      }
    } catch (e, f) {
      debugPrint("$e\n$f");
    }
  }
}
