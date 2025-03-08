import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meaning/resources/classes/app_data.dart';
import 'package:meaning/resources/classes/word_class.dart';
import 'package:meaning/resources/constants.dart';
import 'package:meaning/ui/home_page.dart';

void main() async {
  await GetStorage.init();
  Get.put(AppData());

  // Hive init
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(WordAdapter());

  wordsBox = await Hive.openBox('allWords');
  // wordsBox.clear();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Get.find<AppData>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Meaning',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          toolbarHeight: 40,
          backgroundColor: Colors.transparent,
        ),
        fontFamily: mainFont,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
