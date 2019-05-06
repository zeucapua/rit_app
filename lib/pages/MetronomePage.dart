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

  List<Beat> beats;
  Widget beatDisplayList;
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
                    Container(height: 100.0, child: beatDisplayList)

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

    // initialize beats
    setBeats();

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

    playButton = FlatButton(
      child: isMetronomePlaying ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      onPressed: () => toggleMetronome(),
    );


    // initialize beats and displays
    initBeatDisplays();

    // initialize midi
    loadSound('assets/sounds/Steinway+Grand+Piano+ER3A.sf2');

  }

  // setting functions
  void setTempoDuration() { tempoDuration = Duration(milliseconds: (Constants.MINUTE_IN_MILLISECONDS/tempo).floor()); }
  void setTempo() {}
  void setTimeSignature() {}
  void setBeats() {
    beats = List<Beat>();
    for (int x = 0; x < topTimeSignature; x++) {
      beats.add(Beat(bottomTimeSignature, -1));
    }
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
  void initBeatDisplays() {
    beatDisplayList = ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      itemCount: beats.length,
      itemBuilder: (context, index) {

        return BeatDisplay(beats[index]);

      },
    );
  }
  void disableBeatDisplays() {
    print('disable');
    setState(() {
      beats.forEach((beat) => beat.setIsOn(false));
    });
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
      beats[currentBeat].setIsOn(true);
    });

    // play sound
    if (beats[currentBeat].sound == -1) { SystemSound.play(SystemSoundType.click); }
    else { FlutterMidi.playMidiNote(midi: beats[currentBeat].sound); }

    // add to current beat
    currentBeat++;
    if (currentBeat == topTimeSignature) { currentBeat = 0; }
    timer = Timer(tempoDuration, () => playMetronome());


  }



}