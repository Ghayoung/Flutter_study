/*
할 일 기록 앱 만들기
 */

import 'package:flutter/material.dart';

class SubDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubDetail();
}

class _SubDetail extends State<SubDetail> {
  List<String> todoList = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('To-do list'),
        ),
        body: ListView.builder(
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                // 탭, 더블탭, 롱탭 등 다양한 터치 이벤트 처리
                child: Text(
                  todoList[index],
                  style: TextStyle(fontSize: 30),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('/third', arguments: todoList[index]);
                },
              ),
            );
          },
          itemCount: todoList.length,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNavigation(context);
          },
          child: Icon(Icons.add),
        ));
  }

  void _addNavigation(BuildContext context) async {
    final result = await Navigator.of(context).pushNamed('/second');
    setState(() {
      todoList.add(result as String);
    });
  }
}
