import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class SignUpColorModel {

  static int imageIndex = Random().nextInt(6);

  static Future signUp(colorIndex) async {
    print('in signupcolor');
    final doc = FirebaseFirestore.instance.collection('users').doc();
    await doc.set({
      'color': colorIndex,
      'createdAt': Timestamp.now(),
      'imageIndex': imageIndex,
    });
    await SharedPrefs.setUid(doc.id);
  }
}