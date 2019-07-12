import 'package:flutter/material.dart';

class TitleDefault extends StatelessWidget {
  final String title;

  TitleDefault(this.title);

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: deviceWidth > 600 ? 26.0 : 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Oswald'),
    );
  }
}
