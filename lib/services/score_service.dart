import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveScore(int score) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final docRef = _db.collection('scores').doc(user.uid);

      final snapshot = await docRef.get();
      int highScore = score;

      if (snapshot.exists) {
        final oldHigh = snapshot['highScore'] ?? 0;
        if (oldHigh > score) highScore = oldHigh;
      }

      await docRef.set({
        'email': user.email,
        'highScore': highScore,
        'lastScore': score,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      print("Save score error: $e");
    }
  }

  Stream<QuerySnapshot> getTop5() {
    return _db
        .collection('scores')
        .orderBy('highScore', descending: true)
        .limit(5)
        .snapshots();
  }
}