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

  int currentBeat;
  bool isMetronomePlaying;

  List<Beat> beats;
  List<BeatDisplay> beatDisplays;
  Widget beatDisplayRow;
  Widget timeSignatureButton;


  // page widget
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: SafeArea(

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[

                //TODO: add widgets

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    timeSignatureButton, beatDisplayRow
                  ],
                ),

                IconButton(onPressed: () => toggleMetronome(), icon: Icon(Icons.play_arrow))

              ],


            ),
          ),


        ),
      ),


    );

  }

  //--- DATA methods ---

  @override
  void initState() {
    super.initState();

    // TODO: fix saved Data
    //initSavedData();
    tempo = 120;
    topTimeSignature = 4; bottomTimeSignature = 4;

    setTempoDuration();

    initBeats();

    currentBeat = 0;
    isMetronomePlaying = false;
    timer = Timer(tempoDuration, () => print('init timer'));

    beatDisplayRow = buildBeatDisplays();
    timeSignatureButton = buildTimeSignatureDisplay();
  }

  // check for local storage to set tempo and time signature with
  Future initSavedData() async {

    final prefs = await SharedPreferences.getInstance();

    // set tempo
    getTempoData(prefs).then((returnBool) => () { if (!returnBool) { tempo = 120; } } );

    print('tempo ' + tempo.toString() );

    // set time signature
    getTimeSignatureData(prefs).then((returnBool) => () {
      if (!returnBool) {
        topTimeSignature = 4;
        bottomTimeSignature = 4;
      }
    });
  }

  void initBeats() {
    beats = List<Beat>();
    beats.clear();

    for (int i = 0; i < topTimeSignature; i++) {
      beats.add(Beat(bottomTimeSignature, -1));
    }

  }

  // check and set for saved tempo in local storage
  Future<bool> getTempoData(SharedPreferences prefs) async {


    // get saved tempo data
    int savedTempo = prefs.getInt('tempo') ?? -1;

    if (savedTempo == -1) { return false; }
    else {
      tempo = savedTempo;
      return true;
    }


  }

  // check and set for saved time signature in local storage
  Future<bool> getTimeSignatureData(SharedPreferences prefs) async {

    // get saved time signature data
    int savedTop = prefs.getInt('topTimeSignature') ?? -1;
    int savedBot = prefs.getInt('bottomTimeSignature') ?? -1;

    if (savedTop == -1 && savedBot == -1) {return false;}
    else {
      topTimeSignature = savedTop;
      bottomTimeSignature = savedBot;
      return true;
    }


  }

  // use tempo to set tempo duration for timer to use
  void setTempoDuration() {
    tempoDuration = Duration(milliseconds: (Constants.MINUTE_IN_MILLISECONDS/tempo).floor());
  }


  //--- FUNCTION methods ---

  // loop around a bar
  void playMetronome(bool repeat) {

    // TODO: fix crashing when playing after updating beatdisplayrow
    print(beatDisplays.toString());

    if (repeat) { timer.cancel(); disableBeatDisplays(); }

    // safe guarding against accidental
    if (isMetronomePlaying) {

      beatDisplays.elementAt(currentBeat).setIsOn(true);

      // play sound (since it's a met, do not use pitches)
      SystemSound.play(SystemSoundType.click);

      // loop correctly
      currentBeat++; if ( currentBeat == topTimeSignature ) { currentBeat = 0; }

      // reset timer to do playMetronome() for the loop
      timer = Timer(tempoDuration, () => playMetronome(true));

    }


  }

  // toggle isMetronomePlaying between true and false to control metronome
  void toggleMetronome() {

    // toggle bool
    isMetronomePlaying = isMetronomePlaying ? false : true;

    // reset metronome
    timer.cancel();
    currentBeat = 0;


    // play metronome if true, disable metronome if false
    if (isMetronomePlaying) { playMetronome(false); }
    else { disableBeatDisplays(); }
  }

  // display AlertDialog with NumberPickers to change time signature
  void changeTimeSignature() {

    showDialog(
      context: context,
      builder: (BuildContext context) {

        int topToSet = topTimeSignature;
        int botToSet = bottomTimeSignature;

        return AlertDialog(
          title: Text('Change Time Signature'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              NumberPicker.integer(
                initialValue: topTimeSignature,
                minValue: 2, maxValue: 12,
                onChanged: (value) => topToSet = value,
              ),
              
              Text('/'),
              
              NumberPicker.integer(
                initialValue: bottomTimeSignature,
                minValue: 2, maxValue: 8,
                onChanged: (value) => botToSet = value,
              )
              
            ],
          ),
          
          actions: <Widget>[
            
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => setTimeSignature(topTimeSignature, bottomTimeSignature),
            ),


            FlatButton(
              child: Text('Confirm'),
              onPressed: () => setTimeSignature(topToSet, botToSet),
            )
            
          ],
        );


      }
    ).then((value) => {   });

  }

  // for changeTimeSignature() use
  void setTimeSignature(int topToSet, int botToSet) {
    setState(() {
      topTimeSignature = topToSet;
      bottomTimeSignature = botToSet;

      initBeats();
      beatDisplayRow = buildBeatDisplays();
      timeSignatureButton = buildTimeSignatureDisplay();

      setTempoDuration();
    });
    Navigator.pop(context);
  }

  //--- WIDGET methods ---

  // return a Row with beat displays
  Widget buildBeatDisplays() {

    beatDisplays = List<BeatDisplay>();
    beatDisplays.clear();

    beatDisplays = beats.map((beat) => BeatDisplay(beat.value)).toList();

    return Row( children: beatDisplays );

  }

  void disableBeatDisplays() {
    beatDisplays.forEach((display) => display.setIsOn(false));
  }

  // return a FlatButton that changes the time signature
  Widget buildTimeSignatureDisplay() {

    return FlatButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(topTimeSignature.toString()),

          Divider(),

          Text(bottomTimeSignature.toString())

        ],
      ),

      onPressed: () => changeTimeSignature(),

    );

  }

}