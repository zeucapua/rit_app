import 'package:flutter/material.dart';
import 'dart:async'; import 'package:flutter/services.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_midi/flutter_midi.dart';

import 'package:rit_app/models/Beat.dart';
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
  bool isMetronomePlaying;

  List<Beat> beats;
  List<BeatDisplay> beatDisplays;


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        child: SafeArea(

          child: Center(

              child: Column(

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
                        height: 100,
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

                  // play button
                  FlatButton(
                    child: isMetronomePlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                    onPressed: () => togglePlayer(),
                  )


                ],
              )
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(onPressed: () => addBeat(Beat(4), true)),

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
  void addBeat(Beat toAdd, bool isNote) {

    // check if able to add onto bar based on time signature
    int timeSignatureSum = topTimeSignature * bottomTimeSignature;
    int beatsSum = 0;
    beats.forEach((beat) => beatsSum += beat.value);

    if (beatsSum + toAdd.value > timeSignatureSum) { print('Error too long'); }
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
    setState(() {
      beats.removeLast();
      beatDisplays = List.from(beatDisplays)..removeLast();
    });
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
    beats.forEach((beat) => beatDisplays.add(BeatDisplay(beat.value)));
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
    setState(() {
      isMetronomePlaying = isMetronomePlaying ? false : true;
      currentBeat = 0;
    });

    if (isMetronomePlaying) { playPlayer(); }
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
    if (currentBeat == topTimeSignature) { currentBeat = 0; }
    timer = Timer(current.beatDuration, () => playPlayer());

  }
  

}