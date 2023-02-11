/*
메모장 앱 만들기 MemoPage
 */

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'memo.dart';
import 'memoAdd.dart';
import 'memoDetail.dart';

class MemoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MemoPage();
}

class _MemoPage extends State<MemoPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = "https://example-5d077-default-rtdb.firebaseio.com/";
  List<Memo> memos = new List.empty(growable: true);

  // 광고 클래스 및 광고가 지금 로드되었는지 확인하는 변수
  BannerAd? _banner;
  bool _loadingBanner = false;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase(databaseURL: _databaseURL);
    reference = _database!.reference().child('memo');

    reference!.onChildAdded.listen((event) {
      // 데이터베이스에 데이터가 추가되면 자동 실행
      print(event.snapshot.value.toString());
      setState(() {
        memos.add(Memo.fromSnapshot(event.snapshot));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loadingBanner) {
      _loadingBanner = true;
      _createBanner(context);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('메모 앱'),
      ),
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Container(
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
                            footer:
                                Text(memos[index].createTime.substring(0, 10)),
                            child: Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: SizedBox(
                                child: GestureDetector(
                                  onTap: () async {
                                    Memo? memo = await Navigator.of(context)
                                        .push(MaterialPageRoute<Memo>(
                                            builder: (BuildContext context) =>
                                                MemoDetailPage(
                                                    reference!, memos[index])));
                                    if (memo != null) {
                                      setState(() {
                                        memos[index].title = memo.title;
                                        memos[index].content = memo.content;
                                      });
                                    }
                                  },
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              title: Text(memos[index].title),
                                              content: Text('삭제하시겠습니까?'),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () {
                                                      reference!
                                                          .child(
                                                              memos[index].key!)
                                                          .remove()
                                                          .then((_) {
                                                        setState(() {
                                                          memos.removeAt(index);
                                                          Navigator.of(context)
                                                              .pop();
                                                        });
                                                      });
                                                    },
                                                    child: Text('예')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('아니요')),
                                              ]);
                                        });
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
          if (_banner != null)
            Container(
              color: Colors.green,
              width: _banner!.size.width.toDouble(),
              height: _banner!.size.height.toDouble(),
              child: AdWidget(ad: _banner!),
            ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => MemoAddPage(reference!)));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _createBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getAnchoredAdaptiveBannerAdSize(
      Orientation.portrait,
      MediaQuery.of(context).size.width.truncate(),
    );
    if (size == null) {
      return;
    }
    final BannerAd banner = BannerAd(
      size: size, // 광고 크기
      request: AdRequest(),
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // '### 하단 배너 광고 ID ###'
      listener: BannerAdListener(
        // 애드몹에서 광고를 호출할 때 받아오는 데이터
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _banner = ad as BannerAd?;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
      ),
    );
    return banner.load();
  }

  // 페이지가 사라졌을 때 배너도 사라지도록
  @override
  void dispose() {
    super.dispose();
    _banner?.dispose();
  }
}
