/*
할 일 기록하기 앱
할 일 데이터 저장 class
 */

class Todo {
  String? title; // 제목
  String? content; // 내용
  int? active; // 완료 여부
  int? id; // 순번

  Todo({this.title, this.content, this.active, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'active': active,
    };
  }
}