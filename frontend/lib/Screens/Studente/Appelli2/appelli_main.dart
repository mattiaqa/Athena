import 'package:flutter/material.dart';

import 'package:frontend/Screens/Studente/side_menu.dart';
import './appelli_screen.dart';

class Appelli2 extends StatefulWidget {
  const Appelli2({super.key});

  @override
  State<Appelli2> createState() => _LibrettoState();
}

class _LibrettoState extends State<Appelli2> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: LibrettoScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
