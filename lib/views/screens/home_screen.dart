import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnit/controllers/test_data_controller.dart';
import 'package:learnit/utils/neo_box_decoration.dart';
import 'package:learnit/views/screens/contact_screen.dart';
import 'package:learnit/views/screens/pronounciation_screen.dart';
import 'package:learnit/views/screens/quiz_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:learnit/models/test_data.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';
  HomeScreen({Key? key}) : super(key: key);

  TestHistoryController testDataController = Get.put(TestHistoryController());

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size(double.infinity, MediaQuery.of(context).size.height * 0.08),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Learn IT",
                style: GoogleFonts.podkova(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 40),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(color: Colors.red,),
            SizedBox(
              height: 20,
            ),
            Text("POS Test History", style: GoogleFonts.poppins(fontSize: 20,),textAlign: TextAlign.center,),
            SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.email!.toString())
                  .collection('testhistory')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData){
                  print(snapshot.data!.docs[0]["id"]);
                  List testHistoryList = snapshot.data!.docs;
                  return CarouselSlider(
                    options: CarouselOptions(height: 150),
                    items: testHistoryList.map((testElement) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              padding: EdgeInsets.all(8),
                              decoration: neumorphicDecoration(20),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("Test " + testElement["id"].toString(), style: GoogleFonts.poppins(fontSize: 25),),
                                        Text(DateFormat.yMMMd()
                                            .format(testElement["date"].toDate())
                                            .toString(), style: GoogleFonts.poppins(fontSize: 15),),
                                        Text(testElement["remark"], style: GoogleFonts.poppins(fontSize: 25, color: (testElement["remark"]=="Bad") ? Colors.red : Colors.green ),),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    CircularPercentIndicator(
                                      center: Text(
                                          "${testElement["obtained"]}/${testElement["total"]}"),
                                      percent: testElement["obtained"] == "0"
                                          ? 0
                                          : testElement["obtained"] /
                                          testElement["total"],
                                      radius: 30,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
                else{
                  return Center(child: CircularProgressIndicator(),);
                }
              }
            ),
            SizedBox(
              height: 20,
            ),
            Text("What do you want to do ?", style: GoogleFonts.poppins(fontSize: 20,),textAlign: TextAlign.center,),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewTestOptionButton(
                  label: "Parts of speech",
                  onPressed: () {
                    Get.to(QuizScreen());
                  },
                ),
                NewTestOptionButton(
                  label: "Pronounciation",
                  onPressed: () {
                    Get.to(()=>PronounciationScreen());
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                NewTestOptionButton(
                  label: "Learn Words",
                  onPressed: () {
                    //TODO:Navigate to test screen
                  },
                ),
                NewTestOptionButton(
                  label: "Talk to teacher",
                  onPressed: () {
                    Get.to(()=> ContactScreen());
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NewTestOptionButton extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const NewTestOptionButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 150,
        width: 150,
        decoration: neumorphicDecoration(20),
        child: Center(
            child: Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 15),
        )),
      ),
    );
  }
}
