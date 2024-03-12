import 'package:flutter_tts/flutter_tts.dart';

void playquote(String text) async {
  FlutterTts flutterTts = FlutterTts();
  await flutterTts.setLanguage('hi-IN');
  await flutterTts.setPitch(0.9);
  // print(await flutterTts.getDefaultVoice);
  await flutterTts.setSpeechRate(0.6);
  await flutterTts.setVolume(1);
  await flutterTts.speak(text);
}
