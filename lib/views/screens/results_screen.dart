import 'package:flutter/material.dart';
import 'package:learnit/utils/neo_box_decoration.dart';

class ResultsScreen extends StatefulWidget {
  static const routeName = '/results-screen';
  final List<String> questions;
  final List<Map<String, dynamic>> answers;

  ResultsScreen({super.key, required this.questions, required this.answers});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late List<Map<String, dynamic>> actualAnwers;
  int curIndex = -1;
  fetchTheAnswers() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Results"),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: widget.questions.map((question) {
                  curIndex++;
                  return Container(
                    decoration: neumorphicDecoration(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Answers")
                          ],
                        ),
                        Container(
                          height: 500,
                          child: ListView(
                            children: question.split(" ").map((word) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(word),
                                  Text(widget.answers[curIndex][word])
                                ],
                              );
                            }).toList(),
                          ),
                        )

                      ],
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ));
  }
}
