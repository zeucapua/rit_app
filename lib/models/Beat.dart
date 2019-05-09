class Beat {

  // instance variables
  // TODO: add dotted values for each of these
  int value; // note value: 16 - whole, 8 - half, 4 - quarter, 2 - eighth, 1 - sixteenth
  int sound; // if -1, play SystemSound : else play midi equivalent
  bool isOn; // if note is being played - true, vice versa
  Duration beatDuration; // the actual amount ms

  // constructor
  Beat(this.value) { isOn = false; beatDuration = Duration(); /* init */ }

  // methods
  void setSound(int toSet) { sound = toSet; }
  void setValue(int toSet) { value = toSet; }
  void setIsOn(bool toSet) { isOn = toSet; }

  void setBeatDuration(int bottomTimeSignature, Duration tempoDuration) {

    // if time signature is * / 4 [common time]
    if (bottomTimeSignature == 4) {
      switch (value) {
        case 16: beatDuration = tempoDuration * 4; break;
        case 8: beatDuration = tempoDuration * 2; break;
        case 4: beatDuration = tempoDuration;     break;
        case 2:  beatDuration = tempoDuration ~/ 2; break;
        case 1: beatDuration = tempoDuration ~/ 4; break;
        default: print("Invalid Value");       break;
      }
    }

    // if time signature is * / 8 [duple meter]
    else if (bottomTimeSignature == 8) {
      switch (value) {
        case 16: beatDuration = tempoDuration * 8; break;
        case 8: beatDuration = tempoDuration * 4; break;
        case 4: beatDuration = tempoDuration * 2; break;
        case 2: beatDuration = tempoDuration;     break;
        case 1: beatDuration = tempoDuration ~/ 2; break;
        default: print("Invalid Value");       break;
      }
    }

    // if time signature is * / 2 [cut time]
    else if (bottomTimeSignature == 2) {
      switch (value) {
        case 16: beatDuration = tempoDuration * 2; break;
        case 8: beatDuration = tempoDuration; break;
        case 4: beatDuration = tempoDuration ~/ 2; break;
        case 2: beatDuration = tempoDuration ~/ 4; break;
        case 1: beatDuration = tempoDuration ~/ 8; break;
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