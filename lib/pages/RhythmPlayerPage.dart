import 'package:flutter/material.dart';
import 'dart:async'; import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'package:rit_app/models/Beat.dart';
import 'package:rit_app/models/BeatDisplay.dart';
import 'package:rit_app/models/BeatInput.dart';
import 'package:rit_app/models/Constants.dart';

class RhythmPlayerPage extends StatefulWidget { @override RhythmPlayerPageState createState() => RhythmPlayerPageState(); }

class RhythmPlayerPageState extends State<RhythmPlayerPage> {

  // instance variables
  int tempo;
  Timer timer;
  Duration tempoDuration;

  int topTimeSignature, bottomTimeSignature;
  Icon metronomeIcon;

  int currentBeat;
  bool isMetronomePlaying;

  bool isInputtingRest;

  List<Beat> beats;
  List<BeatDisplay> beatDisplays;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: SafeArea(

          child: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  // bar display
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      // tempo button
                      FlatButton(
                        child: Row(
                          children: <Widget>[
                            metronomeIcon,
                            Text('= $tempo')
                          ],
                        ),
                        onPressed: () => showTempoDialog(),
                      ),


                      Align(
                        alignment: FractionalOffset.center,
                        child: Row(
                          children: <Widget>[

                            // time signature button
                            FlatButton(
                              child: Column(
                                  children: <Widget>[
                                    Text(topTimeSignature.toString()),
                                    Divider(),
                                    Text(bottomTimeSignature.toString())
                                  ]
                              ),

                              onPressed: () => showTimeSignatureDialog(),
                            ),
                            Container(
                              height: 100.0,
                              child: ListView.builder(
                                reverse: false,
                                shrinkWrap: true  ,
                                scrollDirection: Axis.horizontal,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: beatDisplays.length,
                                itemBuilder: (context, index) {
                                  return beatDisplays[index];
                                },
                              ),
                            )

                          ],
                        ),
                      ),

                      // play button
                      Align(
                        alignment: FractionalOffset.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 20.0),
                          child: FlatButton(
                            child: isMetronomePlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                            onPressed: () => togglePlayer(),
                          ),
                        ),
                      ),


                    ],
                  ),


                  // beat input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Column(
                        children: <Widget>[

                          Row(
                            children: <Widget>[

                              BeatInput(16, () => addBeat(Beat(16), isInputtingRest)),
                              BeatInput(8, () => addBeat(Beat(8), isInputtingRest)),
                              BeatInput(4, () => addBeat(Beat(4), isInputtingRest)),


                            ],
                          ),

                          Row(
                            children: <Widget>[

                              BeatInput(2, () => addBeat(Beat(2), isInputtingRest)),
                              BeatInput(1, () => addBeat(Beat(1), isInputtingRest)),
                              BeatInput(-1, () => addBeat(Beat(-1), isInputtingRest)),

                            ],
                          )

                        ],



                      ),


                      Column(
                        children: <Widget>[

                          FlatButton(
                            child: Icon(Icons.map), // TODO: change into "rest & quarter"
                            onPressed: () => isInputtingRest = isInputtingRest ? false : true,
                          ),

                          Divider(),

                          FlatButton(
                            child: Icon(Icons.backspace),
                            onPressed: () => deleteBeat()
                          )


                        ],
                      )


                    ],
                  )


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

    // initialize beats and displays
    initBeats();
    initBeatDisplays();
    isInputtingRest = false;

    // initialize midi
    loadSound('assets/sounds/Steinway+Grand+Piano+ER3A.sf2');

  }

  // setting functions
  void setTempoDuration() {
    tempoDuration = Duration(milliseconds: (Constants.MINUTE_IN_MILLISECONDS/tempo).floor());
  }
  void setTempo(int toSet) {
    Navigator.pop(context);
    setState(() {
      tempo = toSet;
    });
    setTempoDuration();
    setBeatsDurations();
  }
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
  void setTimeSignature(int topToSet, int botToSet) {

    Navigator.pop(context);

    setState(() {
      topTimeSignature = topToSet;
      bottomTimeSignature = botToSet;
    });

    resetBeatDisplays();

  }
  void loadSound(String asset) async {
    FlutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    FlutterMidi.prepare(sf2: byte);
  }

  void initBeats() {
    beats = [];
  }
  void addBeat(Beat toAdd, bool isNote) {
    // TODO: add dotted and rest functions
    // check if able to add onto bar based on time signature
    int bottomValue = 0;
    switch (bottomTimeSignature) {
      case 8: bottomValue = 2; break;
      case 4: bottomValue = 4; break;
      case 2: bottomValue = 8; break;
    }
    int timeSignatureSum = topTimeSignature * bottomValue;
    print(timeSignatureSum);
    int beatsSum = 0;
    beats.forEach((beat) => beatsSum += beat.value);

    if (beatsSum + toAdd.value > timeSignatureSum) {
      final errorBar = SnackBar(
        content: Text('Adding would be over time signature!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
    else {
      if (isNote) { toAdd.setSound(60); }
      else { toAdd.setSound(-1); }

      toAdd.setBeatDuration(bottomTimeSignature, tempoDuration);

      setState(() {
        beats.add(toAdd);
        beatDisplays = List.from(beatDisplays)..add(BeatDisplay(toAdd.value));
      });
    }


  }
  void deleteBeat() {
    if (beatDisplays.length != 0) {
      setState(() {
        beats.removeLast();
        beatDisplays = List.from(beatDisplays)..removeLast();
      });
    }
    else {
      final errorBar = SnackBar(
        content: Text('Nothing to delete!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
  }
  void setBeatsDurations() {
    beats.forEach((beat) => beat.setBeatDuration(bottomTimeSignature, tempoDuration));
  }


  // widget functions
  void initBeatDisplays() {
    beatDisplays = [];
    beats.forEach((beat) => beatDisplays.add(BeatDisplay(beat.value)));
  }
  void resetBeatDisplays() {
    setState(() {
      beats = List.from(beats)..clear();
      beatDisplays = List.from(beatDisplays)..clear();
    });
  }
  void disableBeatDisplays() {
    print('disable');
    setState(() {
      beatDisplays.forEach((display) => display.setIsOn(false));
    });
  }
  bool checkBar() {
    // for togglePlayer() use
    // check if the current num of beats is equal to the bar value
    int timeSignatureSum = topTimeSignature * bottomTimeSignature;
    int beatsSum = 0;
    beats.forEach((beat) => beatsSum += beat.value);
    print(beatsSum);
    return beatsSum == timeSignatureSum;
  }
  void showTempoDialog() {
    int toSet = tempo;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Set Tempo'),

            content: NumberPicker.integer(
              initialValue: tempo,
              minValue: 30,
              maxValue: 180,
              onChanged: (value) => toSet = value,
            ),

            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),

              FlatButton(
                child: Text('Ok'),
                onPressed: () => setTempo(toSet),
              )
            ],

          );
        }
    );
  }
  void showTimeSignatureDialog() {
    int topToSet = topTimeSignature;
    int botToSet = bottomTimeSignature;

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Set Time Signature'),
            content: Row(
              children: <Widget>[

                NumberPicker.integer(
                  initialValue: topTimeSignature,
                  minValue: 2,
                  maxValue: 12,
                  onChanged: (value) => topToSet = value,
                ),

                Text('/'),

                NumberPicker.integer(
                  initialValue: bottomTimeSignature,
                  minValue: 2,
                  maxValue: 8,
                  onChanged: (value) => botToSet = value,
                )


              ],
            ),

            actions: <Widget>[

              FlatButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),

              FlatButton(
                child: Text('Ok'),
                onPressed: () => setTimeSignature(topToSet, botToSet),
              )


            ],

          );
        }
    );

  }

  // rhythm player functions
  void togglePlayer() {
    print('toggle');

    if (checkBar()) {
      setState(() {
        isMetronomePlaying = isMetronomePlaying ? false : true;
        currentBeat = 0;
      });

      if (isMetronomePlaying) { playPlayer(); }
      else { timer.cancel(); disableBeatDisplays(); }
    }
    else {
      final errorBar = SnackBar(
        content: Text('Cannot play incomplete bar!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }

  }
  void playPlayer() {
    print('playMetronome');
    disableBeatDisplays();
    
    Beat current = beats[currentBeat];

    // highlight current BeatDisplay
    setState(() {
      beatDisplays[currentBeat].setIsOn(true);
    });

    // play sound
    int midiSound = current.sound;
    if (midiSound != -1) {
      FlutterMidi.playMidiNote(midi: midiSound);
    }

    // add to current beat
    currentBeat++;
    if (currentBeat == beats.length) { currentBeat = 0; }
    timer = Timer(current.beatDuration, () => playPlayer());

  }
  

}