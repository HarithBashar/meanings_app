import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:meaning/resources/classes/question_class.dart';
import 'package:meaning/resources/classes/word_class.dart';

import '../constants.dart';

class AppData extends GetxController {
  List<Word> allWords = [];
  List<Question> quiz = [];

  void addWord(Word word) {
    allWords.add(word);
    allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
    update();
    saveWord();
  }

  void editWord(Word word) {
    int index = allWords.indexWhere((element) => element.id == word.id);
    allWords[index] = word;
    allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
    update();
    saveWord();
  }

  void deleteWord(String id) {
    allWords.removeWhere((element) => element.id == id);
    allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
    update();
    saveWord();
  }

  // =================== initialize quiz ===================

  void getQuizReady() async {
    quiz.clear();
    allWords.shuffle();
    for (Word word in allWords) {
      List<String> options = [for (int i = 0; i < 3; i++) allWords[Random().nextInt(allWords.length)].meaning, word.meaning];
      options.shuffle();
      quiz.add(Question(
        word: word.word,
        options: options,
        answer: word.meaning,
      ));
    }
    allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
  }

  // =================== Saving and loading data ===================

  Future<void> saveWord() async {
    await wordsBox.put('allWords', allWords);
  }

  Future<void> loadData() async {
    try {
      int length = wordsBox.get('allWords', defaultValue: []).length;
      for (int i = 0; i < length; i++) {
        allWords.add(await wordsBox.get('allWords', defaultValue: [])[i]);
      }
      allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
      print(allWords.length);
    } catch (e, f) {
      if (kDebugMode) print("$e \n\n $f");
    }
  }
}
