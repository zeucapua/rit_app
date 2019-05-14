import 'package:flutter/material.dart';
import 'package:rit_app/models/Constants.dart';

class BeatInput extends StatefulWidget {

  BeatInputState state;

  BeatInput(int value, bool isInputtingRests, GestureTapCallback onPressed) {
    state = BeatInputState(value, isInputtingRests, onPressed);
  }
  @override BeatInputState createState() => state;

  void setIsInputtingRests(bool toChange) { state.setIsInputtingRests(toChange); }

}

class BeatInputState extends State<BeatInput> {

  int value;
  bool isInputtingRests;
  final GestureTapCallback onPressed;

  BeatInputState(this.value, this.isInputtingRests, this.onPressed);


  @override
  Widget build(BuildContext context) {

    Icon noteIcon;

    // TODO: Make Stateful and add rest equivalents
    switch (value) {
      case 16: noteIcon = Icon(isInputtingRests ? Constants.wholeRest : Constants.whole); break;
      case 8: noteIcon = Icon(isInputtingRests ? Constants.halfRest : Constants.half); break;
      case 4: noteIcon = Icon(isInputtingRests ? Constants.quarterRest : Constants.quarter); break;
      case 2: noteIcon = Icon(isInputtingRests ? Constants.eighthRest : Constants.eighth); break;
      case 1: noteIcon = Icon(isInputtingRests ? Constants.sixteenthRest : Constants.sixteenth); break;
      case -1: noteIcon = Icon(Icons.radio_button_unchecked); break; // change into dot
      default: noteIcon = Icon(isInputtingRests ? Constants.wholeRest : Constants.quarter); break;
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

  void setIsInputtingRests(bool toChange) { setState(() {
    isInputtingRests = toChange;
  }); }

}