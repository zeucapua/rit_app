import 'package:flutter/material.dart';

// for variables to be used for easy access
class Constants {

  // one minute in milliseconds
  static const int MINUTE_IN_MILLISECONDS = 60000;

  // IconData for each of the vector notes
  // TODO: add dotted icons and rests
  static const IconData whole = IconData(0xe900, fontFamily: 'whole');
  static const IconData half = IconData(0xe900, fontFamily: 'half');
  static const IconData quarter = IconData(0xe900, fontFamily: 'quarter');
  static const IconData eighth = IconData(0xe900, fontFamily: 'eighth');
  static const IconData sixteenth = IconData(0xe900, fontFamily: 'sixteenth');

  static const IconData wholeRest = IconData(0xe900, fontFamily: 'whole_rest');
  static const IconData halfRest = IconData(0xe900, fontFamily: 'half_rest');
  static const IconData quarterRest = IconData(0xe900, fontFamily: 'quarter_rest');
  static const IconData eighthRest = IconData(0xe900, fontFamily: 'eighth_rest');
  static const IconData sixteenthRest = IconData(0xe900, fontFamily: 'thirtysecond_rest');

  // constant beat display size
  static const double BEATDISPLAY_SIZE = 50.0;
}