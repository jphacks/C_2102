import 'package:flutter/material.dart';
import 'package:mokumoku_a/model/user.dart';
import 'package:mokumoku_a/utils/firebase.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

// 勉強部屋に入った後の画面 実際の勉強部屋
class StudyPage extends StatefulWidget {
  final String title;
  final DateTime finishedTime;
  final String members;
  final String documentId;
  final String myUid;

  StudyPage(this.title, this.finishedTime, this.members, this.documentId, this.myUid);

  @override
  _StudyPageState createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {

  List inRoomUserList = [];
  int inRoomUserNum = 0;
  Future<void> createUsers() async {
    inRoomUserList = await Firestore.getUsers(widget.documentId, widget.myUid, inRoomUserList);
    inRoomUserNum = inRoomUserList.length;
    print('createUsers');
  }
  late UserModel userInfo;
  Future<void> getMyUid() async{
    userInfo = await Firestore.getProfile(widget.myUid);
    print('getMyUid done');
  }

  List<Color> colorsList = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  List<String> imagesList = [
    'images/MokuMoku_alpha_icon_01.PNG',
    'images/MokuMoku_alpha_icon_02.PNG',
    'images/MokuMoku_alpha_icon_03.PNG',
    'images/MokuMoku_alpha_icon_04.PNG',
    'images/MokuMoku_alpha_icon_05.PNG',
    'images/MokuMoku_alpha_icon_06.PNG',
  ];

  @override
  Future<void> dispose() async {
    String myUid = SharedPrefs.getUid();
    Firestore.getOutRoom(widget.documentId, myUid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  RichText(
          text: TextSpan(
              children: [
                TextSpan(
                  text: '『' + widget.title + '』',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: '部屋',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ]
          ),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: getMyUid(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.done) {
                return Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    // アイコン画像
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top:16.0),
                        child: Container(
                          padding: EdgeInsets.all(8.0),

                          // ToDo：ここのアイコン画像表示をスマートにしたい
                          child:  CircleAvatar(
                            // backgroundColor: Theme.of(context).primaryColor,
                            radius: MediaQuery.of(context).size.width / 7,
                            child: CircleAvatar(
                              backgroundImage: AssetImage(imagesList[userInfo.imageIndex]),
                              backgroundColor: colorsList[userInfo.color],
                              radius: MediaQuery.of(context).size.width / 7,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
              } else {
                return Center(child: CircularProgressIndicator(),);
              }
            }
          ),

          // 部屋に入っているユーザー表示
          StreamBuilder(
            stream: Firestore.roomRef.doc(widget.documentId).collection('users').snapshots(),
            builder: (context, snapshot) {
              return FutureBuilder(
                future: createUsers(),
                builder: (context, snapshot) {
                  // if(snapshot.connectionState == ConnectionState.done) {
                    return Flexible(
                      child: Column(
                        children: [
                          // 部屋の人数
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30.0),
                            child: Text(
                              inRoomUserNum.toString() + '人があなたと一緒に勉強しています。',
                              style: TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Flexible(
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3
                              ),
                              itemCount: inRoomUserList.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.width / 4,
                                      width: MediaQuery.of(context).size.width / 4,
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topCenter,

                                            // ToDo：ここのアイコン画像表示をスマートにしたい
                                            child:  CircleAvatar(
                                              // backgroundColor: Theme.of(context).primaryColor,
                                              radius: MediaQuery.of(context).size.width / 8.5,
                                              child: CircleAvatar(
                                                backgroundImage: AssetImage(imagesList[inRoomUserList[index].imageIndex]),
                                                backgroundColor: colorsList[inRoomUserList[index].color],
                                                radius: MediaQuery.of(context).size.width / 8.5,
                                              ),
                                            ),
                                          ),
                                        Container(
                                          alignment: Alignment.bottomRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              // いいね処理
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('いいねを押しました')),
                                              );
                                            },
                                            child: Container(
                                              child: Icon(
                                                  Icons.favorite,
                                                  color: Colors.pink,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    );
                  // } else {
                  //   return Center(child: CircularProgressIndicator(),);
                  // }
                },
              );
            }
          ),
        ],
      ),
    );
  }
}