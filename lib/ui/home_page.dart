import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/resources/classes/app_data.dart';
import 'package:meaning/ui/quiz_page.dart';

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      // extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          TextEditingController wordController = TextEditingController();
          TextEditingController meaningController = TextEditingController();

          bool isAdded = false;
          await Get.defaultDialog(
            title: "Add Word",
            content: Column(
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
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text("Words"),
        automaticallyImplyLeading: true,
        forceMaterialTransparency: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 40,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SafeArea(bottom: false, child: SizedBox()),
          CupertinoButton(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              alignment: Alignment.center,
              child: Text(
                "Start Quiz",
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              controller.getQuizReady();
              Get.to(() => const QuizPage());
            },
          ),
          Expanded(
            child: GetBuilder(
              init: AppData(),
              builder: (controller) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.allWords.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        controller.allWords[index].word,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Text(
                        controller.allWords[index].meaning,
                        style: TextStyle(fontSize: 15),
                      ),
                      onLongPress: () {
                        controller.deleteWord(controller.allWords[index].id);
                      },
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
}
