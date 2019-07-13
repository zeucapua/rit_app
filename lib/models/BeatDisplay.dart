import 'package:flutter/material.dart';
import 'package:rit_app/models/Beat.dart';
import 'package:rit_app/models/Constants.dart';

class BeatDisplay extends StatefulWidget {

  // state of BeatDisplay
  BeatDisplayState state;

  // constructor
  BeatDisplay({Beat beat, Key key}) : super(key: key) { state = BeatDisplayState(beat); }
  @override BeatDisplayState createState() => state;

  // methods for pages to use
  void setIsOn(bool toSet) { state.setIsOn(toSet); }
  void setValue(int toSet) { state.setValue(toSet); }
}

class BeatDisplayState extends State<BeatDisplay> {

  // instance variables
  Beat beat;
  bool isOn;
  Icon icon;

  // constructor
  BeatDisplayState(this.beat) { isOn = false; }

  // build
  @override
  Widget build(BuildContext context) {
    switch (beat.value) {
      case 16:
        icon = Icon(
            beat.isRest ? Constants.wholeRest : Constants.whole,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        );
        break;
      case 8:
        icon = Icon(
            beat.isRest ? Constants.halfRest : Constants.half,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        );
        break;
      case 4:
        icon = Icon(
            beat.isRest ? Constants.quarterRest : Constants.quarter,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        );
        break;
      case 2:
        icon = Icon(
            beat.isRest ? Constants.eighthRest : Constants.eighth,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        );
        break;
      case 1:
        icon = Icon(
            beat.isRest ? Constants.sixteenthRest : Constants.sixteenth,
            color: isOn ? Colors.blue : Colors.black,
            size: Constants.BEATDISPLAY_SIZE
        );
        break;
    }

    return Container(child: icon);
  }

  void setIsOn(bool toSet) { setState(() { isOn = toSet; }); }
  void setValue(int toSet) { setState(() { setValue(toSet); }); }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toString
    return beat.value.toString();
  }
}