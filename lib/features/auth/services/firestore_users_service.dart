import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havena/features/auth/models/user_account.dart';

class FirestoreUsersService {
  FirestoreUsersService();

  final _collection = FirebaseFirestore.instance.collection('users');

  Future<UserAccount?> fetchUser(String uid) async {
    final doc = await _collection.doc(uid).get();
    if (!doc.exists) return null;
    return UserAccount.fromMap(doc.id, doc.data()!);
  }

  Future<void> createUser(UserAccount account) async {
    await _collection.doc(account.uid).set(
      account.toMap(useServerTimestamp: true),
    );
  }

  Future<List<UserAccount>> listUsers() async {
    final snapshot = await _collection.get();
    final users = snapshot.docs
        .map((doc) => UserAccount.fromMap(doc.id, doc.data()))
        .toList();
    users.sort((a, b) => a.email.compareTo(b.email));
    return users;
  }
}
