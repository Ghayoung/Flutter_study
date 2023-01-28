import 'package:flutter/material.dart';
import 'dart:math';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> with SingleTickerProviderStateMixin {
  AnimationController? _animationController; // 프레임마다 새로운 값을 생성하는 애니메이션 클래스
  Animation? _rotateAnimation;
  Animation? _scaleAnimation;
  Animation? _transAnimation;

  @override
  void initState() {
    super.initState();
    // duration: 애니메이션 재생 시간 vsync: 애니메이션을 표현할 대상
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    // 0.0~1.0 이외의 범위나 데이터 유형이 필요할 경우 Tween 사용
    _rotateAnimation = Tween<double>(begin: 0, end: pi * 10).animate(_animationController!);
    _scaleAnimation = Tween<double>(begin: 1, end: 0).animate(_animationController!);
    _transAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(200, 200)).animate(_animationController!);
  }

  @override
  void dispose() { // 화면이 종료될 때 호출
    _animationController!.dispose(); // 애니메이션도 종료해야 오류가 나지 않음
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Animation Example2'),),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedBuilder(
                animation: _rotateAnimation!,
                builder: (context, widget) {
                  return Transform.translate( // 위젯의 방향
                    offset: _transAnimation!.value,
                    child: Transform.rotate( // 회전
                      angle: _rotateAnimation!.value,
                      child: Transform.scale( // 크기
                        scale: _scaleAnimation!.value,
                        child: widget,
                      )
                    ),
                  );
                },
                child: Hero(
                  tag: 'detail',
                  child: Icon(
                    Icons.cake,
                    size: 300
                  )
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _animationController!.forward();
                },
                child: Text('로테이션 시작하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}