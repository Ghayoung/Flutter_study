/*
Cupertino 위젯을 이용해 iOS 스타일로 앱 개발
첫 번째 동물 리스트 탭 구현
*/

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../animalItem.dart';

class CupertinoFirstPage extends StatelessWidget {
  final List<Animal> animalList;
  const CupertinoFirstPage({Key? key, required this.animalList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('동물 리스트'),
      ),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(5),
            height: 100,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      animalList[index].imagePath!,
                      fit: BoxFit.contain,
                      width: 80,
                      height: 80,
                    ),
                    Text(animalList[index].animalName!)
                  ],
                ),
                // Cupertino에는 Card가 없으므로 Container에 높이를 정해서 위젯을 배치한다.
                Container(
                  height: 2,
                  color: CupertinoColors.black,
                )
              ],
            ),
          );
        },
        itemCount: animalList.length, // 없으면 에러
      )
    );
  }
}