import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:frontend/Screens/Studente/Menu/menu.dart';
import 'package:frontend/Common/page_dimensions.dart';
import 'package:frontend/Common/notifications.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  static PageDimensions dimensions = const PageDimensions(
      width: 800,
      height: 230,
      constraints: BoxConstraints(
        minWidth: 390,
        maxWidth: 700,
        maxHeight: 265,
        minHeight: 265,
      ));

  @override
  State<Menu> createState() => MenuState();
}

class MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      LoadNewPageNotification(
        width: Menu.dimensions.width,
        height: Menu.dimensions.height,
        constraints: Menu.dimensions.constraints,
      ).dispatch(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: SingleChildScrollView(child: MenuComponent()),
    );
  }
}
