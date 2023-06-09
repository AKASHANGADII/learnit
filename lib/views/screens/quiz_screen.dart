import 'dart:math';

import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnit/utils/data.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
import 'package:learnit/views/screens/results_screen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

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
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final value = StopWatchTimer.getMilliSecFromSecond(60 * 60);

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
    questions = getRandomGroup(questionsData, 3);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    output.add({});
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.08),
        child: Center(
          child: Column(
            children: [
              SafeArea(
                child: Text(
                  "Learn IT",
                  style: GoogleFonts.podkova(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 38),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Divider(color: Colors.red,),
            SizedBox(
              height: 5,
            ),
            StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: 0,
              builder: (context, snap) {
                final value = snap.data;
                final displayTime = StopWatchTimer.getDisplayTime(value!);
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        displayTime,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Helvetica',
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Text(questions[curIndex],style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 20),),
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
                                  Text(
                                    values,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  if (output[curIndex][values] != null)
                                    Text(" : " + output[curIndex][values], style: GoogleFonts.poppins(fontSize: 18),),
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
                //n-2
                if (curIndex > 1) {
                  print(output);
                  Get.to(ResultsScreen(questions: questions, answers: output));
                } else {
                  setState(() {
                    curIndex = curIndex + 1;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.all(10),
                width: double.infinity,
                decoration: neumorphicDecoration(15).copyWith(color: Colors.red),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Next Question", style: GoogleFonts.poppins(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
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
