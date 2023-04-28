import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnit/services/openai_service.dart';
import 'package:learnit/utils/data.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ResultsScreen extends StatefulWidget {
  static const routeName = '/results-screen';
  final List<String> questions;
  final List<Map<String, dynamic>> answers;
  ResultsScreen({required this.questions, required this.answers});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  List<Map<String, dynamic>> actualAnswers = [];
  bool isLoading = true;
  double totalScore = 0;

  void fetchTheAnswers() async {
    for (var question in widget.questions) {
      var value = await OpenAiService.getWordCategories(question);
      actualAnswers.add(value);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchTheAnswers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Divider(
                  color: Colors.red,
                ),
                // CircularPercentIndicator(
                //   radius: 40,
                //   percent: totalScore != 0
                //       ? 0
                //       : (totalScore / (widget.questions.length * 10)) * 100,
                //   center:
                //       Text("${totalScore}/${widget.questions.length * 10}"),
                // ),
                Expanded(
                  child: ListView.builder(
                      itemCount: widget.questions.length,
                      itemBuilder: (context, index) {
                        int correct = 0;
                        widget.questions[index].split(" ").forEach((element) {
                          if (widget.answers[index][element] ==
                              actualAnswers[index][element]) {
                            correct++;
                          }
                        });
                        totalScore = totalScore +
                            ((correct /
                                    widget.questions[index].split(" ").length) *
                                10);
                        return Container(
                          margin: EdgeInsets.all(10),
                          decoration: neumorphicDecoration(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(widget.questions[index],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 19)),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Table(
                                    children: widget.questions[index]
                                        .split(" ")
                                        .map((word) {
                                      return TableRow(
                                        children: [
                                          Text(
                                            word,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16),
                                          ),
                                          Text(widget.answers[index][word],
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: widget.answers[index]
                                                              [word] ==
                                                          actualAnswers[index]
                                                              [word]
                                                      ? Colors.green
                                                      : Colors.red)),
                                          Text(actualAnswers[index][word],
                                              textAlign: TextAlign.right,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16,
                                                  color: Colors.green)),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Text(
                                    "${((correct / widget.questions[index].split(" ").length) * 10).toStringAsFixed(1)} / 10"),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  decoration:
                      neumorphicDecoration(10).copyWith(color: Colors.red),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Center(
                        child: Text(
                      "SAVE TEST REPORT",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),),
                  ),
                )
              ],
            ),
    );
  }
}
