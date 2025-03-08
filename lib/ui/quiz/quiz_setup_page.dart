import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/resources/classes/app_data.dart';
import 'package:meaning/ui/components/my_button.dart';
import 'package:meaning/ui/quiz/quiz_page.dart';

class QuizSetupPage extends StatefulWidget {
  const QuizSetupPage({super.key});

  @override
  State<QuizSetupPage> createState() => _QuizSetupPageState();
}

class _QuizSetupPageState extends State<QuizSetupPage> {
  bool isWordsExam = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Setup"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Choose the type of quiz",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: MyButton(
                    backgroundColor: !isWordsExam ? Colors.deepPurple[800] : Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    onPressed: () {
                      setState(() => isWordsExam = false);
                    },
                    child: Text(
                      'Meaning',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Expanded(
                  child: MyButton(
                    backgroundColor: isWordsExam ? Colors.deepPurple[800] : Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    onPressed: () {
                      setState(() => isWordsExam = true);
                    },
                    child: Text(
                      'Words',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          MyButton(
            backgroundColor: Colors.pinkAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
            borderRadius: BorderRadius.circular(10),
            onPressed: () {
              AppData controller = Get.find<AppData>();
              controller.getQuizReady(isWordsExam);
              Get.off(() => QuizPage());
            },
            child: Text('Start Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          SafeArea(child: SizedBox()),
        ],
      ),
    );
  }
}
