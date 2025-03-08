import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/ui/home_page.dart';
import 'package:vibration/vibration.dart';

import '../resources/classes/app_data.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  final int score;
  final int totalQuestions;

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  AudioPlayer player = AudioPlayer();
  AppData controller = Get.find<AppData>();
  late ConfettiController _confettiController;
  bool isSuccess = false;

  @override
  void initState() {
    isSuccess = widget.score >= widget.totalQuestions / 2;
    playFeedback(isSuccess);
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    if (isSuccess) {
      _confettiController.play(); // Play confetti for success
    }

    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Confetti animation for success
            if (isSuccess)
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      Text(
                        "🎉",
                        style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Text(
                        "Congratulations",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: -pi / 2,
                    shouldLoop: true,
                    colors: [Colors.red, Colors.green, Colors.blue, Colors.yellow, Colors.deepPurple, Colors.red],
                  ),
                ],
              ),

            const SizedBox(height: 30),
            Text(
              "Your Score",
              style: TextStyle(fontSize: 30),
            ),
            Text.rich(
              TextSpan(
                text: "${widget.score}",
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
                children: [
                  TextSpan(
                    text: "/${widget.totalQuestions}",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                playFeedback(isSuccess);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSuccess ? Icons.done : Icons.clear,
                    size: 100,
                    color: isSuccess ? Colors.green : Colors.red,
                  ),
                  Text(
                    isSuccess ? "Passed" : "Failed",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: isSuccess ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            // back to home button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                      "Back to Home",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Get.offAll(() => HomePage());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> successAssets = [
    "sounds/successScore1.mp3",
    "sounds/successScore2.wav",
    "sounds/successScore3.wav",
  ];

  List<String> failAssets = [
    "sounds/failedScore1.wav",
    "sounds/failedScore2.wav",
    "sounds/failedScore3.flac",
  ];

  void playFeedback(bool isSuccess) async {
    try {
      // play sound based on the answer
      if (controller.useSound) {
        String path = isSuccess ? successAssets[Random().nextInt(successAssets.length)] : failAssets[Random().nextInt(failAssets.length)];
        await player.play(AssetSource(path));
      }

      if (controller.useVibration && await Vibration.hasVibrator()) {
        if (isSuccess) {
          Vibration.vibrate(duration: 500, amplitude: 100);
        } else {
          Vibration.vibrate(duration: 1000, amplitude: 1000);
        }
      }
    } catch (e, f) {
      print("$e\n$f");
    }
  }
}
