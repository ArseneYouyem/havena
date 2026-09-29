import 'package:havena/core/database/enums.dart';

class AuthSession {
  final String uid;
  final String email;
  final String fullName;
  final AppRole role;
  final bool active;
  final DateTime cachedAt;

  const AuthSession({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.active,
    required this.cachedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'active': active,
      'cachedAt': cachedAt.toIso8601String(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      role: AppRole.values.byName(json['role'] as String),
      active: json['active'] as bool,
      cachedAt: DateTime.parse(json['cachedAt'] as String),
    );
  }

  AuthSession copyWith({
    String? uid,
    String? email,
    String? fullName,
    AppRole? role,
    bool? active,
    DateTime? cachedAt,
  }) {
    return AuthSession(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      active: active ?? this.active,
      cachedAt: cachedAt ?? this.cachedAt,
    );
  }
}
