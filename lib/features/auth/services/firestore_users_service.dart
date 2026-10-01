import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havena/core/database/enums.dart';
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

  /// Mise à jour partielle (nom/rôle/statut actif) — jamais l'email ni le
  /// mot de passe, gérés par Firebase Auth, hors périmètre ici. Rejetée par
  /// `firestore.rules` si [uid] est celui de l'appelant (un utilisateur ne
  /// peut jamais modifier son propre rôle/statut) — `AccessManagementController`
  /// masque déjà ces actions pour sa propre ligne, cette règle reste le
  /// vrai garde-fou côté serveur.
  Future<void> updateUser(
    String uid, {
    String? fullName,
    AppRole? role,
    bool? active,
  }) async {
    final updates = <String, dynamic>{};
    if (fullName != null) updates['fullName'] = fullName;
    if (role != null) updates['role'] = role.name;
    if (active != null) updates['active'] = active;
    if (updates.isEmpty) return;
    await _collection.doc(uid).update(updates);
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
