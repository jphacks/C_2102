import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokumoku_a/model/user.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class Firestore {
  static FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  static final userRef = _firestoreInstance.collection('users');
  static final roomRef = _firestoreInstance.collection('rooms');

  // ユーザ情報取得
  static Future<UserModel> getProfile(String uid) async {
    final profile = await userRef.doc(uid).get();
    UserModel myProfile = UserModel(
      color: profile.data()?['color'],
      uid: uid,
      imageIndex: profile.data()?['imageIndex'],
    );
    return myProfile;
  }

  // 部屋にはいれるかどうか 入れなくなったらモデルのroomInをfalseに変更
  static Future<void> updateRoomIn(documentId, roomIn) {
    return roomRef
        .doc(documentId)
        .update({'roomIn': roomIn })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // rooms > 部屋のドキュメント > 値・usersのコレクション, 部屋のユーザについての処理
  // 部屋に入るときにroomsのusersにuserを追加
  static Future<void> addUsers(roomId, userDocumentId) async {
    return roomRef
      .doc(roomId)
      .collection('users')
      .doc(userDocumentId)
      .set({'inTime': Timestamp.now(), 'inRoom': true})
      .then((value) => print("User Updated"))
      .catchError((error) => print("Failed to update user: $error"));
  }


  // 勉強部屋内
  static Future<List> getUsers(String roomId, String myUid, List inRoomUserList) async {
    final getRoomUsers = roomRef.doc(roomId).collection('users');
    final snapshot = await getRoomUsers.where('inRoom', isEqualTo: true).get();
    List roomUsersList = [];
    await Future.forEach(snapshot.docs, (QueryDocumentSnapshot<Map<String, dynamic>> doc) async {
      var user = await getRoomUsers.doc(doc.id).get();
      bool userInRoom = user.data()!['inRoom'];
      if(doc.id != myUid && userInRoom) {
        UserModel user = await getProfile(doc.id);
        UserModel userProfile = UserModel(
          color: user.color,
          uid: user.uid,
          imageIndex: user.imageIndex
        );
        roomUsersList.add(userProfile);
      }
    });
    return roomUsersList;
  }

  static Future<void> getOutRoom(roomDocumentId, userDocumentId) {
    // final getOutTime = Timestamp.now();
    // final userStudyResult = roomRef.doc(roomDocumentId).collection('users').doc(userDocumentId);
    // final userProfile = getProfile(userDocumentId);
    return roomRef
        .doc(roomDocumentId)
        .collection('users')
        .doc(userDocumentId)
        .update({'inRoom': false});
  }
}