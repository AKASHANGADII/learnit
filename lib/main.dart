import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learnit/firebase_options.dart';
import 'package:learnit/views/screens/auth_gate.dart';
import 'package:learnit/views/screens/home_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:learnit/views/screens/quiz_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:QuizScreen(),
      getPages:[
        GetPage(name: HomeScreen.routeName, page: ()=>HomeScreen()),
      ]
    );
  }
}
