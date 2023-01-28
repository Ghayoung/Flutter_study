/*
그래프 애니메이션 main
 */

import 'package:flutter/material.dart';
import 'people.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AnimationApp(),
    );
  }
}

class AnimationApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AnimationApp();
}

class _AnimationApp extends State<AnimationApp> {
  List<People> peoples = new List.empty(growable: true);
  Color weightColor = Colors.blue;
  int current = 0;

  @override
  void initState() {
    peoples.add(People('스미스', 180, 92));
    peoples.add(People('메리', 162, 55));
    peoples.add(People('존', 177, 75));
    peoples.add(People('바트', 130, 40));
    peoples.add(People('콘', 194, 140));
    peoples.add(People('디디', 100, 80));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Animation Example'),
        ),
        body: Container(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                      width: 100, child: Text('이름: ${peoples[current].name}')),
                  AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.bounceIn,
                    color: weightColor,
                    width: 50,
                    height: peoples[current].height,
                    child: Text(
                      '키 ${peoples[current].height}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 2), // 2초 동안 애니메이션 재생
                    curve: Curves.easeInCubic,
                    color: Colors.blue,
                    width: 50,
                    height: peoples[current].weight,
                    child: Text(
                      '몸무게 ${peoples[current].weight}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 2),
                    curve: Curves.linear,
                    color: Colors.pinkAccent,
                    width: 50,
                    height: peoples[current].bmi,
                    child: Text(
                      'bmi ${peoples[current].bmi.toString().substring(0, 2)}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton( // 버튼을 누르면 current 값이 바뀌면서 그래프의 높이 변경
              onPressed: () {
                setState(() {
                  if (current < peoples.length - 1) {
                    current++;
                  }
                  _changeWeightColor(peoples[current].weight);
                });
              },
              child: Text('다음'),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (current > 0) {
                      current--;
                    }
                    _changeWeightColor(peoples[current].weight);
                  });
                },
                child: Text('이전'))
          ],
        ))));
  }

  void _changeWeightColor(double weight) {
    if (weight < 40) {
      weightColor = Colors.blueAccent;
    } else if (weight < 60) {
      weightColor = Colors.indigo;
    } else if (weight < 80) {
      weightColor = Colors.orange;
    } else {
      weightColor = Colors.red;
    }
  }
}
