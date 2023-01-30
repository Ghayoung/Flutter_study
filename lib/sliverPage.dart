/*
스크롤 시 역동적인 앱바 만들기
main_animation_example에서 사용
 */

import 'package:flutter/material.dart';
import 'dart:math' as math;

class SliverPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SliverPage();
}

class _SliverPage extends State<SliverPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView( // 사용자 정의 스크롤 효과를 만드는 위젯
        slivers: <Widget>[ // slivers 인자로 위젯을 묶어 주어야 함
          SliverAppBar(
            // 앱바의 높이 설정
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Sliver Example'),
              background: Image.asset('repo/images/sunny.png'),
            ),
            backgroundColor: Colors.deepOrangeAccent,
            pinned: true,
          ),
          SliverPersistentHeader(
            delegate: _HeaderDelegate(
              minHeight: 50,
              maxHeight: 150,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'list 숫자',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              customCard('1'),
              customCard('2'),
              customCard('3'),
              customCard('4'),
            ])
          ),
          SliverPersistentHeader(
            delegate: _HeaderDelegate(
              minHeight: 50,
              maxHeight: 150,
              child: Container(
                color: Colors.blue,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '그리드 숫자',
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverGrid(
            delegate: SliverChildListDelegate([
              customCard('1'),
              customCard('2'),
              customCard('3'),
              customCard('4'),
            ]),
            gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2)
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Container(
                child: customCard('list count : $index'),
              );
            }, childCount: 10),
          )
        ],
      ),
    );
  }

  Widget customCard(String text) {
    return Card(
      child: Container(
        height: 120,
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 40),
          )
        )
      )
    );
  }
}

class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _HeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) { // 머리말을 만들 때 사용할 위젯 배치
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => math.max(maxHeight, minHeight); // 해당 위젯의 최대 높이 설정

  @override
  double get minExtent => minHeight; // 가장 작은 높이 설정

  @override
  bool shouldRebuild(_HeaderDelegate oldDelegate) { // 위젯을 계속 그릴지 여부
    return maxHeight != oldDelegate.maxHeight ||
    minHeight != oldDelegate.minHeight ||
    child != oldDelegate.child;
  }
}