import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quoteoftheday/api/fetch.dart';
import 'package:share/share.dart';

import '../models/quote.dart';
import '../storage/storage.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var quote;
bool isloading = false;
bool favourate = false;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchquote();
  }

  fetchquote() async {
    setState(() {
      isloading = true;
    });
    quote = await fetchRandomQuote();
    print(quote);

    setState(() {
      favourate = false;
      isloading = false;
    });
  }

  share() async {
    await Share.share("${quote["content"]} \n -- ${quote["author"]}");
  }

  addtofavourate() async {
    var storage = Storage();
    // storage.open();
    await storage
        .addQuote(Quote(content: quote["content"], author: quote["author"]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: quote == null
          ? Text('No quote')
          : SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Quote of the day',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            isloading
                                ? Center(
                                    child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.blueGrey,
                                  ))
                                : Column(
                                    children: [
                                      Text("\"${quote["content"]}\"",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                        "-- ${quote["author"]} --",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ],
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (favourate == false) {
                                      addtofavourate();
                                    }

                                    setState(() {
                                      favourate = true;
                                    });
                                  },
                                  icon: favourate
                                      ? Icon(Icons.favorite,color: Colors.blueGrey)
                                      : Icon(Icons.favorite_border, color: Colors.blueGrey),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    share();
                                  },
                                  icon: Icon(Icons.share),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side:
                                          BorderSide(color: Colors.blueGrey))),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueGrey),
                        ),
                        onPressed: () {
                          setState(() {
                            favourate = false;
                          });

                          fetchquote();
                        },
                        child:
                            //  Text('Next',
                            //     style:
                            //         TextStyle(fontSize: 20, color: Colors.white))
                            Icon(Icons.repeat, color: Colors.white, size: 30))
                  ],
                ),
              ),
            ),
    );
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Daily Quote',
      _getRandomQuote(),
      _nextInstanceOf2AM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'quote_channel',
          'Daily Quote',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  String _getRandomQuote() {
    // Replace this with your list of quotes
    List<String> quotes = [
      "The only way to do great work is to love what you do. - Steve Jobs",
      "Innovation distinguishes between a leader and a follower. - Steve Jobs",
      "Your time is limited, don't waste it living someone else's life. - Steve Jobs",
      // Add more quotes here...
    ];
    final Random random = Random();
    return quotes[random.nextInt(quotes.length)];
  }

  tz.TZDateTime _nextInstanceOf2AM() {
    final tz.TZDateTime now =
        tz.TZDateTime.now(tz.getLocation('Asia/Kathmandu'));
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.getLocation('Asia/Kathmandu'),
        now.year,
        now.month,
        now.day,
        11,
        25); // 2:15 AM in Nepal timezone
    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
