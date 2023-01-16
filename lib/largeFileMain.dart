/*
이미지 파일 내려받기
 */

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LargeFileMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LargeFileMain();
}

class _LargeFileMain extends State<LargeFileMain> {
  // 내려받을 이미지 주소
  final imgUrl =
      'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg'
      '?auto=compress';
  bool downloading = false; // 지금 내려받는 중인지 확인하는 변수
  var progressString = ""; // 현재 얼마나 내려받았는지 표시하는 변수
  String file = ""; // 내려받은 파일

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Large File Example'),
      ),
      body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Downloading File: $progressString',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : FutureBuilder( // 아직은 데이터가 없지만 앞으로 데이터를 받아서 처리
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        print('none');
                        return Text('데이터 없음');
                      case ConnectionState.waiting:
                        print('waiting');
                        return CircularProgressIndicator();
                      case ConnectionState.active:
                        print('active');
                        return CircularProgressIndicator();
                      case ConnectionState.done:
                        print('done');
                        if (snapshot.hasData) {
                          return snapshot.data as Widget;
                        }
                    }
                    print('end process');
                    return Text('데이터 없음');
                  },
                  future: downloadWidget(file),
                )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          downloadFile();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory(); // 앱의 내부 디렉터리를 가져오는 역할
      await dio.download(imgUrl, '${dir.path}/myimage.jpg',
          onReceiveProgress: (rec, total) {
        // 데이터를 받을 때마다 실행
        print('Rec: $rec, Total: $total');
        file = '${dir.path}/myimage.jpg';
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + '%';
        });
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    print('Download completed');
  }

  // 이미지 파일이 있으면 이미지를 화면에 출력, 없으면 No Data
  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();
    new FileImage(file).evict(); // 캐시 초기화

    if (exist) {
      return Center(
        child: Column(
          children: <Widget>[Image.file(File(filePath))],
        ),
      );
    } else {
      return Text('No Data');
    }
  }
}
