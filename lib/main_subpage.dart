import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubPage Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // 처음 앱을 시작했을 때 보여 줄 경로
      routes: {'/': (context) => FirstPage(),
      '/second': (context) => SecondPage()},
      /*
        <String: Widget> 형태로 경로 선언
        String에 경로로 사용할 문자열 입력
        Widget에는 해당 경로가 가리키는 위젯 지정
      */
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sub Page Main'),
        ),
        body: Container(
          child: Center(
            child: Text('첫 번째 페이지'),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          /*
            Navigator는 stack을 이용해 페이지를 관리할 때 사용하는 클래스
            of(context) 함수는 현재 페이지를 나타내고
            push() 함수는 스택에 페이지를 쌓는 역할을 한다.
          */
          onPressed: () {
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SecondPage()));
            Navigator.of(context).pushNamed('/second');
          },
          child: Icon(Icons.add),
        ));
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // 지금 페이지를 종료
            },
            child: Text('돌아가기'),
          ),
        ),
      ),
    );
  }
}
