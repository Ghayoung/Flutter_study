/*
메모장 앱 만들기 MemoPage
 */

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'memo.dart';
import 'memoAdd.dart';

class MemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = "https://example-5d077-default-rtdb.firebaseio.com/";
  List<Memo> memos = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('memo');

    reference!.onChildAdded.listen((event) { // 데이터베이스에 데이터가 추가되면 자동 실행
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메모 앱'),
      ),
      body: Container(
        child: Center(
          child: memos.length == 0
              ? CircularProgressIndicator()
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Card(
                      child: GridTile(
                        header: Text(memos[index].title),
                        footer: Text(memos[index].createTime.substring(0, 10)),
                        child: Container(
                          padding: EdgeInsets.only(top: 20, bottom: 20),
                          child: SizedBox(
                            child: GestureDetector(
                              onTap: () {

                              },
                              onLongPress: () {

                              },
                              child: Text(memos[index].content),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
            itemCount: memos.length,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MemoAddPage(reference!))
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}