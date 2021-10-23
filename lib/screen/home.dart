import 'package:flutter/material.dart';
import 'package:mokumoku_a/screen/sign_up/sign_up.dart';
import 'package:mokumoku_a/screen/study_rooms/rooms_top_page.dart';
import 'package:mokumoku_a/utils/shared_prefs.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> checkUser() async{
    final uid = SharedPrefs.getUid();
    if(uid == '') {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
    } else {
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => RoomsTopPage()));
    }
  }

  @override
  void initState() {
    // widget完了後処理実行
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkUser()); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 70.0),
          child: LinearProgressIndicator(
            minHeight: 10.0,
          ),
        ),
      ),
    );
  }
}
