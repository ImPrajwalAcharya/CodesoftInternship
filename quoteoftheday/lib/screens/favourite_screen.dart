import 'package:flutter/material.dart';
import 'package:quoteoftheday/screens/home_screen.dart';
import 'package:quoteoftheday/storage/storage.dart';
import 'package:share/share.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  share() async {
    await Share.share("${quote["content"]} \n -- ${quote["author"]}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: Storage().getQuotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: const CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.data!.length == 0) {
              return Center(
                child: Text('No Favourite Quotes'),
              );
            }
            return ListView.builder(
                itemCount: (snapshot.data! as dynamic).length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.5,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Column(
                          children: [
                            Text(
                                "\"${(snapshot.data as dynamic)[index].content}\"",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold)),
                            Text(
                              "-- ${(snapshot.data as dynamic)[index].author} --",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w300),
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
                                  Storage().remove(
                                      (snapshot.data as dynamic)[index]);
                                  setState(() {});
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.blueGrey,
                                )),
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
                  );
                });
          },
        ),
      ),
    );
  }
}
