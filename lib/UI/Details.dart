import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DetailsPage extends StatefulWidget {

  String link;

  DetailsPage({Key key, this.link}) : super(key:key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Details")),
      body: WebView(
        onWebViewCreated: (WebViewController wbcontroller){
          _controller = wbcontroller;
        },
        initialUrl: widget.link,
      ),
    );
  }
}
