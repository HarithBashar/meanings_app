import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/resources/classes/app_data.dart';
import 'package:meaning/ui/components/my_button.dart';
import 'package:meaning/ui/quiz/quiz_setup_page.dart';
import 'package:meaning/ui/settings.dart';

import '../resources/classes/word_class.dart';
import '../resources/constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppData controller = Get.find<AppData>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SafeArea(bottom: false, child: SizedBox()),
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width / 50),
            child: Column(
              children: [
                // app title
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Expanded(
                          child: FittedBox(
                            alignment: Alignment.topLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "Word\nDictionary",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w700,
                                height: 0.9,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 60),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Get.to(() => const Settings());
                      },
                      icon: Icon(Icons.settings_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                // add new word
                Row(
                  children: [
                    Expanded(
                      child: MyButton(
                        backgroundColor: Colors.deepPurple[400],
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: () => addNewWord(),
                        child: Text(
                          "Add New Word",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    MyButton(
                      backgroundColor: Colors.deepPurple[900],
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 11),
                      margin: EdgeInsets.only(left: 10),
                      borderRadius: BorderRadius.circular(10),
                      onPressed: () => addNewWord(),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          const SizedBox(width: 5),
                          Text(
                            controller.allWords.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // search word and start quiz
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: MyButton(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded),
                            const SizedBox(width: 25),
                            Text(
                              "Search",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      flex: 2,
                      child: MyButton(
                        backgroundColor: Colors.pinkAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                        borderRadius: BorderRadius.circular(10),
                        onPressed: () {
                          if (controller.allWords.length < 4) {
                            Get.snackbar("Error", "You need at least 4 words to start the quiz", backgroundColor: Colors.red.shade300, colorText: Colors.white);
                            return;
                          }
                          Get.to(() => const QuizSetupPage());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.quiz_rounded, color: Colors.white),
                            const SizedBox(width: 15),
                            Text(
                              "Quiz",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GetBuilder(
              init: AppData(),
              builder: (controller) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: size.width / 50),
                  itemCount: controller.allWords.length,
                  itemBuilder: (context, index) {
                    Word word = controller.allWords[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onLongPress: () => controller.deleteWord(word.id),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Expanded(
                                  child: textCard(word.word, word.timeAdded),
                                ),
                                Icon(Icons.arrow_right_alt_sharp),
                                Expanded(
                                  child: textCard(word.meaning, word.timeAdded),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index == controller.allWords.length - 1) SafeArea(child: const SizedBox(height: 0)),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget textCard(String title, DateTime timeAdded) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: controller.useColoredTodayWords && isSameDay(DateTime.now(), timeAdded) ? Colors.deepPurple : Colors.grey[300]!),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 5),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(fontSize: 16, color: Colors.black, fontFamily: mainFont),
            textAlign: TextAlign.center,
          ),
        ),
        if (controller.useColoredTodayWords && isSameDay(DateTime.now(), timeAdded))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'New',
              style: TextStyle(fontSize: 8, color: Colors.deepPurple, fontFamily: mainFont),
            ),
          ),
      ],
    );
  }

  void addNewWord() async {
    TextEditingController wordController = TextEditingController();
    TextEditingController meaningController = TextEditingController();

    bool isAdded = false;
    await Get.defaultDialog(
      title: "Add Word",
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                labelText: "Word",
              ),
              autofocus: true,
            ),
            TextField(
              controller: meaningController,
              decoration: InputDecoration(
                labelText: "Meaning",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Get.back();
            isAdded = true;
          },
          child: Text("Add"),
        ),
      ],
    );
    if (isAdded) {
      Word word = Word(
        word: wordController.text.trim(),
        meaning: meaningController.text.trim(),
        timeAdded: DateTime.now(),
        language: "Turkish",
        id: getRandomID(),
      );
      controller.addWord(word);
    }
  }
}
