import 'package:flutter/material.dart';
import 'package:rit_app/pages/MetronomePage.dart';
import 'package:rit_app/pages/RhythmPlayerPage.dart';

void main() => runApp(RitApp());

class RitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rit.',

      home: MainPage()
    );
  }
}


// Displays main menu for users to pick from, as well as a settings button
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(

        child: SafeArea(

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Text('rit.', style: ThemeData.light().primaryTextTheme.title,),

                Spacer(),

                FlatButton(
                  child: Text('Metronome'),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (builder) => MetronomePage())
                  ), // open MetronomePage
                ),

                FlatButton(
                  child: Text('Rhythm Player'),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (builder) => RhythmPlayerPage())
                  ), // open RhythmPlayerPage
                )

              ],
            ),
          ),



        ),


      ),

    );
  }
}