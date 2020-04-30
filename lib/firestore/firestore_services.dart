import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:personal_diary/app_utils/app_utils.dart';
import 'package:personal_diary/models/diary.dart';
import 'package:personal_diary/plugins_utils/GoogleSignin.dart';

class FirestoreServices {
  final _firestore = Firestore.instance;

  createUser(Map value, String uid) {
    String ref = "users";
    _firestore.collection(ref).document(uid).setData(value);
  }

  Future<void> add(Map diary) async {
    String ref = "user_diary";
    var user = await GoogleSigninUtils().currentUser();
    _firestore.collection(user.uid).document(diary['id'].toString()).setData(diary);

  }

  Future<List<Dairy>> getDiaries() async {
    List<Dairy> diaryList = new List<Dairy>();
    var user = await GoogleSigninUtils().currentUser();
    _firestore.collection(user.uid).getDocuments().then((snaps) {
      for (DocumentSnapshot ds in snaps.documents) {
        diaryList.add(Dairy.fromSnapshot(ds));
      }
      return diaryList;
    });
  }

  Future<void> delete(String id) async {
    var user = await GoogleSigninUtils().currentUser();
    _firestore.collection(user.uid).document(id).delete().whenComplete(() {
      print("Deleted Successfully");
    }).catchError((e) => print(e));
  }

  Future<void> update(Map diary) async {
    var user = await GoogleSigninUtils().currentUser();
    _firestore.collection(user.uid).document(diary['id'].toString()).updateData(diary).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

}
