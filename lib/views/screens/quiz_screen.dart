import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:learnit/utils/data.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
import 'package:learnit/views/screens/results_screen.dart';

class QuizScreen extends StatefulWidget {
  static const routeName = '/quiz-screen';
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int curIndex = 0;
  List<String> questions = [];
  List<Map<String, dynamic>> output = [];

  List<T> getRandomGroup<T>(List<T> list, int n) {
    final random = Random();
    final ques = Set<int>();

    while (ques.length < n) {
      ques.add(random.nextInt(list.length - 1));
    }

    return ques.map((i) => list[i]).toList();
  }

  @override
  void initState() {
    questions = getRandomGroup(questionsData, 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    output.add({});
    return Scaffold(
      appBar: AppBar(
        title: Text("Quizz"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(questions[curIndex]),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: questions[curIndex]
                    .split(" ")
                    .map(
                      (values) => FocusedMenuHolder(
                        menuWidth: MediaQuery.of(context).size.width * 0.5,
                        onPressed: () {},
                        openWithTap: true,
                        menuItems: [
                          FocusedMenuItem(
                              title: Text("Adjective"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Adjective";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Adverb"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Adverb";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Conjunction"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Conjunction";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Determiner"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Determiner";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Noun"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Noun";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Number"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Number";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Preposition"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Preposition";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Pronoun"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Pronoun";
                                });
                              }),
                          FocusedMenuItem(
                              title: Text("Verb"),
                              onPressed: () {
                                setState(() {
                                  output[curIndex][values] = "Verb";
                                });
                              }),
                        ],
                        child: Container(
                          width: 100,
                          child: Center(
                              child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            decoration: neumorphicDecoration(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(values,style: TextStyle(fontWeight: FontWeight.bold),),
                                  if (output[curIndex][values] != null)
                                    Text(" : " + output[curIndex][values]),
                                ],
                              ),
                            ),
                          )),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (curIndex > 0) {
                  print(output);
                  Get.to(ResultsScreen(questions: questions,answers: output));
                } else {
                  setState(() {
                    curIndex = curIndex + 1;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                color: Colors.yellow,
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Next Question"),
                ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
