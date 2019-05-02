import 'package:flutter/material.dart';
import 'dart:async'; import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:rit_app/models/Beat.dart';
import 'package:rit_app/models/BeatDisplay.dart';
import 'package:rit_app/models/Constants.dart';


class MetronomePage extends StatefulWidget { @override MetronomePageState createState() => MetronomePageState(); }

class MetronomePageState extends State<MetronomePage> {

  // instance variables
  int tempo;
  Timer timer;
  Duration tempoDuration;

  int topTimeSignature, bottomTimeSignature;
  Icon metronomeIcon;

  int currentBeat;
  bool isMetronomePlaying;

  List<BeatDisplay> beatDisplays;
  Widget beatDisplayRow;
  Widget timeSignatureButton;
  Widget tempoButton;
  Widget playButton;

  @override
  Widget build(BuildContext context) {

    bool notNull(Object o) =>  o != null;

    return Scaffold(

      body: Container(
        child: SafeArea(

          child: Center(

            child: Column(

              children: <Widget>[

                tempoButton,


                Row(
                  children: <Widget>[

                    timeSignatureButton,
                    beatDisplayRow

                  ].where(notNull).toList(),
                ),


                playButton


              ],
            )
          ),
        ),
      ),


    );

  }

  @override
  void initState() {
    super.initState();

    // initialize base tempo and time signature
    tempo = 120;
    setTempoDuration();

    topTimeSignature = 4; bottomTimeSignature = 4;

    // initialize metronome settings
    currentBeat = 0;
    isMetronomePlaying = false;
    timer = Timer(tempoDuration, () => print('init'));

    // initialize widgets
    setMetronomeIcon();
    tempoButton = FlatButton(
      child: Row(
        children: <Widget>[

          metronomeIcon,
          Text(' = ' + tempo.toString())

        ],
      ),

      onPressed: () => setTempo(),
    );

    timeSignatureButton = FlatButton(
      child: Column(
        children: <Widget>[
          Text(topTimeSignature.toString()),
          Divider(),
          Text(bottomTimeSignature.toString())
        ]
      ),

      onPressed: () => setTimeSignature(),
    );

    playButton = FlatButton(child: Icon(Icons.play_arrow), onPressed: () => toggleMetronome());


    // initialize beats and displays
    beatDisplays = List<BeatDisplay>();
    initBeatDisplays();

    print(beatDisplays.toString());
  }

  // setting functions
  void setTempoDuration() { tempoDuration = Duration(milliseconds: (Constants.MINUTE_IN_MILLISECONDS/tempo).floor()); }
  void setTempo() {}
  void setTimeSignature() {}

  // widget functions
  void setMetronomeIcon() {
    setState(() {
      switch (bottomTimeSignature) {
        case 2:
          metronomeIcon = Icon(Constants.half); break;
        case 4:
          metronomeIcon = Icon(Constants.quarter); break;
        case 8:
          metronomeIcon = Icon(Constants.eighth); break;
        default:
          metronomeIcon = Icon(Constants.quarter); break;
      }
    });
  }
  void initBeatDisplays() {
    beatDisplays.clear();
    for (int i = 0; i < topTimeSignature; i++) {
      beatDisplays.add(BeatDisplay(bottomTimeSignature));
    }
    beatDisplayRow = Row(children: beatDisplays);
  }
  void setBeatDisplays() {
    setState(() {
      beatDisplays.clear();
      for (int i = 0; i < topTimeSignature; i++) {
        beatDisplays.add(BeatDisplay(bottomTimeSignature));
      }
      beatDisplayRow = Row(children: beatDisplays);
    });
  }
  void disableBeatDisplays() {
    beatDisplays.forEach((display) => display.setIsOn(false));
  }

  // metronome functions
  void toggleMetronome() {
    isMetronomePlaying = isMetronomePlaying ? false : true;
    currentBeat = 0;
    setBeatDisplays();
    if (isMetronomePlaying) { playMetronome(); }
    else { timer.cancel(); disableBeatDisplays(); }
  }
  // TODO: fix 'setState() called in constructor: 4' error when pressed
  void playMetronome() {

    disableBeatDisplays();

    // highlight current display
    beatDisplays.elementAt(currentBeat).setIsOn(true);

    // add to current beat
    currentBeat++;
    if (currentBeat == topTimeSignature) { currentBeat = 0; }
    timer = Timer(tempoDuration, () => playMetronome());


  }



}