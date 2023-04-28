import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactScreen extends StatelessWidget {
  static const routeName = "/contact-screen";

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
      body: Padding(
        padding: const EdgeInsets.only(left: 25, top: 25, bottom: 40, right: 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Tawk(
            directChatLink: 'https://tawk.to/chat/62b6fc6b7b967b1179967538/1g6dck26v',
            visitor: TawkVisitor(
              name: user?.displayName ?? "Username",
              email: user?.email ?? "Email N/A",
            ),
          ),
        ),
      ),
    );
  }
}