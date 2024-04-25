import 'dart:math';
// import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart ';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


class SplashScreen extends StatelessWidget {
  final AudioCache _audioCache = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background_image.jpg',
            fit: BoxFit.fill,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/name.png',
                  width: 300,
                  height: 150,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    // Play sound when the button is clicked
                    _audioCache.play('button_click_sound.mp3');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LengthAndTriesScreen()),
                    );
                  },
                  child: Container(
                    width: 200,
                    height: 100,
                    child: Image.asset('assets/start_game_button.png'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}






class LengthAndTriesScreen extends StatefulWidget {
  @override
  _LengthAndTriesScreenState createState() => _LengthAndTriesScreenState();
}

class _LengthAndTriesScreenState extends State<LengthAndTriesScreen> {
  final AudioCache _audioCache = AudioCache();
  double wordLength = 5;
  int numberOfTries = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Length and Tries'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background_image.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Select Length of Words: ${wordLength.toInt()}',
                    style: TextStyle(color: Colors.green),
                  ),
                  Slider(
                    value: wordLength,
                    min: 3,
                    max: 7,
                    divisions: 5,
                    onChanged: (newValue) {
                      setState(() {
                        wordLength = newValue;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Select Number of Tries: $numberOfTries',
                    style: TextStyle(color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: numberOfTries.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (newValue) {
                      setState(() {
                        numberOfTries = newValue.toInt();
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      _audioCache.play('push.mp3');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WordPredictScreen(
                            wordLength: wordLength.toInt(),
                            numberOfTries: numberOfTries,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 150, // Adjust width here
                      height: 150, // Adjust height here
                      child: Image.asset('assets/go_button.png'), // Use your image asset here
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class WordPredictScreen extends StatefulWidget {
  final int wordLength;
  final int numberOfTries;

  WordPredictScreen({
    required this.wordLength,
    required this.numberOfTries,
  });

  @override
  _WordPredictScreenState createState() => _WordPredictScreenState();
}

class _WordPredictScreenState extends State<WordPredictScreen> {
  final AudioCache _audioCache = AudioCache();
  List<String> wordsList = [
    'apple',
    'banana',
    'orange',
    'kiwi',
    'peach',
    'strawberry',
    'watermelon',
    'pineapple',
    'mango',
    'pear',
    'blueberry',
    'cherry',
    'lemon',
    'coconut',
    'apricot',
    'papaya',
    'fig',
    'plum',
    'raspberry',
    'blackberry',
    'melon',
    'lime',
    'cranberry',
    'nectarine',
    'date',
    'lychee',
    'guava',
    'tangerine',
    'persimmon',
    // Add more default words here
  ];

  int score = 0;
  String selectedWord = '';
  String missingLetter = '';
  List<String> options = [];
  int remainingTries = 0;

  @override
  void initState() {
    super.initState();
    remainingTries = widget.numberOfTries;
    // Select a random word from the list initially
    selectRandomWord();
  }

  void selectRandomWord() {
    final random = Random();
    final filteredWords = wordsList.where((word) => word.length == widget.wordLength).toList();
    if (filteredWords.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Word Not Available',
              style: TextStyle(color: Colors.black), // Change text color here
            ),
            content: Text(
              'There are no words with selected length.',
              style: TextStyle(color: Colors.black), // Change text color here
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final randomIndex = random.nextInt(filteredWords.length);
      setState(() {
        selectedWord = filteredWords[randomIndex];
        missingLetter = selectedWord[random.nextInt(selectedWord.length)];
        options = generateOptions();
      });
    }
  }

  List<String> generateOptions() {
    List<String> allLetters = 'abcdefghijklmnopqrstuvwxyz'.split('');
    allLetters.remove(missingLetter);
    allLetters.shuffle();
    return [
      missingLetter.toUpperCase(),
      allLetters[0].toUpperCase(),
      allLetters[1].toUpperCase(),
    ]..shuffle();
  }

  void checkAnswer(String answer) {
    if (answer.toLowerCase() == missingLetter) {
      setState(() {
        score++;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Correct!',
              style: TextStyle(color: Colors.black), // Change text color here
            ),
            content: Text(
              'The missing letter is $missingLetter.',
              style: TextStyle(color: Colors.black), // Change text color here
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _audioCache.play('win.mp3');
                  Navigator.of(context).pop();
                  selectRandomWord();
                },
                child: Text('Next'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        remainingTries--;
      });
      if (remainingTries > 0) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(

              title: Text(

                'Incorrect!',
                style: TextStyle(color: Colors.black), // Change text color here
              ),
              content: Text(
                'Try again. Remaining tries: $remainingTries',
                style: TextStyle(color: Colors.black), // Change text color here
              ),
              actions: [
                TextButton(

                  onPressed: () {
                    _audioCache.play('again.mp3');
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Game Over',
                style: TextStyle(color: Colors.black), // Change text color here
              ),
              backgroundColor: Colors.white,
              content: Text(
                'Sorry, you lost. Your score: $score',
                style: TextStyle(color: Colors.black), // Change text color here
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    _audioCache.play('loss.mp3');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        setState(() {
          remainingTries = widget.numberOfTries;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Prediction Game'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/background_image.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 20, color: Colors.black), // Change text color here
                ),
                SizedBox(height: 20),
                Text(
                  'Remaining Tries: $remainingTries',
                  style: TextStyle(fontSize: 20, color: Colors.red), // Change text color here
                ),
                SizedBox(height: 20),
                Text(
                  'Guess the missing letter:',
                  style: TextStyle(fontSize: 20, color: Colors.black), // Change text color here
                ),
                SizedBox(height: 10),
                Text(
                  selectedWord.replaceAll(missingLetter, '_'),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black), // Change text color here
                ),
                SizedBox(height: 20),
                Column(
                  children: options.map((option) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: OutlinedButton(
                        onPressed: () {
                          checkAnswer(option);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.green),
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _audioCache.play('over.mp3');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            'Game Over',
                            style: TextStyle(color: Colors.red), // Change text color here
                          ),
                          content: Text(
                            'Your final score is: $score',
                            style: TextStyle(color: Colors.green), // Change text color here
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 150, // Adjust width here
                    height: 150, // Adjust height here
                    child: Image.asset('assets/finish_game_button.png'), // Use your image asset here
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

