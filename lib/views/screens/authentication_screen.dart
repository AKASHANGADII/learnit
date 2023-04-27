import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providerConfigs: [
        EmailProviderConfiguration(),
      ],
      showAuthActionSwitch: true,
      headerBuilder: (context, constraints, _) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              "https://tmlogosave.s3.ap-south-1.amazonaws.com/5313989.jpeg",
              width: double.infinity,
              fit: BoxFit.fitHeight,
            ),
          ),
        );
      },
      actions: [
        AuthStateChangeAction<SignedIn>((context, signedIn) async {
          //TODO: Go to home screen
        }),
      ],
    );
  }
}