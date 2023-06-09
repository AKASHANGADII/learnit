import 'package:flutter/material.dart';

BoxDecoration neumorphicDecoration(double radius) {
  return BoxDecoration(
      color: const Color(0XFFEFF3F6),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.9),
          offset: Offset(-10,-5),
          blurRadius: 6.0,
          spreadRadius: 3.0,
        ),
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(10,5),
          blurRadius: 6.0,
          spreadRadius: 3.0,
        ),

      ]
  );
}