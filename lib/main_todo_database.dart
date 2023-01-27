/*
할 일 기록하기 앱 main
 */

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'todo.dart';
import 'addTodo.dart';
import 'clearList.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => DatabaseApp(database),
        '/add': (context) => AddTodoApp(database),
        '/clear': (context) => ClearListApp(database)
      },
    );
  }

  // 데이터베이스 생성
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "title TEXT, content TEXT, active INTEGER)",
        );
      },
      version: 1,
    );
  }
}

class DatabaseApp extends StatefulWidget {
  final Future<Database> db;

  DatabaseApp(this.db);

  @override
  State<StatefulWidget> createState() => _DatabaseApp();
}

class _DatabaseApp extends State<DatabaseApp> {
  Future<List<Todo>>? todoList;

  @override
  void initState() {
    super.initState();
    todoList = getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('To-do list'),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed('/clear');
                  setState(() {
                    todoList = getTodos();
                  });
                },
                child: Text(
                  '완료한 일',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Container(
          child: Center(
            child: FutureBuilder(
              // 서버에서 데이터를 받거나 파일에 데이터를 가져올 때 사용
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  // 데이터를 가져오는 동안 표시할 위젯
                  case ConnectionState.none:
                    return CircularProgressIndicator();
                  case ConnectionState.waiting:
                    return CircularProgressIndicator();
                  case ConnectionState.active:
                    return CircularProgressIndicator();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          Todo todo = (snapshot.data as List<Todo>)[index];
                          return ListTile(
                            title: Text(
                              todo.title!,
                              style: TextStyle(fontSize: 20),
                            ),
                            subtitle: Container(
                              child: Column(
                                children: <Widget>[
                                  Text(todo.content!),
                                  Text(
                                      '완료 여부: ${todo.active == 1 ? 'true' : 'false'}'),
                                  Container(
                                    height: 1,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              TextEditingController controller =
                                  new TextEditingController(text: todo.content);

                              Todo result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${todo.id} : ${todo.title}'),
                                      content: TextField(
                                        controller: controller,
                                        keyboardType: TextInputType.text,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                todo.active == 1
                                                    ? todo.active = 0
                                                    : todo.active = 1;
                                                todo.content =
                                                    controller.value.text;
                                              });
                                              Navigator.of(context).pop(todo);
                                            },
                                            child: Text('예')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(todo);
                                            },
                                            child: Text('아니요')),
                                      ],
                                    );
                                  });
                              _updateTodo(result);
                            },
                            onLongPress: () async {
                              // 길게 터치할 때 발생 이벤트
                              Todo result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('${todo.id} : ${todo.title}'),
                                      content:
                                          Text('${todo.content}를 삭제하시겠습니까?'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(todo);
                                            },
                                            child: Text('예')),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('아니요')),
                                      ],
                                    );
                                  });
                              _deleteTodo(result);
                            },
                          );
                        },
                        itemCount: (snapshot.data as List<Todo>).length,
                      );
                    } else {
                      return Text('No data');
                    }
                }
                return CircularProgressIndicator();
              },
              future: todoList,
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () async {
                final todo = await Navigator.of(context).pushNamed('/add');
                if (todo != null) {
                  _insertTodo(todo as Todo);
                }
              },
              heroTag: null,
              child: Icon(Icons.add),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () async {
                _allUpdate();
              },
              heroTag: null,
              child: Icon(Icons.update),
            ),
          ],
        ));
  }

  // widget.db를 이용해 datbase 객체를 선언하고 insert() 함수를 이용해 매개변수로 전달받은 데이터를 입력한다.
  // widget을 이용하면 현재 State 상위에 있는 StatefulWidget에 있는 db 변수를 사용할 수 있다.
  void _insertTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace); // 충돌이 발생할 경우 새 데이터로 교체
    // todoList 갱신
    setState(() {
      todoList = getTodos();
    });
  }

  // 데이터베이스에서 데이터를 가져오는 함수
  Future<List<Todo>> getTodos() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps =
        await database.query('todos'); // todos 테이블을 가져옴

    return List.generate(maps.length, (i) {
      // 할 일 목록에 표시할 각 아이템 생성
      int active = maps[i]['active'] == 1 ? 1 : 0;
      return Todo(
          title: maps[i]['title'].toString(),
          content: maps[i]['content'].toString(),
          active: active,
          id: maps[i]['id']);
    });
  }

  // 데이터베이스에 접속 후 데이터 수정
  void _updateTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
    setState(() {
      todoList = getTodos(); // 현재 목록 새로 고침
    });
  }

  // 매개변수로 전달받은 할 일 아이템을 데이터베이스에서 삭제
  void _deleteTodo(Todo todo) async {
    final Database database = await widget.db;
    await database.delete('todos', where: 'id=?', whereArgs: [todo.id]);
    setState(() {
      todoList = getTodos(); // 현재 목록 새로 고침
    });
  }

  // 모두 완료로 수정하기
  void _allUpdate() async {
    final Database database = await widget.db;
    await database.rawUpdate('update todos set active = 1 where active = 0');
    setState(() {
      todoList = getTodos();
    });
  }
}
