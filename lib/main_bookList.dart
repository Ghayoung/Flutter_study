/*
카카오 API로 책 정보 받아오기 main
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // http 패키지 불러오기

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HttpApp(),
    );
  }
}

class HttpApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Http Example'),
      ),
      body: Container(
        child: Center(
          child: Text('$result'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { // 비동기 처리
          var url = 'http://www.google.com';
          var response = await http.get(Uri.parse(url));
          setState(() {
            result = response.body;
          });
        },
        child: Icon(Icons.file_download),
      ),
    );
  }
}
