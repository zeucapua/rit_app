import 'package:flutter/material.dart';
import 'dart:async'; import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'package:rit_app/models/Beat.dart';
import 'package:rit_app/models/BeatInput.dart';
import 'package:rit_app/models/BeatDisplay.dart';
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
  bool isPlayerOn;
  bool isInputtingRests;

  List<Beat> beats;
  List<BeatDisplay> beatDisplays;
  List<BeatInput> topBeatInputs;
  List<BeatInput> bottomBeatInputs;

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


                Column(

                  children: <Widget>[

                    // play area
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


                   Row(
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
                        ),

                      ],
                    ),

                    // play button
                    FlatButton(
                      child: isPlayerOn ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                      onPressed: () => togglePlayer(),
                    ),

                    // input area
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[

                        // BeatInputs (topBeatInputs & bottomBeatInputs)
                        Column(
                          children: <Widget>[

                            Row(
                              children: topBeatInputs,
                            ),

                            Row(
                              children: bottomBeatInputs,
                            )

                          ],
                        ),

                        // function buttons
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(child: Icon(Constants.quarterRest), onPressed: () => toggleInputtingRests(),),
                            FlatButton(child: Icon(Icons.backspace), onPressed: () => deleteLastBeat(),)
                          ],
                        )


                      ],
                    )



                  ],
                ),




              ],
            )
          ),
        ),
      ),

      //floatingActionButton: FloatingActionButton(onPressed: () => addBeat(Beat(4), true)),

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
    isPlayerOn = false;
    timer = Timer(tempoDuration, () => print('init'));

    // initialize widgets
    setMetronomeIcon();

    // initialize inputs
    isInputtingRests = false;
    topBeatInputs = [
      BeatInput(16, isInputtingRests, () => addBeat(Beat(16, isInputtingRests))),
      BeatInput(8, isInputtingRests, () => addBeat(Beat(8, isInputtingRests))),
      BeatInput(4, isInputtingRests, () => addBeat(Beat(4, isInputtingRests))),
    ];
    bottomBeatInputs = [
      BeatInput(2, isInputtingRests, () => addBeat(Beat(2, isInputtingRests))),
      BeatInput(1, isInputtingRests, () => addBeat(Beat(1, isInputtingRests))),
      BeatInput(-1, isInputtingRests, () => addBeat(Beat(-1, isInputtingRests))),
    ];

    // initialize beats and displays
    initBeats();
    initBeatDisplays();

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
  }
  void setTimeSignature(int topToSet, int botToSet) {

    Navigator.pop(context);

    setState(() {
      topTimeSignature = topToSet;
      bottomTimeSignature = botToSet;
      resetBeatDisplays();
    });

  }
  void loadSound(String asset) async {
    FlutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    FlutterMidi.prepare(sf2: byte);
  }

  void initBeats() {
    beats = [];
  }
  void addBeat(Beat toAdd) {

    // check if able to add onto bar based on time signature
    int timeSignatureSum = topTimeSignature * bottomTimeSignature;
    int beatsSum = 0;
    beats.forEach((beat) => beatsSum += beat.value);

    bool isAddingDotted = false;

    // changes the last beat in the current 'beats' list to a dotted equivalent
    if (toAdd.value == -1) {
      int lastBeatValue = beats.last != null ? beats.last.value : -1;
      int dottedToAdd = 0;
      switch (lastBeatValue) {
        case 16: dottedToAdd = 24; break;
        case 8: dottedToAdd = 12; break;
        case 4: dottedToAdd = 6; break;
        case 2: dottedToAdd = 3; break;
        case 1: dottedToAdd = -1; break;
        default: dottedToAdd = -1; break;
      }

      toAdd.setValue(dottedToAdd);
      isAddingDotted = true;
    }

    if (toAdd.value == -1) {
      final errorBar = SnackBar(
        content: Text('Error: cannot add a dotted note!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
    else if (beatsSum + toAdd.value > timeSignatureSum) {
      final errorBar = SnackBar(
        content: Text('Adding would be over time signature!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
    else {

      toAdd.setBeatDuration(bottomTimeSignature, tempoDuration);

      if (isAddingDotted) {
        setState(() {
          deleteLastBeat();
        });
      }
      setState(() {
        beats.add(toAdd);
        beatDisplays = List.from(beatDisplays)..add(BeatDisplay(beat: toAdd, key: UniqueKey()));
        beats.forEach((beat) => beat.setBeatDuration(bottomTimeSignature, tempoDuration));
      });

    }



  }
  void deleteLastBeat() {
    setState(() {
      beats.removeLast();
      beatDisplays = List.from(beatDisplays)..removeLast();
    });
  }
  void toggleInputtingRests() {
    isInputtingRests = isInputtingRests ? false : true;
    topBeatInputs.forEach((input) => input.setIsInputtingRests(isInputtingRests));
    bottomBeatInputs.forEach((input) => input.setIsInputtingRests(isInputtingRests));
  }

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
    beatDisplays = [];
  }
  void resetBeatDisplays() {
    initBeats();
    initBeatDisplays();
  }
  void disableBeatDisplays() {
    print('disable');
    setState(() {
      beatDisplays.forEach((display) => display.setIsOn(false));
    });
  }

  void showTempoDialog() {
    if (isPlayerOn) {
      final errorBar = SnackBar(
        content: Text('Cannot change tempo while Rhythm Player is on!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
    else {
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
  }
  void showTimeSignatureDialog() {
    if (isPlayerOn) {
      final errorBar = SnackBar(
        content: Text('Cannot change time signatures while Rhythm Player is on!'),
        action: SnackBarAction(label: 'Okay', onPressed: () => {}),
      );
      _scaffoldKey.currentState.showSnackBar(errorBar);
    }
    else {
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


  }

  // rhythm player functions
  void togglePlayer() {
    print('toggle');
    setState(() {
      isPlayerOn = isPlayerOn ? false : true;
      currentBeat = 0;
    });

    if (isPlayerOn) { playPlayer(); }
    else { timer.cancel(); disableBeatDisplays(); }
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