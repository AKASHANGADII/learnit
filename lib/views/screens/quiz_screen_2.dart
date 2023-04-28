import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learnit/services/openai_service.dart';
import 'package:learnit/utils/data.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
import 'package:learnit/views/screens/results_screen.dart';
import 'package:collection/collection.dart';

class QuizScreen2 extends StatefulWidget {
  const QuizScreen2({Key? key}) : super(key: key);

  @override
  State<QuizScreen2> createState() => _QuizScreen2State();
}

class _QuizScreen2State extends State<QuizScreen2> {
  int curIndex = 0;
  bool isLoading=true;
  int curOption=0;
  List<String> questions = [];
  List<Map<String, dynamic>> actualAnswers = [];
  List<Map<String, dynamic>> output = [];


  void fetchTheAnswers() async {
    for (var question in questions) {
      var value = await OpenAiService.getWordCategories(question);
      actualAnswers.add(value);
    }
    //actualAnswers=[{"ABC":"abc"},{"DEF":"def"},{"GHI":"ghi"},{"JKl":"jkl"}];
    setState(() {
      isLoading = false;
    });
  }

  List<T> getRandomGroup<T>(List<T> list, int n) {
    final random = Random();
    final ques = Set<int>();

    while (ques.length < n) {
      ques.add(random.nextInt(list.length - 1));
    }

    return ques.map((i) => list[i]).toList();
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  @override
  void initState() {
    questions = getRandomGroup(questionsData, 2);
    fetchTheAnswers();
    super.initState();
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
      body: isLoading?Center(child: CircularProgressIndicator(),):Column(
        children: [
          Divider(color: Colors.red,),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: questions[curIndex].split(" ").map((val){
              return Container(
                margin: EdgeInsets.only(right: 2),
                  color: questions[curIndex].split(" ")[curOption]==val?Colors.lightBlue.withOpacity(0.6):Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Text(val,style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 16,color:  questions[curIndex].split(" ")[curOption]==val?Colors.white:Colors.black) ,),
                  ));}).toList(),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView(
              children: shuffle(actualAnswers[curIndex].values.toList()).map((option){
                return GestureDetector(
                  onTap: (){
                    if(curOption<questions[curIndex].split(" ").length-1){
                      output[curIndex][questions[curIndex].split(" ")[curOption]]=option;
                      setState(() {
                        curOption=curOption+1;
                      });

                    }
                    else{
                      print("done");
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 15),
                    decoration: neumorphicDecoration(15),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Center(child: Text(option,style: TextStyle(fontSize: 18))),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 5,),
          GestureDetector(
            onTap: (){
              //n-2
              if(curIndex>0){
                output[curIndex][questions[curIndex].split(" ")[curOption]]=actualAnswers[curIndex].values.toList()[curOption];
                print(output);
                Get.to(ResultsScreen(questions: questions, answers: output));
                print("object");
              }else {
                setState(() {
                  output[curIndex][questions[curIndex].split(" ")[curOption]]=actualAnswers[curIndex].values.toList()[curOption];
                  curIndex = curIndex + 1;
                  curOption=0;
                });
              }
            },
            child: Container(
              decoration: neumorphicDecoration(10).copyWith(color: Colors.red),
              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(child: Text("NEXT QUESTION",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w700),)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
