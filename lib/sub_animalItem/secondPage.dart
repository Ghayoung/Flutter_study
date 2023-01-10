import 'package:flutter/material.dart';
import '../animalItem.dart';

class SecondApp extends StatefulWidget {
  @override
  // _SecondApp()을 반환하는 createState() 함수를 호출한다
  State<StatefulWidget> createState() => _SecondApp();
  List<Animal>? list;

  // list를 매개변수로 입력받는 생성자
  SecondApp({Key? key, @required this.list}) : super(key: key);
}

class _SecondApp extends State<SecondApp> {
  final nameController = TextEditingController();
  int? _radioValue = 0;
  bool? flyExist = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 여백 균일하게 배치
            children: <Widget>[
              TextField( // 동물 이름 입력
                controller: nameController,
                keyboardType: TextInputType.text,
                maxLines: 1,
              ),
              Row( // 각 위젯이 가로로 배치되도록 Row에 작성
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Radio(
                        value: 0, // 인덱스값
                        groupValue: _radioValue, // 그룹화
                        onChanged: _radioChange), // 이벤트 처리
                    Text('양서류'),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _radioChange),
                    Text('파충류'),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: _radioChange),
                    Text('포유류'),
                  ]),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('날 수 있나요?'),
                    Checkbox(
                        value: flyExist,
                        onChanged: (bool? check) {
                          setState(() {
                            flyExist = check;
                          });
                        })
                  ]),
              Container(
                  height: 100,
                  // scrollDirection을 이용해 가로 리스트뷰 구현
                  child: ListView(scrollDirection: Axis.horizontal, children: <
                      Widget>[
                    GestureDetector(
                        child: Image.asset('repo/images/cow.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/cow.png';
                        }),
                    GestureDetector(
                        child: Image.asset('repo/images/pig.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/pig.png';
                        }),
                    GestureDetector(
                        child: Image.asset('repo/images/bee.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/bee.png';
                        }),
                    GestureDetector(
                        child: Image.asset('repo/images/cat.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/cat.png';
                        }),
                    GestureDetector(
                        child: Image.asset('repo/images/fox.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/fox.png';
                        }),
                    GestureDetector(
                        child: Image.asset('repo/images/monkey.png', width: 80),
                        onTap: () {
                          _imagePath = 'repo/images/monkey.png';
                        }),
                  ])),
              ElevatedButton(
                  child: Text('동물 추가하기'),
                  onPressed: () {
                    var animal = Animal(
                        animalName: nameController.value.text,
                        kind: getKind(_radioValue),
                        imagePath: _imagePath,
                        flyExist: flyExist);
                    AlertDialog dialog = AlertDialog(
                      title: Text('동물 추가하기'),
                      content: Text(
                        '이 동물은 ${animal.animalName} 입니다. '
                        '또 동물의 종류는 ${animal.kind}입니다.\n이 동물을 추가하시겠습니까?',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            widget.list?.add(animal); // 리스트에 동물 추가
                            Navigator.of(context).pop(); // 알림창 꺼짐
                          },
                          child: Text('예'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('아니요'),
                        )
                      ],
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _radioChange(int? value) {
    setState(() {
      _radioValue = value;
    });
  }

  getKind(int? radioValue) {
    switch (radioValue) {
      case 0:
        return '양서류';
      case 1:
        return '파충류';
      case 2:
        return '포유류';
    }
  }
}