import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static SharedPreferences? prefsInstance;

  static Future<void> setInstance() async {
    if(prefsInstance == null) {
      prefsInstance = await SharedPreferences.getInstance();
      print('インスタンスを生成');
    }
  }

  static Future<void> setUid(String newUid) async {
    await prefsInstance?.setString('uid', newUid);
    // await prefsInstance!.setBool('remember', true); ログイン情報保持
    print('端末保存完了');
  }

  static String getUid() {
    String uid = prefsInstance?.getString('uid') ?? '';
    return uid;
  }

  static Future<void> removeDataFromPrefs() async{ // 端末保存削除
    await prefsInstance!.remove('uid');
    print('端末保存データを削除');
  }
}