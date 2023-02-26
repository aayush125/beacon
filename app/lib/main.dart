import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MyApp());
  player.setSourceAsset("sounds/geet.mp3");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A very random idea:'),
          Text(appState.current.asLowerCase),

          ElevatedButton(
            onPressed: () {
              playSound();
              print('music played!');
            },
            child: Text('Music'),
          ),
        ],
      ),
    );
  }
}

final player = AudioPlayer();

// Function to play sound
void playSound() async {
  await player.resume();
}
