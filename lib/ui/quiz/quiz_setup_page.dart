import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/resources/classes/app_data.dart';
import 'package:meaning/resources/classes/word_class.dart';
import 'package:meaning/resources/constants.dart';
import 'package:meaning/ui/components/my_button.dart';
import 'package:meaning/ui/quiz/quiz_page.dart';
import 'package:squiggly_slider/slider.dart';

class QuizSetupPage extends StatefulWidget {
  const QuizSetupPage({super.key});

  @override
  State<QuizSetupPage> createState() => _QuizSetupPageState();
}

class _QuizSetupPageState extends State<QuizSetupPage> {
  AppData controller = Get.find<AppData>();
  bool isWordsExam = true;
  bool isTodayWords = false;
  bool isRandomChoice = true;

  List<Word> examWords = [];
  late double numberOfQuestions;

  @override
  void initState() {
    numberOfQuestions = controller.allWords.length > 4 ? (controller.allWords.length / 2 > 50 ? 50 : controller.allWords.length / 2) : 4;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Setup"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              children: [
                Text(
                  "Choose the type of quiz",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButton(
                        backgroundColor: !isWordsExam ? Colors.deepPurple[800] : Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        onPressed: () {
                          setState(() => isWordsExam = false);
                        },
                        child: Text(
                          'Meaning',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        backgroundColor: isWordsExam ? Colors.deepPurple[800] : Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                SizedBox(height: 20),
                Text(
                  "Choose the number of questions",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SquigglySlider(
                        min: 4,
                        max: controller.allWords.length > 50 ? 50 : controller.allWords.length.toDouble(),
                        squiggleAmplitude: 3.0,
                        squiggleWavelength: 5.0,
                        squiggleSpeed: .1,
                        value: numberOfQuestions,
                        onChanged: (double value) {
                          setState(() => numberOfQuestions = value);
                        },
                        label: '$numberOfQuestions',
                      ),
                    ),
                    Text(
                      numberOfQuestions.toInt().toString(),
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Choose the words for the quiz',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          MyButton(
                            backgroundColor: !isTodayWords ? Colors.deepPurple[800] : Colors.deepPurple[200],
                            borderRadius: BorderRadius.circular(10),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            onPressed: () {
                              if (!isTodayWords) isRandomChoice = !isRandomChoice;
                              setState(() => isTodayWords = false);
                            },
                            child: Text(
                              isRandomChoice ? 'Random Choice' : 'First ${numberOfQuestions.toInt()} Words',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Icon(Icons.refresh_rounded, color: Colors.white, size: 15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyButton(
                        backgroundColor: isTodayWords ? Colors.deepPurple[800] : Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        onPressed: () => setState(() => isTodayWords = true),
                        child: Text(
                          'Today Words',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          MyButton(
            backgroundColor: Colors.pinkAccent,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
            borderRadius: BorderRadius.circular(10),
            onPressed: () {
              initializeExamWords();
              if (examWords.length < 4) {
                Get.snackbar('Error', 'You need at least 4 words TODAY to start the quiz');
                return;
              }
              controller.getQuizReady(isWordsExam, examWords);
              Get.off(() => QuizPage());
            },
            child: Text('Start Quiz', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          SafeArea(child: SizedBox()),
        ],
      ),
    );
  }

  void initializeExamWords() {
    examWords.clear();
    if (isTodayWords) {
      for (Word word in controller.allWords) {
        if (isSameDay(DateTime.now(), word.timeAdded)) {
          examWords.add(word);
        }
      }
    } else {
      if (isRandomChoice) controller.allWords.shuffle();
      examWords.addAll(controller.allWords.sublist(0, numberOfQuestions.toInt()));
      controller.allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
    }
  }
}
