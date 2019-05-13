import 'package:flutter/material.dart';
import 'package:rit_app/models/Constants.dart';

class BeatInput extends StatelessWidget {

  BeatInput(this.value, this.onPressed);

  int value;
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {

    Icon noteIcon;

    // TODO: Make Stateful and add rest equivalents
    switch (value) {
      case 16: noteIcon = Icon(Constants.whole); break;
      case 8: noteIcon = Icon(Constants.half); break;
      case 4: noteIcon = Icon(Constants.quarter); break;
      case 2: noteIcon = Icon(Constants.eighth); break;
      case 1: noteIcon = Icon(Constants.sixteenth); break;
      case -1: noteIcon = Icon(Icons.radio_button_unchecked); break; // change into dot
      default: noteIcon = Icon(Constants.quarter); break;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(minHeight: 100.0, minWidth: 100.0),
        child: Card(
          child: noteIcon,
        ),
      )
    );
  }



}