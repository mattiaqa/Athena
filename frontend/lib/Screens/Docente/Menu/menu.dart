import 'package:flutter/material.dart';
import 'package:frontend/Screens/Docente/Menu/menu_item.dart';

class MenuComponent extends StatefulWidget {
  @override
  State<MenuComponent> createState() => MenuComponentState();
}

class MenuComponentState extends State<MenuComponent> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          "Ciao, Professore",
          style: TextStyle(
            color: Color.fromARGB(255, 209, 67, 67),
            fontFamily: 'SourceSansPro',
            fontWeight: FontWeight.w600,
            fontSize: 44,
          ),
        ),
        Divider(
          height: 20,
        ),
        Row(
          children: [
            VerticalDivider(
              width: 30,
            ),
            Expanded(
                child: MenuItem(
                    imagePath: "images/libretto_icon_2.png",
                    label: "I miei Esami")),
            VerticalDivider(
              width: 30,
            ),
            Expanded(
                child: MenuItem(
                    imagePath: "images/iscrizione_icon_2.png",
                    label: "Appelli")),
            VerticalDivider(
              width: 30,
            ),
          ],
        ),
        Divider(
          height: 30,
        ),
      ],
    );
  }
}
