import 'package:flutter/material.dart';
import 'package:rit_app/models/Beat.dart';
import 'package:rit_app/models/Constants.dart';

class BeatDisplay extends StatefulWidget {

  // state of BeatDisplay
  BeatDisplayState state;

  // constructor
  BeatDisplay(Beat beat) { state = BeatDisplayState(beat); }
  @override BeatDisplayState createState() => state;

  // methods for pages to use
  void setIsOn(bool toSet) { state.setIsOn(toSet); }
  void setValue(int toSet) { state.setValue(toSet); }
}

class BeatDisplayState extends State<BeatDisplay> {

  // instance variables
  Beat beat;
  Icon icon;

  // constructor
  BeatDisplayState(this.beat);

  // build
  @override
  Widget build(BuildContext context) {

    switch (beat.value) {
      case 1:
        icon = Icon(
            Constants.whole,
            color: beat.isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 2:
        icon = Icon(
            Constants.half,
            color: beat.isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 4:
        icon = Icon(
            Constants.quarter,
            color: beat.isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 8:
        icon = Icon(
            Constants.eighth,
            color: beat.isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
      case 16:
        icon = Icon(
            Constants.sixteenth,
            color: beat.isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        ); break;
    }

    return Container(child: icon);
  }

  void setIsOn(bool toSet) { setState(() { beat.isOn = toSet; }); }
  void setValue(int toSet) { setState(() { beat.setValue(toSet); }); }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toString
    return beat.value.toString();
  }
}