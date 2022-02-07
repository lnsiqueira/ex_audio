import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

var _apikey = "your key";
AudioPlayer audioPlayer = AudioPlayer();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOICE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo Voice'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> submiVoice(
      String message, String voice, String languageCode) async {
    await playmalevoice(message, voice, languageCode);
  }

  Future<http.Response> texttospeech(
      String text, String voicetype, String languageCode) {
    var body = json.encode({
      "audioConfig": {
        "audioEncoding": "LINEAR16",
        "pitch": 0,
        "speakingRate": 1.0
      },
      "input": {"text": text},
      "voice": {"languageCode": languageCode, "name": voicetype}
    });

    var response;

    try {
      response = http.post(
          Uri.parse(
              "https://texttospeech.googleapis.com/v1beta1/text:synthesize?key=$_apikey"),
          headers: {"Content-type": "application/json"},
          body: body);
    } on Exception catch (exception) {
      throw Exception("Error on server");
    }

    return response;
  }

  playmalevoice(String message, String tipVoice, String languageCode) async {
    var response = await texttospeech(message, tipVoice, languageCode);

    var jsonData = jsonDecode(response.body);

    String audioBase64 = jsonData['audioContent'];

    Uint8List bytes = base64Decode(audioBase64);

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/the_voice.mp3');

    await file.writeAsBytes(bytes);

    int result = await audioPlayer.play(file.path);

    if (result == 1) {
      // success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: const Text(
                "Male voice - Portuguese",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Olá, tudo bem? A tecnologia cada vez mais forte  dia a dia",
                  "pt-BR-Standard-B",
                  "pt-BR"),
            ),
            TextButton(
              child: const Text(
                "Female voice - France",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Bonjour tout va bien? La technologie se renforce chaque jour  ",
                  "Wavenet-E",
                  "fr-FR"),
            ),
            TextButton(
              child: const Text(
                "Female voice - Italian",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Ciao a tutti bene? La tecnologia diventa ogni giorno più forte",
                  "Wavenet-B",
                  "it-IT"),
            ),
            TextButton(
              child: const Text(
                "Male voice - English",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Hi,  How are you?  Technology getting stronger every day ....",
                  "Standard-A",
                  "en-US"),
            ),
            TextButton(
              child: const Text(
                "Female voice - English (UK)",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Hi,  How are you?  Technology getting stronger every day ....",
                  "Wavenet-F",
                  "en-GB"),
            ),
            TextButton(
              child: const Text(
                "Female voice - German",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              onPressed: () => submiVoice(
                  "Hallo alles gut? Technologie wird jeden Tag stärker",
                  "Standard-A",
                  "de-DE"),
            ),
          ],
        ),
      ),
    );
  }
}
