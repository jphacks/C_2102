import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// 部屋の新規追加画面
class AddStudyRoomPage extends StatefulWidget {
  @override
  _AddStudyRoomPageState createState() => _AddStudyRoomPageState();
}

class _AddStudyRoomPageState extends State<AddStudyRoomPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  String? dropdownValue;

  // 新規追加
  Future<void> addRoom() {
    CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
    var time = int.parse(timeController.text);
    var hour = (time / 60).floor();
    var min = time % 60;

    return rooms
        .add({
      'title': titleController.text,
      'members': '0',
      'studyTime': timeController.text,
      'createdTime': Timestamp.now(),
      'finishedTime': DateTime.now().add(Duration(hours: hour, minutes: min)),
      'roomIn': true,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '新規作成',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                  ),
                ),

                // 部屋名
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextFormField(
                    controller: titleController,
                    maxLength: 10, // ここでRoom名の最大文字数決定 勉強部屋一覧ページで一行のみになるようにしたい
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      labelText: "Room名",
                      hintText: "例：勉強会",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Room名を入力';
                      }
                      return null;
                    },
                  ),
                ),

                // 時間入力
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Row(children: [
                      Expanded(
                        flex: 2, // 2 要素分の横幅
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          child: Text(
                            '勉強時間',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 3, // 3 要素分の横幅
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                          ),
                          // color: Colors.red,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: timeController, // <- これで時間を取得
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: "時間を入力",
                              hintStyle: TextStyle(
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              // マイナスが入ってきたときのエラーがまだ未実装
                              if (value == null || value.isEmpty) {
                                return '時間を入力';
                              } else if (int.tryParse(value) == null) {
                                return '数値を入力';
                              } else if (int.parse(value.toString()) <= 0){
                                return '1以上の数を入力';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),

                      Expanded(
                        flex: 1, // 1 要素分の横幅
                        child: Container(
                          padding: const EdgeInsets.only(
                            right: 8.0,
                          ),
                          child: Text(
                            '分',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                    ),
                  ),
                ),

                // タグ？
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40.0,
                  ),
                ),
                // Container(
                //   // タグはドロップダウンとかで選択？？
                //   padding: const EdgeInsets.all(8.0),
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   child: TextFormField(
                //     style: TextStyle(
                //       fontSize: 20,
                //       height: 1.5,
                //     ),
                //     // controller: tagController, <- これでタグを取得
                //     decoration: InputDecoration(
                //       labelText: "タグ",
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                // ),

                // ボタン
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          // Room追加の処理
                          await addRoom();

                          // 作った部屋に自動的に移動する
                          Navigator.pop(context); // とりあえず今は前のページに戻るようにしてる
                        }
                      },
                      child: Text(
                        'スタート',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}