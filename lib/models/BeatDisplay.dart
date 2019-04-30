import 'package:flutter/material.dart';
import 'package:rit_app/models/Constants.dart';

class BeatDisplay extends StatefulWidget {

  // state of BeatDisplay
  BeatDisplayState state;

  // constructor
  BeatDisplay(int value) { state = BeatDisplayState(value); }
  @override BeatDisplayState createState() => state;

  // methods for pages to use
  void setIsOn(bool toSet) { state.setIsOn(toSet); }
  void setValue(int toSet) { state.setValue(toSet); }

}

class BeatDisplayState extends State<BeatDisplay> {

  // instance variables
  int value;
  bool isOn;
  Icon icon;

  // constructor
  BeatDisplayState(this.value) { isOn = false; }


  // build
  @override
  Widget build(BuildContext context) {

    switch (value) {
      case 1:
        icon = Icon(
            Constants.whole,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 2:
        icon = Icon(
            Constants.half,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 4:
        icon = Icon(
            Constants.quarter,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 8:
        icon = Icon(
            Constants.eighth,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 16:
        icon = Icon(
            Constants.sixteenth,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
    }

    return Container( child: icon );

  }

  void setIsOn(bool toSet) { setState(() { isOn = toSet; }); }
  void setValue(int toSet) { setState(() { value = toSet; }); }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toString
    return value.toString();
  }
}