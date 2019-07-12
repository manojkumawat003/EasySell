import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class ChangeTheme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChangeTheme();
  }
}

class _ChangeTheme extends State<ChangeTheme> {
  var colorData = Color(0xff673ab7);

  @override
  Widget build(BuildContext context) {
    return MaterialColorPicker(
      onColorChange: (Color value) {
        colorData = value;
        print(value);
      },
    );
  }
}
