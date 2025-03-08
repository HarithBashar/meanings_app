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

  // =================== Settings ===================

  bool useVibration = true;
  bool useSound = true;
  bool useColoredTodayWords = true;

  void toggleVibration() {
    useVibration = !useVibration;
    getStorage.write('useVibration', useVibration);
    update();
  }

  void toggleSound() {
    useSound = !useSound;
    getStorage.write('useSound', useSound);
    update();
  }

  void toggleColoredTodayWords() {
    useColoredTodayWords = !useColoredTodayWords;
    getStorage.write('useColoredTodayWords', useColoredTodayWords);
    update();
  }

  // =================== initialize quiz ===================

  void getQuizReady() async {
    quiz.clear();
    allWords.shuffle();
    for (Word word in allWords) {
      quiz.add(Question(
        word: word.word,
        options: initialOptions(word),
        answer: word.meaning,
      ));
    }
    allWords.sort((a, b) => b.timeAdded.compareTo(a.timeAdded));
  }

  List<String> initialOptions(Word word) {
    List<String> options = [for (int i = 0; i < 3; i++) allWords[Random().nextInt(allWords.length)].meaning, word.meaning];
    options = options.toSet().toList();
    while (options.length < 4) {
      options = [for (int i = 0; i < 3; i++) allWords[Random().nextInt(allWords.length)].meaning, word.meaning];
      options = options.toSet().toList();
    }
    if (!options.contains(word.meaning)) options[Random().nextInt(4)] = word.meaning;
    options.shuffle();
    return options;
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

      // load settings data
      useVibration = getStorage.read('useVibration') ?? true;
      useSound = getStorage.read('useSound') ?? true;
      useColoredTodayWords = getStorage.read('useColoredTodayWords') ?? true;
    } catch (e, f) {
      if (kDebugMode) print("$e \n\n $f");
    }
  }
}
