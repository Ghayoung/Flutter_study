import 'package:flutter/material.dart';
import '../animalItem.dart';

class FirstApp extends StatelessWidget {
  final List<Animal>? list;

  // list를 매개변수로 입력받는 생성자
  FirstApp({Key? key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ListView.builder(
            itemBuilder: (context, position) { // context: 위젯의 위치 position: 아이템의 순번
              return GestureDetector( // 터치 이벤트
                  child: Card( // 리스트뷰의 아이템은 Card로 생성
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          list![position].imagePath!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.contain,
                        ),
                        Text(list![position].animalName!)
                      ],
                    ),
                  ),
                  onTap: () {
                    // 탭했을때 알림창 호출
                    AlertDialog dialog = AlertDialog(
                      content: Text(
                        '이 동물은 ${list![position].kind}입니다',
                        style: TextStyle(fontSize: 30.0),
                      ),
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);
                  });
            },
            itemCount: list!.length, // 아이템 개수만큼 스크롤하도록 제한
          ),
        ),
      ),
    );
  }
}
