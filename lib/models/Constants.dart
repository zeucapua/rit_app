import 'package:flutter/material.dart';

// for variables to be used for easy access
class Constants {

  // one minute in milliseconds
  static const int MINUTE_IN_MILLISECONDS = 60000;

  // IconData for each of the vector notes
  // TODO: add dotted icons
  static const IconData whole = IconData(0xe900, fontFamily: 'whole');
  static const IconData half = IconData(0xe900, fontFamily: 'half');
  static const IconData quarter = IconData(0xe900, fontFamily: 'quarter');
  static const IconData eighth = IconData(0xe900, fontFamily: 'eighth');
  static const IconData sixteenth = IconData(0xe900, fontFamily: 'sixteenth');

  // constant beat display size
  static const double BEATDISPLAY_SIZE = 50.0;
}