import 'package:biznews/api/NewsApi.dart';
import 'package:biznews/model/model.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  NewsApi newsApi = NewsApi();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Latest News"),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Articles>?>(
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("No news available");
            }
            if (snapshot.hasError) {
              return Text(snapshot.data.toString());
            }
            return ListView.builder(itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      snapshot.data?[index].urlToImage != null
                          ? snapshot.data![index].urlToImage!
                          : " "),
                ),
                title: Text(snapshot.data?[index].title != null
                    ? snapshot.data![index].title!
                    : " "),
                subtitle: Text(snapshot.data?[index].author != null
                    ? snapshot.data![index].author!
                    : " "),
                trailing: IconButton(
                  icon: Icon(Icons.launch),
                  onPressed: () async {
                    await canLaunch(snapshot.data![index].url!)
                        ? launch(snapshot.data![index].url!)
                        : throw "Can't launch ${snapshot.data![index].url!}";
                  },
                ),
              );
            });
          },
          future: newsApi.getNews(),
        ),
      ),
    );
  }
}
