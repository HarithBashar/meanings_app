import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                                      : Colors.red[200]
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
                            await Future.delayed(Duration(seconds: 2));
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
}
