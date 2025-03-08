import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meaning/ui/home_page.dart';

class ScorePage extends StatelessWidget {
  const ScorePage({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  final int score;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your Score",
              style: TextStyle(fontSize: 30),
            ),
            Text.rich(
              TextSpan(
                text: "$score",
                style: TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                  color: score >= totalQuestions / 2 ? Colors.green : Colors.red,
                ),
                children: [
                  TextSpan(
                    text: "/$totalQuestions",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  score >= totalQuestions / 2 ? Icons.done : Icons.clear,
                  size: 100,
                  color: score >= totalQuestions / 2 ? Colors.green : Colors.red,
                ),
                Text(
                  score >= totalQuestions / 2 ? "Passed" : "Failed",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: score >= totalQuestions / 2 ? Colors.green : Colors.red,
                  ),
                ),
              ],
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
}
