import 'package:flutter/material.dart';
import 'dart:async'; import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:flutter_midi/flutter_midi.dart';

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
                      child: ListView(
                        shrinkWrap: true,
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        children: beatDisplays,
                      ),
                    )

                  ],
                ),

                // play button
                FlatButton(
                  child: isMetronomePlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
                  onPressed: () => toggleMetronome(),
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

    topTimeSignature = 6; bottomTimeSignature = 8;

    // initialize metronome settings
    currentBeat = 0;
    isMetronomePlaying = false;
    timer = Timer(tempoDuration, () => print('init'));

    // initialize widgets
    setMetronomeIcon();

    // initialize beats and displays
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

    //TODO: change beatdisplays
    Navigator.pop(context);

    setState(() {
      topTimeSignature = topToSet;
      bottomTimeSignature = botToSet;
      setBeatDisplays();
    });

  }
  void loadSound(String asset) async {
    FlutterMidi.unmute();
    ByteData byte = await rootBundle.load(asset);
    FlutterMidi.prepare(sf2: byte);
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

  // TODO: WORK ON BEATDISPLAYS
  void initBeatDisplays() {
    beatDisplays = List<BeatDisplay>();
    for (int x = 0; x < topTimeSignature; x++) {
      beatDisplays.add(BeatDisplay(bottomTimeSignature));
    }
  }
  void setBeatDisplays() {
    // TODO:
    setState(() {
      beatDisplays.clear();
      for (int x = 0; x < topTimeSignature; x++) {
        beatDisplays.add(BeatDisplay(bottomTimeSignature));
      }
    });
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

  // metronome functions
  void toggleMetronome() {
    print('toggle');
    setState(() {
      isMetronomePlaying = isMetronomePlaying ? false : true;
      currentBeat = 0;
    });

    if (isMetronomePlaying) { playMetronome(); }
    else { timer.cancel(); disableBeatDisplays(); }
  }
  void playMetronome() {
    print('playMetronome');
    disableBeatDisplays();

    // TODO: highlight current display using list
    setState(() {
      beatDisplays[currentBeat].setIsOn(true);
    });

    // play sound
    SystemSound.play(SystemSoundType.click);

    // add to current beat
    currentBeat++;
    if (currentBeat == topTimeSignature) { currentBeat = 0; }
    timer = Timer(tempoDuration, () => playMetronome());


  }



}