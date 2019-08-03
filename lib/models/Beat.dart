class Beat {

  // instance variables
  // TODO: add dotted values for each of these
  int value; // note value (see setBeatDuration() for number meanings)
  int sound; // if -1, play SystemSound : else play midi equivalent
  bool isRest; // if a rest note, true; vice versa.
  Duration beatDuration; // the actual amount ms

  // constructor
  Beat(this.value, this.isRest) {
    if (isRest) { setSound(-1); }
    else { setSound(60); /* init */ }
    beatDuration = Duration(); /* init */
  }

  // methods
  void setSound(int toSet) { sound = toSet; }
  void setValue(int toSet) { value = toSet; }

  void setBeatDuration(int bottomTimeSignature, Duration tempoDuration) {

    // if time signature is * / 4 [common time]
    if (bottomTimeSignature == 4) {
      switch (value) {
        case 24: beatDuration = tempoDuration * 6; break;  // dotted whole
        case 16: beatDuration = tempoDuration * 4; break;  // whole
        case 12: beatDuration = tempoDuration * 3; break;  // dotted half
        case 8: beatDuration = tempoDuration * 2; break;   // half
        case 6: beatDuration = tempoDuration * 1.5; break; // dotted quarter
        case 4: beatDuration = tempoDuration;     break;   // quarter
        case 53: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (4/3)).floor()); break; // half triplet
        case 32: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (4/5)).floor()); break; // quarter quintuplet
        case 3: beatDuration =  Duration(milliseconds: (tempoDuration.inMilliseconds * (3/4)).floor()); break; // dotted eighth
        case 26: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/3)).floor()); break; // quarter triplet
        case 2:  beatDuration = tempoDuration ~/ 2; break; // eighth
        case 160: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/5)).floor()); break; // eighth quintuplet
        case 13: beatDuration = tempoDuration ~/ 3; break; // eighth triplet
        case 1: beatDuration = tempoDuration ~/ 4; break;  // sixteenth
        case 80: beatDuration = tempoDuration ~/ 5; break; // sixteenth quintuplet
        default: print("Invalid Value");       break;
      }
    }

    // if time signature is * / 8 [duple meter]
    else if (bottomTimeSignature == 8) {
      switch (value) {
        case 24: beatDuration = tempoDuration * 12; break;
        case 16: beatDuration = tempoDuration * 8; break;
        case 12: beatDuration = tempoDuration * 6; break;
        case 8: beatDuration = tempoDuration * 4; break;
        case 6: beatDuration = tempoDuration * 3; break;
        case 53: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (8/3)).floor()); break;
        case 4: beatDuration = tempoDuration * 2; break;
        case 32: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (8/5)).floor()); break;
        case 3: beatDuration = tempoDuration * 1.5; break;
        case 26: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (4/3)).floor()); break;
        case 2: beatDuration = tempoDuration;     break;
        case 160: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (4/5)).floor()); break;
        case 13: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/3)).floor()); break;
        case 1: beatDuration = tempoDuration ~/ 2; break;
        case 80: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/5)).floor()); break;
        default: print("Invalid Value");       break;
      }
    }

    // if time signature is * / 2 [cut time]
    else if (bottomTimeSignature == 2) {
      switch (value) {
        case 24: beatDuration = tempoDuration * 3; break;
        case 16: beatDuration = tempoDuration * 2; break;
        case 12: beatDuration = tempoDuration * 1.5; break;
        case 8: beatDuration = tempoDuration ; break;
        case 6: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * 0.75).floor()); break;
        case 53: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/3)).floor()); break;
        case 4: beatDuration = tempoDuration ~/ 2; break;
        case 32: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * (2/5)).floor()); break;
        case 3: beatDuration = Duration(milliseconds: (tempoDuration.inMilliseconds * 0.375).floor()); break;
        case 26: beatDuration = tempoDuration ~/ 3; break;
        case 2: beatDuration = tempoDuration ~/ 4; break;
        case 160: beatDuration = tempoDuration ~/ 5; break;
        case 13: beatDuration = tempoDuration ~/ 6; break;
        case 1: beatDuration = tempoDuration ~/ 8; break;
        case 80: beatDuration = tempoDuration ~/ 10; break;
        default: print("Invalid Value");       break;
      }
    }


  }


  @override
  String toString() {
    // TODO: implement toString
    return value.toString();
  }
}