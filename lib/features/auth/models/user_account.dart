import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:havena/core/database/enums.dart';

class UserAccount {
  final String uid;
  final String email;
  final String fullName;
  final AppRole role;
  final bool active;
  final DateTime? createdAt;
  final String? createdBy;

  const UserAccount({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.active,
    this.createdAt,
    this.createdBy,
  });

  Map<String, dynamic> toMap({bool useServerTimestamp = false}) {
    final map = <String, dynamic>{
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'active': active,
      'createdBy': createdBy,
    };
    if (useServerTimestamp) {
      map['createdAt'] = FieldValue.serverTimestamp();
    } else if (createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }

  factory UserAccount.fromMap(String uid, Map<String, dynamic> map) {
    DateTime? createdAt;
    final createdAtValue = map['createdAt'];
    if (createdAtValue is Timestamp) {
      createdAt = createdAtValue.toDate();
    } else if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    }

    return UserAccount(
      uid: uid,
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      role: AppRole.values.byName(map['role'] as String),
      active: map['active'] as bool? ?? true,
      createdAt: createdAt,
      createdBy: map['createdBy'] as String?,
    );
  }
}
