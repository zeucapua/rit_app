import 'package:flutter/material.dart';
import 'package:rit_app/models/Constants.dart';

class BeatDisplay extends StatefulWidget {

  // state of BeatDisplay
  BeatDisplayState state;
  bool shorrBet;

  // constructor
  BeatDisplay(int value, bool noteOrNo) { state = BeatDisplayState(value,noteOrNo); shorrBet = noteOrNo; }
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
  bool noteOrNo;

  // constructor
  BeatDisplayState(this.value,bool isItNote) { isOn = false; noteOrNo = isItNote;}

  // build
  @override
  Widget build(BuildContext context) {
if(noteOrNo) {
  switch (value) {
    case 16:
      icon = Icon(
          Constants.whole,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 8:
      icon = Icon(
          Constants.half,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 4:
      icon = Icon(
          Constants.quarter,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 2:
      icon = Icon(
          Constants.eighth,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 1:
      icon = Icon(
          Constants.sixteenth,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
  }
}
else {
  switch (value) {
    case 16:
      icon = Icon(
          Constants.wholeRest,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 8:
      icon = Icon(
          Constants.halfRest,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 4:
      icon = Icon(
          Constants.quarterRest,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 2:
      icon = Icon(
          Constants.eighthRest,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
    case 1:
      icon = Icon(
          Constants.sixteenthRest,
          color: isOn ? Colors.blue : Colors.black,
          size: Constants.BEATDISPLAY_SIZE
      );
      break;
  }
}

    return Container(child: icon);
  }

  void setIsOn(bool toSet) { setState(() { isOn = toSet; }); }
  void setValue(int toSet) { setState(() { setValue(toSet); }); }
  void setIcon(Icon toSet){setState((){icon = toSet;});}

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    // TODO: implement toString
    return value.toString();
  }
}