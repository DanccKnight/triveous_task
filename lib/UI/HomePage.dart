import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:triveous_task/News.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:triveous_task/UI/Details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String url =
      "http://newsapi.org/v2/everything?language=en&apiKey=${DotEnv().env['API_KEY']}&domains=";
  Future<News> news;
  List<Color> colors = [
    Colors.blueGrey[100],
    Colors.pink[50],
    Colors.teal[50],
    Colors.white.withOpacity(0.8)
  ];

  Future<News> getNews(String source) async {
    var response = await http.get(url + source);
    if (response.statusCode == 200) {
      var decodedJson = json.decode(response.body);
      return News.fromJson(decodedJson);
    } else
      throw Exception("Failed to fetch news articles");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
          appBar: AppBar(
            title: Text("News App"),
            bottom: TabBar(
                unselectedLabelColor: Colors.white,
                isScrollable: true,
                tabs: [
                  Tab(text: "Boston Globe"),
                  Tab(text: "The Hindu"),
                  Tab(text: "CNN"),
                  Tab(text: "MoneyControl"),
                  Tab(text: "Fortune"),
                  Tab(text: "Fox News"),
                  Tab(text: "TechCrunch"),
                  Tab(text: "The Next Web"),
                ]),
          ),
          body: TabBarView(children: [
            //remove wion,espn
            displayContent("bostonglobe.com"),
            displayContent("thehindu.com"),
            displayContent("cnn.com"),
            displayContent("moneycontrol.com"),
            displayContent("fortune.com"),
            displayContent("foxnews.com"),
            displayContent("techcrunch.com"),
            displayContent("thenextweb.com"),
          ])),
    );
  }

  Widget displayContent(String source) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          FutureBuilder(
            future: getNews(source),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 200),
                  child: CircularProgressIndicator(),
                ));
              } else if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.articles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                      link:
                                          snapshot.data.articles[index].url))),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side:
                                    BorderSide(color: Colors.black, width: 2)),
                            borderOnForeground: true,
                            color: colors[index % 4],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25, left: 25, bottom: 15),
                                  child: Text(
                                      "by ${snapshot.data.articles[index].author == null || snapshot.data.articles[index].author == "" ? 'Jeff Smith' : snapshot.data.articles[index].author}",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(snapshot.data
                                                .articles[index].urlToImage ==
                                            null
                                        ? "https://i.imgur.com/XOvOKx0.jpg"
                                        : snapshot
                                            .data.articles[index].urlToImage),
                                  ),
                                ),
                                SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, bottom: 30, right: 25),
                                  child: Wrap(
                                    children: [
                                      Text(snapshot.data.articles[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        child: Text(
                                            snapshot.data.articles[index]
                                                .description,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            maxLines: 8,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      Text(
                                          snapshot
                                              .data.articles[index].publishedAt,
                                          style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("Getting the latest news articles for you..."),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
