// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AppRole, String> roleId =
      GeneratedColumn<String>(
        'role_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AppRole>($UsersTable.$converterroleId);
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uid,
    fullName,
    email,
    roleId,
    active,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      roleId: $UsersTable.$converterroleId.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role_id'],
        )!,
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AppRole, String, String> $converterroleId =
      const EnumNameConverter<AppRole>(AppRole.values);
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String uid;
  final String fullName;
  final String email;
  final AppRole roleId;
  final bool active;
  final DateTime? lastSyncedAt;
  const User({
    required this.id,
    required this.uid,
    required this.fullName,
    required this.email,
    required this.roleId,
    required this.active,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uid'] = Variable<String>(uid);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    {
      map['role_id'] = Variable<String>(
        $UsersTable.$converterroleId.toSql(roleId),
      );
    }
    map['active'] = Variable<bool>(active);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      uid: Value(uid),
      fullName: Value(fullName),
      email: Value(email),
      roleId: Value(roleId),
      active: Value(active),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      uid: serializer.fromJson<String>(json['uid']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      roleId: $UsersTable.$converterroleId.fromJson(
        serializer.fromJson<String>(json['roleId']),
      ),
      active: serializer.fromJson<bool>(json['active']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uid': serializer.toJson<String>(uid),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'roleId': serializer.toJson<String>(
        $UsersTable.$converterroleId.toJson(roleId),
      ),
      'active': serializer.toJson<bool>(active),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  User copyWith({
    int? id,
    String? uid,
    String? fullName,
    String? email,
    AppRole? roleId,
    bool? active,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => User(
    id: id ?? this.id,
    uid: uid ?? this.uid,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    roleId: roleId ?? this.roleId,
    active: active ?? this.active,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      uid: data.uid.present ? data.uid.value : this.uid,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      roleId: data.roleId.present ? data.roleId.value : this.roleId,
      active: data.active.present ? data.active.value : this.active,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('roleId: $roleId, ')
          ..write('active: $active, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, uid, fullName, email, roleId, active, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.uid == this.uid &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.roleId == this.roleId &&
          other.active == this.active &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> uid;
  final Value<String> fullName;
  final Value<String> email;
  final Value<AppRole> roleId;
  final Value<bool> active;
  final Value<DateTime?> lastSyncedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.uid = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.roleId = const Value.absent(),
    this.active = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String uid,
    required String fullName,
    required String email,
    required AppRole roleId,
    this.active = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
  }) : uid = Value(uid),
       fullName = Value(fullName),
       email = Value(email),
       roleId = Value(roleId);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? uid,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? roleId,
    Expression<bool>? active,
    Expression<DateTime>? lastSyncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uid != null) 'uid': uid,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (roleId != null) 'role_id': roleId,
      if (active != null) 'active': active,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? uid,
    Value<String>? fullName,
    Value<String>? email,
    Value<AppRole>? roleId,
    Value<bool>? active,
    Value<DateTime?>? lastSyncedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      roleId: roleId ?? this.roleId,
      active: active ?? this.active,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (roleId.present) {
      map['role_id'] = Variable<String>(
        $UsersTable.$converterroleId.toSql(roleId.value),
      );
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('uid: $uid, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('roleId: $roleId, ')
          ..write('active: $active, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }
}

class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whatsappMeta = const VerificationMeta(
    'whatsapp',
  );
  @override
  late final GeneratedColumn<String> whatsapp = GeneratedColumn<String>(
    'whatsapp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _countryMeta = const VerificationMeta(
    'country',
  );
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
    'country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientTypeMeta = const VerificationMeta(
    'clientType',
  );
  @override
  late final GeneratedColumn<String> clientType = GeneratedColumn<String>(
    'client_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _logementReferenceMeta = const VerificationMeta(
    'logementReference',
  );
  @override
  late final GeneratedColumn<String> logementReference =
      GeneratedColumn<String>(
        'logement_reference',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _subscriptionFormulaMeta =
      const VerificationMeta('subscriptionFormula');
  @override
  late final GeneratedColumn<String> subscriptionFormula =
      GeneratedColumn<String>(
        'subscription_formula',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _renewalDateMeta = const VerificationMeta(
    'renewalDate',
  );
  @override
  late final GeneratedColumn<DateTime> renewalDate = GeneratedColumn<DateTime>(
    'renewal_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ClientStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ClientStatus>($ClientsTable.$converterstatus);
  static const VerificationMeta _lastContactDateMeta = const VerificationMeta(
    'lastContactDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastContactDate =
      GeneratedColumn<DateTime>(
        'last_contact_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($ClientsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    fullName,
    phone,
    whatsapp,
    email,
    country,
    city,
    clientType,
    logementReference,
    subscriptionFormula,
    startDate,
    renewalDate,
    status,
    lastContactDate,
    notes,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Client> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('whatsapp')) {
      context.handle(
        _whatsappMeta,
        whatsapp.isAcceptableOrUnknown(data['whatsapp']!, _whatsappMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('country')) {
      context.handle(
        _countryMeta,
        country.isAcceptableOrUnknown(data['country']!, _countryMeta),
      );
    } else if (isInserting) {
      context.missing(_countryMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('client_type')) {
      context.handle(
        _clientTypeMeta,
        clientType.isAcceptableOrUnknown(data['client_type']!, _clientTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_clientTypeMeta);
    }
    if (data.containsKey('logement_reference')) {
      context.handle(
        _logementReferenceMeta,
        logementReference.isAcceptableOrUnknown(
          data['logement_reference']!,
          _logementReferenceMeta,
        ),
      );
    }
    if (data.containsKey('subscription_formula')) {
      context.handle(
        _subscriptionFormulaMeta,
        subscriptionFormula.isAcceptableOrUnknown(
          data['subscription_formula']!,
          _subscriptionFormulaMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('renewal_date')) {
      context.handle(
        _renewalDateMeta,
        renewalDate.isAcceptableOrUnknown(
          data['renewal_date']!,
          _renewalDateMeta,
        ),
      );
    }
    if (data.containsKey('last_contact_date')) {
      context.handle(
        _lastContactDateMeta,
        lastContactDate.isAcceptableOrUnknown(
          data['last_contact_date']!,
          _lastContactDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      whatsapp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}whatsapp'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      country: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}country'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      clientType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_type'],
      )!,
      logementReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}logement_reference'],
      ),
      subscriptionFormula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subscription_formula'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      renewalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}renewal_date'],
      ),
      status: $ClientsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      lastContactDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_contact_date'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $ClientsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ClientStatus, String, String> $converterstatus =
      const EnumNameConverter<ClientStatus>(ClientStatus.values);
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Client extends DataClass implements Insertable<Client> {
  final int id;
  final String reference;
  final String fullName;
  final String phone;
  final String? whatsapp;
  final String? email;
  final String country;
  final String city;
  final String clientType;
  final String? logementReference;
  final String? subscriptionFormula;
  final DateTime? startDate;
  final DateTime? renewalDate;
  final ClientStatus status;
  final DateTime? lastContactDate;
  final String? notes;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Client({
    required this.id,
    required this.reference,
    required this.fullName,
    required this.phone,
    this.whatsapp,
    this.email,
    required this.country,
    required this.city,
    required this.clientType,
    this.logementReference,
    this.subscriptionFormula,
    this.startDate,
    this.renewalDate,
    required this.status,
    this.lastContactDate,
    this.notes,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || whatsapp != null) {
      map['whatsapp'] = Variable<String>(whatsapp);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['country'] = Variable<String>(country);
    map['city'] = Variable<String>(city);
    map['client_type'] = Variable<String>(clientType);
    if (!nullToAbsent || logementReference != null) {
      map['logement_reference'] = Variable<String>(logementReference);
    }
    if (!nullToAbsent || subscriptionFormula != null) {
      map['subscription_formula'] = Variable<String>(subscriptionFormula);
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || renewalDate != null) {
      map['renewal_date'] = Variable<DateTime>(renewalDate);
    }
    {
      map['status'] = Variable<String>(
        $ClientsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || lastContactDate != null) {
      map['last_contact_date'] = Variable<DateTime>(lastContactDate);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $ClientsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      reference: Value(reference),
      fullName: Value(fullName),
      phone: Value(phone),
      whatsapp: whatsapp == null && nullToAbsent
          ? const Value.absent()
          : Value(whatsapp),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      country: Value(country),
      city: Value(city),
      clientType: Value(clientType),
      logementReference: logementReference == null && nullToAbsent
          ? const Value.absent()
          : Value(logementReference),
      subscriptionFormula: subscriptionFormula == null && nullToAbsent
          ? const Value.absent()
          : Value(subscriptionFormula),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      renewalDate: renewalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(renewalDate),
      status: Value(status),
      lastContactDate: lastContactDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastContactDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Client.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String>(json['phone']),
      whatsapp: serializer.fromJson<String?>(json['whatsapp']),
      email: serializer.fromJson<String?>(json['email']),
      country: serializer.fromJson<String>(json['country']),
      city: serializer.fromJson<String>(json['city']),
      clientType: serializer.fromJson<String>(json['clientType']),
      logementReference: serializer.fromJson<String?>(
        json['logementReference'],
      ),
      subscriptionFormula: serializer.fromJson<String?>(
        json['subscriptionFormula'],
      ),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      renewalDate: serializer.fromJson<DateTime?>(json['renewalDate']),
      status: $ClientsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      lastContactDate: serializer.fromJson<DateTime?>(json['lastContactDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $ClientsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String>(phone),
      'whatsapp': serializer.toJson<String?>(whatsapp),
      'email': serializer.toJson<String?>(email),
      'country': serializer.toJson<String>(country),
      'city': serializer.toJson<String>(city),
      'clientType': serializer.toJson<String>(clientType),
      'logementReference': serializer.toJson<String?>(logementReference),
      'subscriptionFormula': serializer.toJson<String?>(subscriptionFormula),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'renewalDate': serializer.toJson<DateTime?>(renewalDate),
      'status': serializer.toJson<String>(
        $ClientsTable.$converterstatus.toJson(status),
      ),
      'lastContactDate': serializer.toJson<DateTime?>(lastContactDate),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $ClientsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Client copyWith({
    int? id,
    String? reference,
    String? fullName,
    String? phone,
    Value<String?> whatsapp = const Value.absent(),
    Value<String?> email = const Value.absent(),
    String? country,
    String? city,
    String? clientType,
    Value<String?> logementReference = const Value.absent(),
    Value<String?> subscriptionFormula = const Value.absent(),
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> renewalDate = const Value.absent(),
    ClientStatus? status,
    Value<DateTime?> lastContactDate = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Client(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    whatsapp: whatsapp.present ? whatsapp.value : this.whatsapp,
    email: email.present ? email.value : this.email,
    country: country ?? this.country,
    city: city ?? this.city,
    clientType: clientType ?? this.clientType,
    logementReference: logementReference.present
        ? logementReference.value
        : this.logementReference,
    subscriptionFormula: subscriptionFormula.present
        ? subscriptionFormula.value
        : this.subscriptionFormula,
    startDate: startDate.present ? startDate.value : this.startDate,
    renewalDate: renewalDate.present ? renewalDate.value : this.renewalDate,
    status: status ?? this.status,
    lastContactDate: lastContactDate.present
        ? lastContactDate.value
        : this.lastContactDate,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      whatsapp: data.whatsapp.present ? data.whatsapp.value : this.whatsapp,
      email: data.email.present ? data.email.value : this.email,
      country: data.country.present ? data.country.value : this.country,
      city: data.city.present ? data.city.value : this.city,
      clientType: data.clientType.present
          ? data.clientType.value
          : this.clientType,
      logementReference: data.logementReference.present
          ? data.logementReference.value
          : this.logementReference,
      subscriptionFormula: data.subscriptionFormula.present
          ? data.subscriptionFormula.value
          : this.subscriptionFormula,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      renewalDate: data.renewalDate.present
          ? data.renewalDate.value
          : this.renewalDate,
      status: data.status.present ? data.status.value : this.status,
      lastContactDate: data.lastContactDate.present
          ? data.lastContactDate.value
          : this.lastContactDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('email: $email, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('clientType: $clientType, ')
          ..write('logementReference: $logementReference, ')
          ..write('subscriptionFormula: $subscriptionFormula, ')
          ..write('startDate: $startDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('status: $status, ')
          ..write('lastContactDate: $lastContactDate, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    fullName,
    phone,
    whatsapp,
    email,
    country,
    city,
    clientType,
    logementReference,
    subscriptionFormula,
    startDate,
    renewalDate,
    status,
    lastContactDate,
    notes,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.whatsapp == this.whatsapp &&
          other.email == this.email &&
          other.country == this.country &&
          other.city == this.city &&
          other.clientType == this.clientType &&
          other.logementReference == this.logementReference &&
          other.subscriptionFormula == this.subscriptionFormula &&
          other.startDate == this.startDate &&
          other.renewalDate == this.renewalDate &&
          other.status == this.status &&
          other.lastContactDate == this.lastContactDate &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<int> id;
  final Value<String> reference;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String?> whatsapp;
  final Value<String?> email;
  final Value<String> country;
  final Value<String> city;
  final Value<String> clientType;
  final Value<String?> logementReference;
  final Value<String?> subscriptionFormula;
  final Value<DateTime?> startDate;
  final Value<DateTime?> renewalDate;
  final Value<ClientStatus> status;
  final Value<DateTime?> lastContactDate;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.whatsapp = const Value.absent(),
    this.email = const Value.absent(),
    this.country = const Value.absent(),
    this.city = const Value.absent(),
    this.clientType = const Value.absent(),
    this.logementReference = const Value.absent(),
    this.subscriptionFormula = const Value.absent(),
    this.startDate = const Value.absent(),
    this.renewalDate = const Value.absent(),
    this.status = const Value.absent(),
    this.lastContactDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ClientsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required String fullName,
    required String phone,
    this.whatsapp = const Value.absent(),
    this.email = const Value.absent(),
    required String country,
    required String city,
    required String clientType,
    this.logementReference = const Value.absent(),
    this.subscriptionFormula = const Value.absent(),
    this.startDate = const Value.absent(),
    this.renewalDate = const Value.absent(),
    required ClientStatus status,
    this.lastContactDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       fullName = Value(fullName),
       phone = Value(phone),
       country = Value(country),
       city = Value(city),
       clientType = Value(clientType),
       status = Value(status);
  static Insertable<Client> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? whatsapp,
    Expression<String>? email,
    Expression<String>? country,
    Expression<String>? city,
    Expression<String>? clientType,
    Expression<String>? logementReference,
    Expression<String>? subscriptionFormula,
    Expression<DateTime>? startDate,
    Expression<DateTime>? renewalDate,
    Expression<String>? status,
    Expression<DateTime>? lastContactDate,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (whatsapp != null) 'whatsapp': whatsapp,
      if (email != null) 'email': email,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (clientType != null) 'client_type': clientType,
      if (logementReference != null) 'logement_reference': logementReference,
      if (subscriptionFormula != null)
        'subscription_formula': subscriptionFormula,
      if (startDate != null) 'start_date': startDate,
      if (renewalDate != null) 'renewal_date': renewalDate,
      if (status != null) 'status': status,
      if (lastContactDate != null) 'last_contact_date': lastContactDate,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ClientsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<String>? fullName,
    Value<String>? phone,
    Value<String?>? whatsapp,
    Value<String?>? email,
    Value<String>? country,
    Value<String>? city,
    Value<String>? clientType,
    Value<String?>? logementReference,
    Value<String?>? subscriptionFormula,
    Value<DateTime?>? startDate,
    Value<DateTime?>? renewalDate,
    Value<ClientStatus>? status,
    Value<DateTime?>? lastContactDate,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return ClientsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      country: country ?? this.country,
      city: city ?? this.city,
      clientType: clientType ?? this.clientType,
      logementReference: logementReference ?? this.logementReference,
      subscriptionFormula: subscriptionFormula ?? this.subscriptionFormula,
      startDate: startDate ?? this.startDate,
      renewalDate: renewalDate ?? this.renewalDate,
      status: status ?? this.status,
      lastContactDate: lastContactDate ?? this.lastContactDate,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (whatsapp.present) {
      map['whatsapp'] = Variable<String>(whatsapp.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (clientType.present) {
      map['client_type'] = Variable<String>(clientType.value);
    }
    if (logementReference.present) {
      map['logement_reference'] = Variable<String>(logementReference.value);
    }
    if (subscriptionFormula.present) {
      map['subscription_formula'] = Variable<String>(subscriptionFormula.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (renewalDate.present) {
      map['renewal_date'] = Variable<DateTime>(renewalDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ClientsTable.$converterstatus.toSql(status.value),
      );
    }
    if (lastContactDate.present) {
      map['last_contact_date'] = Variable<DateTime>(lastContactDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $ClientsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('whatsapp: $whatsapp, ')
          ..write('email: $email, ')
          ..write('country: $country, ')
          ..write('city: $city, ')
          ..write('clientType: $clientType, ')
          ..write('logementReference: $logementReference, ')
          ..write('subscriptionFormula: $subscriptionFormula, ')
          ..write('startDate: $startDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('status: $status, ')
          ..write('lastContactDate: $lastContactDate, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $LogementsTable extends Logements
    with TableInfo<$LogementsTable, Logement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _neighborhoodMeta = const VerificationMeta(
    'neighborhood',
  );
  @override
  late final GeneratedColumn<String> neighborhood = GeneratedColumn<String>(
    'neighborhood',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _housingTypeMeta = const VerificationMeta(
    'housingType',
  );
  @override
  late final GeneratedColumn<String> housingType = GeneratedColumn<String>(
    'housing_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bedroomsCountMeta = const VerificationMeta(
    'bedroomsCount',
  );
  @override
  late final GeneratedColumn<int> bedroomsCount = GeneratedColumn<int>(
    'bedrooms_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _occupancyMeta = const VerificationMeta(
    'occupancy',
  );
  @override
  late final GeneratedColumn<String> occupancy = GeneratedColumn<String>(
    'occupancy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localContactMeta = const VerificationMeta(
    'localContact',
  );
  @override
  late final GeneratedColumn<String> localContact = GeneratedColumn<String>(
    'local_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _guardianMeta = const VerificationMeta(
    'guardian',
  );
  @override
  late final GeneratedColumn<String> guardian = GeneratedColumn<String>(
    'guardian',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keysCountMeta = const VerificationMeta(
    'keysCount',
  );
  @override
  late final GeneratedColumn<int> keysCount = GeneratedColumn<int>(
    'keys_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mainEquipmentMeta = const VerificationMeta(
    'mainEquipment',
  );
  @override
  late final GeneratedColumn<String> mainEquipment = GeneratedColumn<String>(
    'main_equipment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastInspectionDateMeta =
      const VerificationMeta('lastInspectionDate');
  @override
  late final GeneratedColumn<DateTime> lastInspectionDate =
      GeneratedColumn<DateTime>(
        'last_inspection_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextInspectionDateMeta =
      const VerificationMeta('nextInspectionDate');
  @override
  late final GeneratedColumn<DateTime> nextInspectionDate =
      GeneratedColumn<DateTime>(
        'next_inspection_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<HousingCondition?, String>
  generalCondition =
      GeneratedColumn<String>(
        'general_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HousingCondition?>(
        $LogementsTable.$convertergeneralConditionn,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($LogementsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    clientId,
    address,
    neighborhood,
    housingType,
    bedroomsCount,
    occupancy,
    localContact,
    guardian,
    keysCount,
    mainEquipment,
    lastInspectionDate,
    nextInspectionDate,
    generalCondition,
    notes,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Logement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('neighborhood')) {
      context.handle(
        _neighborhoodMeta,
        neighborhood.isAcceptableOrUnknown(
          data['neighborhood']!,
          _neighborhoodMeta,
        ),
      );
    }
    if (data.containsKey('housing_type')) {
      context.handle(
        _housingTypeMeta,
        housingType.isAcceptableOrUnknown(
          data['housing_type']!,
          _housingTypeMeta,
        ),
      );
    }
    if (data.containsKey('bedrooms_count')) {
      context.handle(
        _bedroomsCountMeta,
        bedroomsCount.isAcceptableOrUnknown(
          data['bedrooms_count']!,
          _bedroomsCountMeta,
        ),
      );
    }
    if (data.containsKey('occupancy')) {
      context.handle(
        _occupancyMeta,
        occupancy.isAcceptableOrUnknown(data['occupancy']!, _occupancyMeta),
      );
    }
    if (data.containsKey('local_contact')) {
      context.handle(
        _localContactMeta,
        localContact.isAcceptableOrUnknown(
          data['local_contact']!,
          _localContactMeta,
        ),
      );
    }
    if (data.containsKey('guardian')) {
      context.handle(
        _guardianMeta,
        guardian.isAcceptableOrUnknown(data['guardian']!, _guardianMeta),
      );
    }
    if (data.containsKey('keys_count')) {
      context.handle(
        _keysCountMeta,
        keysCount.isAcceptableOrUnknown(data['keys_count']!, _keysCountMeta),
      );
    }
    if (data.containsKey('main_equipment')) {
      context.handle(
        _mainEquipmentMeta,
        mainEquipment.isAcceptableOrUnknown(
          data['main_equipment']!,
          _mainEquipmentMeta,
        ),
      );
    }
    if (data.containsKey('last_inspection_date')) {
      context.handle(
        _lastInspectionDateMeta,
        lastInspectionDate.isAcceptableOrUnknown(
          data['last_inspection_date']!,
          _lastInspectionDateMeta,
        ),
      );
    }
    if (data.containsKey('next_inspection_date')) {
      context.handle(
        _nextInspectionDateMeta,
        nextInspectionDate.isAcceptableOrUnknown(
          data['next_inspection_date']!,
          _nextInspectionDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Logement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Logement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      neighborhood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}neighborhood'],
      ),
      housingType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}housing_type'],
      ),
      bedroomsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bedrooms_count'],
      ),
      occupancy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occupancy'],
      ),
      localContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_contact'],
      ),
      guardian: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guardian'],
      ),
      keysCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}keys_count'],
      ),
      mainEquipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_equipment'],
      ),
      lastInspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_inspection_date'],
      ),
      nextInspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_inspection_date'],
      ),
      generalCondition: $LogementsTable.$convertergeneralConditionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}general_condition'],
        ),
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $LogementsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $LogementsTable createAlias(String alias) {
    return $LogementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HousingCondition, String, String>
  $convertergeneralCondition = const EnumNameConverter<HousingCondition>(
    HousingCondition.values,
  );
  static JsonTypeConverter2<HousingCondition?, String?, String?>
  $convertergeneralConditionn = JsonTypeConverter2.asNullable(
    $convertergeneralCondition,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Logement extends DataClass implements Insertable<Logement> {
  final int id;
  final String reference;
  final int? clientId;
  final String address;
  final String? neighborhood;
  final String? housingType;
  final int? bedroomsCount;
  final String? occupancy;
  final String? localContact;
  final String? guardian;
  final int? keysCount;
  final String? mainEquipment;
  final DateTime? lastInspectionDate;
  final DateTime? nextInspectionDate;
  final HousingCondition? generalCondition;
  final String? notes;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Logement({
    required this.id,
    required this.reference,
    this.clientId,
    required this.address,
    this.neighborhood,
    this.housingType,
    this.bedroomsCount,
    this.occupancy,
    this.localContact,
    this.guardian,
    this.keysCount,
    this.mainEquipment,
    this.lastInspectionDate,
    this.nextInspectionDate,
    this.generalCondition,
    this.notes,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    if (!nullToAbsent || clientId != null) {
      map['client_id'] = Variable<int>(clientId);
    }
    map['address'] = Variable<String>(address);
    if (!nullToAbsent || neighborhood != null) {
      map['neighborhood'] = Variable<String>(neighborhood);
    }
    if (!nullToAbsent || housingType != null) {
      map['housing_type'] = Variable<String>(housingType);
    }
    if (!nullToAbsent || bedroomsCount != null) {
      map['bedrooms_count'] = Variable<int>(bedroomsCount);
    }
    if (!nullToAbsent || occupancy != null) {
      map['occupancy'] = Variable<String>(occupancy);
    }
    if (!nullToAbsent || localContact != null) {
      map['local_contact'] = Variable<String>(localContact);
    }
    if (!nullToAbsent || guardian != null) {
      map['guardian'] = Variable<String>(guardian);
    }
    if (!nullToAbsent || keysCount != null) {
      map['keys_count'] = Variable<int>(keysCount);
    }
    if (!nullToAbsent || mainEquipment != null) {
      map['main_equipment'] = Variable<String>(mainEquipment);
    }
    if (!nullToAbsent || lastInspectionDate != null) {
      map['last_inspection_date'] = Variable<DateTime>(lastInspectionDate);
    }
    if (!nullToAbsent || nextInspectionDate != null) {
      map['next_inspection_date'] = Variable<DateTime>(nextInspectionDate);
    }
    if (!nullToAbsent || generalCondition != null) {
      map['general_condition'] = Variable<String>(
        $LogementsTable.$convertergeneralConditionn.toSql(generalCondition),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $LogementsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  LogementsCompanion toCompanion(bool nullToAbsent) {
    return LogementsCompanion(
      id: Value(id),
      reference: Value(reference),
      clientId: clientId == null && nullToAbsent
          ? const Value.absent()
          : Value(clientId),
      address: Value(address),
      neighborhood: neighborhood == null && nullToAbsent
          ? const Value.absent()
          : Value(neighborhood),
      housingType: housingType == null && nullToAbsent
          ? const Value.absent()
          : Value(housingType),
      bedroomsCount: bedroomsCount == null && nullToAbsent
          ? const Value.absent()
          : Value(bedroomsCount),
      occupancy: occupancy == null && nullToAbsent
          ? const Value.absent()
          : Value(occupancy),
      localContact: localContact == null && nullToAbsent
          ? const Value.absent()
          : Value(localContact),
      guardian: guardian == null && nullToAbsent
          ? const Value.absent()
          : Value(guardian),
      keysCount: keysCount == null && nullToAbsent
          ? const Value.absent()
          : Value(keysCount),
      mainEquipment: mainEquipment == null && nullToAbsent
          ? const Value.absent()
          : Value(mainEquipment),
      lastInspectionDate: lastInspectionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInspectionDate),
      nextInspectionDate: nextInspectionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextInspectionDate),
      generalCondition: generalCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(generalCondition),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Logement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Logement(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      clientId: serializer.fromJson<int?>(json['clientId']),
      address: serializer.fromJson<String>(json['address']),
      neighborhood: serializer.fromJson<String?>(json['neighborhood']),
      housingType: serializer.fromJson<String?>(json['housingType']),
      bedroomsCount: serializer.fromJson<int?>(json['bedroomsCount']),
      occupancy: serializer.fromJson<String?>(json['occupancy']),
      localContact: serializer.fromJson<String?>(json['localContact']),
      guardian: serializer.fromJson<String?>(json['guardian']),
      keysCount: serializer.fromJson<int?>(json['keysCount']),
      mainEquipment: serializer.fromJson<String?>(json['mainEquipment']),
      lastInspectionDate: serializer.fromJson<DateTime?>(
        json['lastInspectionDate'],
      ),
      nextInspectionDate: serializer.fromJson<DateTime?>(
        json['nextInspectionDate'],
      ),
      generalCondition: $LogementsTable.$convertergeneralConditionn.fromJson(
        serializer.fromJson<String?>(json['generalCondition']),
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $LogementsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'clientId': serializer.toJson<int?>(clientId),
      'address': serializer.toJson<String>(address),
      'neighborhood': serializer.toJson<String?>(neighborhood),
      'housingType': serializer.toJson<String?>(housingType),
      'bedroomsCount': serializer.toJson<int?>(bedroomsCount),
      'occupancy': serializer.toJson<String?>(occupancy),
      'localContact': serializer.toJson<String?>(localContact),
      'guardian': serializer.toJson<String?>(guardian),
      'keysCount': serializer.toJson<int?>(keysCount),
      'mainEquipment': serializer.toJson<String?>(mainEquipment),
      'lastInspectionDate': serializer.toJson<DateTime?>(lastInspectionDate),
      'nextInspectionDate': serializer.toJson<DateTime?>(nextInspectionDate),
      'generalCondition': serializer.toJson<String?>(
        $LogementsTable.$convertergeneralConditionn.toJson(generalCondition),
      ),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $LogementsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Logement copyWith({
    int? id,
    String? reference,
    Value<int?> clientId = const Value.absent(),
    String? address,
    Value<String?> neighborhood = const Value.absent(),
    Value<String?> housingType = const Value.absent(),
    Value<int?> bedroomsCount = const Value.absent(),
    Value<String?> occupancy = const Value.absent(),
    Value<String?> localContact = const Value.absent(),
    Value<String?> guardian = const Value.absent(),
    Value<int?> keysCount = const Value.absent(),
    Value<String?> mainEquipment = const Value.absent(),
    Value<DateTime?> lastInspectionDate = const Value.absent(),
    Value<DateTime?> nextInspectionDate = const Value.absent(),
    Value<HousingCondition?> generalCondition = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Logement(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    clientId: clientId.present ? clientId.value : this.clientId,
    address: address ?? this.address,
    neighborhood: neighborhood.present ? neighborhood.value : this.neighborhood,
    housingType: housingType.present ? housingType.value : this.housingType,
    bedroomsCount: bedroomsCount.present
        ? bedroomsCount.value
        : this.bedroomsCount,
    occupancy: occupancy.present ? occupancy.value : this.occupancy,
    localContact: localContact.present ? localContact.value : this.localContact,
    guardian: guardian.present ? guardian.value : this.guardian,
    keysCount: keysCount.present ? keysCount.value : this.keysCount,
    mainEquipment: mainEquipment.present
        ? mainEquipment.value
        : this.mainEquipment,
    lastInspectionDate: lastInspectionDate.present
        ? lastInspectionDate.value
        : this.lastInspectionDate,
    nextInspectionDate: nextInspectionDate.present
        ? nextInspectionDate.value
        : this.nextInspectionDate,
    generalCondition: generalCondition.present
        ? generalCondition.value
        : this.generalCondition,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Logement copyWithCompanion(LogementsCompanion data) {
    return Logement(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      address: data.address.present ? data.address.value : this.address,
      neighborhood: data.neighborhood.present
          ? data.neighborhood.value
          : this.neighborhood,
      housingType: data.housingType.present
          ? data.housingType.value
          : this.housingType,
      bedroomsCount: data.bedroomsCount.present
          ? data.bedroomsCount.value
          : this.bedroomsCount,
      occupancy: data.occupancy.present ? data.occupancy.value : this.occupancy,
      localContact: data.localContact.present
          ? data.localContact.value
          : this.localContact,
      guardian: data.guardian.present ? data.guardian.value : this.guardian,
      keysCount: data.keysCount.present ? data.keysCount.value : this.keysCount,
      mainEquipment: data.mainEquipment.present
          ? data.mainEquipment.value
          : this.mainEquipment,
      lastInspectionDate: data.lastInspectionDate.present
          ? data.lastInspectionDate.value
          : this.lastInspectionDate,
      nextInspectionDate: data.nextInspectionDate.present
          ? data.nextInspectionDate.value
          : this.nextInspectionDate,
      generalCondition: data.generalCondition.present
          ? data.generalCondition.value
          : this.generalCondition,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Logement(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('clientId: $clientId, ')
          ..write('address: $address, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('housingType: $housingType, ')
          ..write('bedroomsCount: $bedroomsCount, ')
          ..write('occupancy: $occupancy, ')
          ..write('localContact: $localContact, ')
          ..write('guardian: $guardian, ')
          ..write('keysCount: $keysCount, ')
          ..write('mainEquipment: $mainEquipment, ')
          ..write('lastInspectionDate: $lastInspectionDate, ')
          ..write('nextInspectionDate: $nextInspectionDate, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    clientId,
    address,
    neighborhood,
    housingType,
    bedroomsCount,
    occupancy,
    localContact,
    guardian,
    keysCount,
    mainEquipment,
    lastInspectionDate,
    nextInspectionDate,
    generalCondition,
    notes,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Logement &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.clientId == this.clientId &&
          other.address == this.address &&
          other.neighborhood == this.neighborhood &&
          other.housingType == this.housingType &&
          other.bedroomsCount == this.bedroomsCount &&
          other.occupancy == this.occupancy &&
          other.localContact == this.localContact &&
          other.guardian == this.guardian &&
          other.keysCount == this.keysCount &&
          other.mainEquipment == this.mainEquipment &&
          other.lastInspectionDate == this.lastInspectionDate &&
          other.nextInspectionDate == this.nextInspectionDate &&
          other.generalCondition == this.generalCondition &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class LogementsCompanion extends UpdateCompanion<Logement> {
  final Value<int> id;
  final Value<String> reference;
  final Value<int?> clientId;
  final Value<String> address;
  final Value<String?> neighborhood;
  final Value<String?> housingType;
  final Value<int?> bedroomsCount;
  final Value<String?> occupancy;
  final Value<String?> localContact;
  final Value<String?> guardian;
  final Value<int?> keysCount;
  final Value<String?> mainEquipment;
  final Value<DateTime?> lastInspectionDate;
  final Value<DateTime?> nextInspectionDate;
  final Value<HousingCondition?> generalCondition;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const LogementsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.clientId = const Value.absent(),
    this.address = const Value.absent(),
    this.neighborhood = const Value.absent(),
    this.housingType = const Value.absent(),
    this.bedroomsCount = const Value.absent(),
    this.occupancy = const Value.absent(),
    this.localContact = const Value.absent(),
    this.guardian = const Value.absent(),
    this.keysCount = const Value.absent(),
    this.mainEquipment = const Value.absent(),
    this.lastInspectionDate = const Value.absent(),
    this.nextInspectionDate = const Value.absent(),
    this.generalCondition = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  LogementsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    this.clientId = const Value.absent(),
    required String address,
    this.neighborhood = const Value.absent(),
    this.housingType = const Value.absent(),
    this.bedroomsCount = const Value.absent(),
    this.occupancy = const Value.absent(),
    this.localContact = const Value.absent(),
    this.guardian = const Value.absent(),
    this.keysCount = const Value.absent(),
    this.mainEquipment = const Value.absent(),
    this.lastInspectionDate = const Value.absent(),
    this.nextInspectionDate = const Value.absent(),
    this.generalCondition = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       address = Value(address);
  static Insertable<Logement> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<int>? clientId,
    Expression<String>? address,
    Expression<String>? neighborhood,
    Expression<String>? housingType,
    Expression<int>? bedroomsCount,
    Expression<String>? occupancy,
    Expression<String>? localContact,
    Expression<String>? guardian,
    Expression<int>? keysCount,
    Expression<String>? mainEquipment,
    Expression<DateTime>? lastInspectionDate,
    Expression<DateTime>? nextInspectionDate,
    Expression<String>? generalCondition,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (clientId != null) 'client_id': clientId,
      if (address != null) 'address': address,
      if (neighborhood != null) 'neighborhood': neighborhood,
      if (housingType != null) 'housing_type': housingType,
      if (bedroomsCount != null) 'bedrooms_count': bedroomsCount,
      if (occupancy != null) 'occupancy': occupancy,
      if (localContact != null) 'local_contact': localContact,
      if (guardian != null) 'guardian': guardian,
      if (keysCount != null) 'keys_count': keysCount,
      if (mainEquipment != null) 'main_equipment': mainEquipment,
      if (lastInspectionDate != null)
        'last_inspection_date': lastInspectionDate,
      if (nextInspectionDate != null)
        'next_inspection_date': nextInspectionDate,
      if (generalCondition != null) 'general_condition': generalCondition,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  LogementsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<int?>? clientId,
    Value<String>? address,
    Value<String?>? neighborhood,
    Value<String?>? housingType,
    Value<int?>? bedroomsCount,
    Value<String?>? occupancy,
    Value<String?>? localContact,
    Value<String?>? guardian,
    Value<int?>? keysCount,
    Value<String?>? mainEquipment,
    Value<DateTime?>? lastInspectionDate,
    Value<DateTime?>? nextInspectionDate,
    Value<HousingCondition?>? generalCondition,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return LogementsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      clientId: clientId ?? this.clientId,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      housingType: housingType ?? this.housingType,
      bedroomsCount: bedroomsCount ?? this.bedroomsCount,
      occupancy: occupancy ?? this.occupancy,
      localContact: localContact ?? this.localContact,
      guardian: guardian ?? this.guardian,
      keysCount: keysCount ?? this.keysCount,
      mainEquipment: mainEquipment ?? this.mainEquipment,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      nextInspectionDate: nextInspectionDate ?? this.nextInspectionDate,
      generalCondition: generalCondition ?? this.generalCondition,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (neighborhood.present) {
      map['neighborhood'] = Variable<String>(neighborhood.value);
    }
    if (housingType.present) {
      map['housing_type'] = Variable<String>(housingType.value);
    }
    if (bedroomsCount.present) {
      map['bedrooms_count'] = Variable<int>(bedroomsCount.value);
    }
    if (occupancy.present) {
      map['occupancy'] = Variable<String>(occupancy.value);
    }
    if (localContact.present) {
      map['local_contact'] = Variable<String>(localContact.value);
    }
    if (guardian.present) {
      map['guardian'] = Variable<String>(guardian.value);
    }
    if (keysCount.present) {
      map['keys_count'] = Variable<int>(keysCount.value);
    }
    if (mainEquipment.present) {
      map['main_equipment'] = Variable<String>(mainEquipment.value);
    }
    if (lastInspectionDate.present) {
      map['last_inspection_date'] = Variable<DateTime>(
        lastInspectionDate.value,
      );
    }
    if (nextInspectionDate.present) {
      map['next_inspection_date'] = Variable<DateTime>(
        nextInspectionDate.value,
      );
    }
    if (generalCondition.present) {
      map['general_condition'] = Variable<String>(
        $LogementsTable.$convertergeneralConditionn.toSql(
          generalCondition.value,
        ),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $LogementsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogementsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('clientId: $clientId, ')
          ..write('address: $address, ')
          ..write('neighborhood: $neighborhood, ')
          ..write('housingType: $housingType, ')
          ..write('bedroomsCount: $bedroomsCount, ')
          ..write('occupancy: $occupancy, ')
          ..write('localContact: $localContact, ')
          ..write('guardian: $guardian, ')
          ..write('keysCount: $keysCount, ')
          ..write('mainEquipment: $mainEquipment, ')
          ..write('lastInspectionDate: $lastInspectionDate, ')
          ..write('nextInspectionDate: $nextInspectionDate, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $AbonnementsTable extends Abonnements
    with TableInfo<$AbonnementsTable, Abonnement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AbonnementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _logementIdMeta = const VerificationMeta(
    'logementId',
  );
  @override
  late final GeneratedColumn<int> logementId = GeneratedColumn<int>(
    'logement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES logements (id)',
    ),
  );
  static const VerificationMeta _formulaMeta = const VerificationMeta(
    'formula',
  );
  @override
  late final GeneratedColumn<String> formula = GeneratedColumn<String>(
    'formula',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthlyPriceMeta = const VerificationMeta(
    'monthlyPrice',
  );
  @override
  late final GeneratedColumn<double> monthlyPrice = GeneratedColumn<double>(
    'monthly_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _renewalDateMeta = const VerificationMeta(
    'renewalDate',
  );
  @override
  late final GeneratedColumn<DateTime> renewalDate = GeneratedColumn<DateTime>(
    'renewal_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPaymentDateMeta = const VerificationMeta(
    'lastPaymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> lastPaymentDate =
      GeneratedColumn<DateTime>(
        'last_payment_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextPaymentDateMeta = const VerificationMeta(
    'nextPaymentDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextPaymentDate =
      GeneratedColumn<DateTime>(
        'next_payment_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PaymentStatus, String>
  paymentStatus = GeneratedColumn<String>(
    'payment_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PaymentStatus>($AbonnementsTable.$converterpaymentStatus);
  static const VerificationMeta _lastInspectionDateMeta =
      const VerificationMeta('lastInspectionDate');
  @override
  late final GeneratedColumn<DateTime> lastInspectionDate =
      GeneratedColumn<DateTime>(
        'last_inspection_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextInspectionDateMeta =
      const VerificationMeta('nextInspectionDate');
  @override
  late final GeneratedColumn<DateTime> nextInspectionDate =
      GeneratedColumn<DateTime>(
        'next_inspection_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($AbonnementsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    clientId,
    logementId,
    formula,
    monthlyPrice,
    startDate,
    renewalDate,
    lastPaymentDate,
    nextPaymentDate,
    paymentStatus,
    lastInspectionDate,
    nextInspectionDate,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'abonnements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Abonnement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('logement_id')) {
      context.handle(
        _logementIdMeta,
        logementId.isAcceptableOrUnknown(data['logement_id']!, _logementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logementIdMeta);
    }
    if (data.containsKey('formula')) {
      context.handle(
        _formulaMeta,
        formula.isAcceptableOrUnknown(data['formula']!, _formulaMeta),
      );
    } else if (isInserting) {
      context.missing(_formulaMeta);
    }
    if (data.containsKey('monthly_price')) {
      context.handle(
        _monthlyPriceMeta,
        monthlyPrice.isAcceptableOrUnknown(
          data['monthly_price']!,
          _monthlyPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_monthlyPriceMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('renewal_date')) {
      context.handle(
        _renewalDateMeta,
        renewalDate.isAcceptableOrUnknown(
          data['renewal_date']!,
          _renewalDateMeta,
        ),
      );
    }
    if (data.containsKey('last_payment_date')) {
      context.handle(
        _lastPaymentDateMeta,
        lastPaymentDate.isAcceptableOrUnknown(
          data['last_payment_date']!,
          _lastPaymentDateMeta,
        ),
      );
    }
    if (data.containsKey('next_payment_date')) {
      context.handle(
        _nextPaymentDateMeta,
        nextPaymentDate.isAcceptableOrUnknown(
          data['next_payment_date']!,
          _nextPaymentDateMeta,
        ),
      );
    }
    if (data.containsKey('last_inspection_date')) {
      context.handle(
        _lastInspectionDateMeta,
        lastInspectionDate.isAcceptableOrUnknown(
          data['last_inspection_date']!,
          _lastInspectionDateMeta,
        ),
      );
    }
    if (data.containsKey('next_inspection_date')) {
      context.handle(
        _nextInspectionDateMeta,
        nextInspectionDate.isAcceptableOrUnknown(
          data['next_inspection_date']!,
          _nextInspectionDateMeta,
        ),
      );
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Abonnement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Abonnement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      logementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logement_id'],
      )!,
      formula: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula'],
      )!,
      monthlyPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_price'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      renewalDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}renewal_date'],
      ),
      lastPaymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_payment_date'],
      ),
      nextPaymentDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_payment_date'],
      ),
      paymentStatus: $AbonnementsTable.$converterpaymentStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}payment_status'],
        )!,
      ),
      lastInspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_inspection_date'],
      ),
      nextInspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_inspection_date'],
      ),
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $AbonnementsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $AbonnementsTable createAlias(String alias) {
    return $AbonnementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PaymentStatus, String, String>
  $converterpaymentStatus = const EnumNameConverter<PaymentStatus>(
    PaymentStatus.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Abonnement extends DataClass implements Insertable<Abonnement> {
  final int id;
  final String reference;
  final int clientId;
  final int logementId;
  final String formula;
  final double monthlyPrice;
  final DateTime startDate;
  final DateTime? renewalDate;
  final DateTime? lastPaymentDate;
  final DateTime? nextPaymentDate;
  final PaymentStatus paymentStatus;
  final DateTime? lastInspectionDate;
  final DateTime? nextInspectionDate;
  final String? observations;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Abonnement({
    required this.id,
    required this.reference,
    required this.clientId,
    required this.logementId,
    required this.formula,
    required this.monthlyPrice,
    required this.startDate,
    this.renewalDate,
    this.lastPaymentDate,
    this.nextPaymentDate,
    required this.paymentStatus,
    this.lastInspectionDate,
    this.nextInspectionDate,
    this.observations,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['client_id'] = Variable<int>(clientId);
    map['logement_id'] = Variable<int>(logementId);
    map['formula'] = Variable<String>(formula);
    map['monthly_price'] = Variable<double>(monthlyPrice);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || renewalDate != null) {
      map['renewal_date'] = Variable<DateTime>(renewalDate);
    }
    if (!nullToAbsent || lastPaymentDate != null) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate);
    }
    if (!nullToAbsent || nextPaymentDate != null) {
      map['next_payment_date'] = Variable<DateTime>(nextPaymentDate);
    }
    {
      map['payment_status'] = Variable<String>(
        $AbonnementsTable.$converterpaymentStatus.toSql(paymentStatus),
      );
    }
    if (!nullToAbsent || lastInspectionDate != null) {
      map['last_inspection_date'] = Variable<DateTime>(lastInspectionDate);
    }
    if (!nullToAbsent || nextInspectionDate != null) {
      map['next_inspection_date'] = Variable<DateTime>(nextInspectionDate);
    }
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $AbonnementsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  AbonnementsCompanion toCompanion(bool nullToAbsent) {
    return AbonnementsCompanion(
      id: Value(id),
      reference: Value(reference),
      clientId: Value(clientId),
      logementId: Value(logementId),
      formula: Value(formula),
      monthlyPrice: Value(monthlyPrice),
      startDate: Value(startDate),
      renewalDate: renewalDate == null && nullToAbsent
          ? const Value.absent()
          : Value(renewalDate),
      lastPaymentDate: lastPaymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPaymentDate),
      nextPaymentDate: nextPaymentDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextPaymentDate),
      paymentStatus: Value(paymentStatus),
      lastInspectionDate: lastInspectionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInspectionDate),
      nextInspectionDate: nextInspectionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(nextInspectionDate),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Abonnement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Abonnement(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      clientId: serializer.fromJson<int>(json['clientId']),
      logementId: serializer.fromJson<int>(json['logementId']),
      formula: serializer.fromJson<String>(json['formula']),
      monthlyPrice: serializer.fromJson<double>(json['monthlyPrice']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      renewalDate: serializer.fromJson<DateTime?>(json['renewalDate']),
      lastPaymentDate: serializer.fromJson<DateTime?>(json['lastPaymentDate']),
      nextPaymentDate: serializer.fromJson<DateTime?>(json['nextPaymentDate']),
      paymentStatus: $AbonnementsTable.$converterpaymentStatus.fromJson(
        serializer.fromJson<String>(json['paymentStatus']),
      ),
      lastInspectionDate: serializer.fromJson<DateTime?>(
        json['lastInspectionDate'],
      ),
      nextInspectionDate: serializer.fromJson<DateTime?>(
        json['nextInspectionDate'],
      ),
      observations: serializer.fromJson<String?>(json['observations']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $AbonnementsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'clientId': serializer.toJson<int>(clientId),
      'logementId': serializer.toJson<int>(logementId),
      'formula': serializer.toJson<String>(formula),
      'monthlyPrice': serializer.toJson<double>(monthlyPrice),
      'startDate': serializer.toJson<DateTime>(startDate),
      'renewalDate': serializer.toJson<DateTime?>(renewalDate),
      'lastPaymentDate': serializer.toJson<DateTime?>(lastPaymentDate),
      'nextPaymentDate': serializer.toJson<DateTime?>(nextPaymentDate),
      'paymentStatus': serializer.toJson<String>(
        $AbonnementsTable.$converterpaymentStatus.toJson(paymentStatus),
      ),
      'lastInspectionDate': serializer.toJson<DateTime?>(lastInspectionDate),
      'nextInspectionDate': serializer.toJson<DateTime?>(nextInspectionDate),
      'observations': serializer.toJson<String?>(observations),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $AbonnementsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Abonnement copyWith({
    int? id,
    String? reference,
    int? clientId,
    int? logementId,
    String? formula,
    double? monthlyPrice,
    DateTime? startDate,
    Value<DateTime?> renewalDate = const Value.absent(),
    Value<DateTime?> lastPaymentDate = const Value.absent(),
    Value<DateTime?> nextPaymentDate = const Value.absent(),
    PaymentStatus? paymentStatus,
    Value<DateTime?> lastInspectionDate = const Value.absent(),
    Value<DateTime?> nextInspectionDate = const Value.absent(),
    Value<String?> observations = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Abonnement(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    clientId: clientId ?? this.clientId,
    logementId: logementId ?? this.logementId,
    formula: formula ?? this.formula,
    monthlyPrice: monthlyPrice ?? this.monthlyPrice,
    startDate: startDate ?? this.startDate,
    renewalDate: renewalDate.present ? renewalDate.value : this.renewalDate,
    lastPaymentDate: lastPaymentDate.present
        ? lastPaymentDate.value
        : this.lastPaymentDate,
    nextPaymentDate: nextPaymentDate.present
        ? nextPaymentDate.value
        : this.nextPaymentDate,
    paymentStatus: paymentStatus ?? this.paymentStatus,
    lastInspectionDate: lastInspectionDate.present
        ? lastInspectionDate.value
        : this.lastInspectionDate,
    nextInspectionDate: nextInspectionDate.present
        ? nextInspectionDate.value
        : this.nextInspectionDate,
    observations: observations.present ? observations.value : this.observations,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Abonnement copyWithCompanion(AbonnementsCompanion data) {
    return Abonnement(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      logementId: data.logementId.present
          ? data.logementId.value
          : this.logementId,
      formula: data.formula.present ? data.formula.value : this.formula,
      monthlyPrice: data.monthlyPrice.present
          ? data.monthlyPrice.value
          : this.monthlyPrice,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      renewalDate: data.renewalDate.present
          ? data.renewalDate.value
          : this.renewalDate,
      lastPaymentDate: data.lastPaymentDate.present
          ? data.lastPaymentDate.value
          : this.lastPaymentDate,
      nextPaymentDate: data.nextPaymentDate.present
          ? data.nextPaymentDate.value
          : this.nextPaymentDate,
      paymentStatus: data.paymentStatus.present
          ? data.paymentStatus.value
          : this.paymentStatus,
      lastInspectionDate: data.lastInspectionDate.present
          ? data.lastInspectionDate.value
          : this.lastInspectionDate,
      nextInspectionDate: data.nextInspectionDate.present
          ? data.nextInspectionDate.value
          : this.nextInspectionDate,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Abonnement(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('clientId: $clientId, ')
          ..write('logementId: $logementId, ')
          ..write('formula: $formula, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('startDate: $startDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('lastInspectionDate: $lastInspectionDate, ')
          ..write('nextInspectionDate: $nextInspectionDate, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    clientId,
    logementId,
    formula,
    monthlyPrice,
    startDate,
    renewalDate,
    lastPaymentDate,
    nextPaymentDate,
    paymentStatus,
    lastInspectionDate,
    nextInspectionDate,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Abonnement &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.clientId == this.clientId &&
          other.logementId == this.logementId &&
          other.formula == this.formula &&
          other.monthlyPrice == this.monthlyPrice &&
          other.startDate == this.startDate &&
          other.renewalDate == this.renewalDate &&
          other.lastPaymentDate == this.lastPaymentDate &&
          other.nextPaymentDate == this.nextPaymentDate &&
          other.paymentStatus == this.paymentStatus &&
          other.lastInspectionDate == this.lastInspectionDate &&
          other.nextInspectionDate == this.nextInspectionDate &&
          other.observations == this.observations &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class AbonnementsCompanion extends UpdateCompanion<Abonnement> {
  final Value<int> id;
  final Value<String> reference;
  final Value<int> clientId;
  final Value<int> logementId;
  final Value<String> formula;
  final Value<double> monthlyPrice;
  final Value<DateTime> startDate;
  final Value<DateTime?> renewalDate;
  final Value<DateTime?> lastPaymentDate;
  final Value<DateTime?> nextPaymentDate;
  final Value<PaymentStatus> paymentStatus;
  final Value<DateTime?> lastInspectionDate;
  final Value<DateTime?> nextInspectionDate;
  final Value<String?> observations;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const AbonnementsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.clientId = const Value.absent(),
    this.logementId = const Value.absent(),
    this.formula = const Value.absent(),
    this.monthlyPrice = const Value.absent(),
    this.startDate = const Value.absent(),
    this.renewalDate = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.nextPaymentDate = const Value.absent(),
    this.paymentStatus = const Value.absent(),
    this.lastInspectionDate = const Value.absent(),
    this.nextInspectionDate = const Value.absent(),
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  AbonnementsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required int clientId,
    required int logementId,
    required String formula,
    required double monthlyPrice,
    required DateTime startDate,
    this.renewalDate = const Value.absent(),
    this.lastPaymentDate = const Value.absent(),
    this.nextPaymentDate = const Value.absent(),
    required PaymentStatus paymentStatus,
    this.lastInspectionDate = const Value.absent(),
    this.nextInspectionDate = const Value.absent(),
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       clientId = Value(clientId),
       logementId = Value(logementId),
       formula = Value(formula),
       monthlyPrice = Value(monthlyPrice),
       startDate = Value(startDate),
       paymentStatus = Value(paymentStatus);
  static Insertable<Abonnement> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<int>? clientId,
    Expression<int>? logementId,
    Expression<String>? formula,
    Expression<double>? monthlyPrice,
    Expression<DateTime>? startDate,
    Expression<DateTime>? renewalDate,
    Expression<DateTime>? lastPaymentDate,
    Expression<DateTime>? nextPaymentDate,
    Expression<String>? paymentStatus,
    Expression<DateTime>? lastInspectionDate,
    Expression<DateTime>? nextInspectionDate,
    Expression<String>? observations,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (clientId != null) 'client_id': clientId,
      if (logementId != null) 'logement_id': logementId,
      if (formula != null) 'formula': formula,
      if (monthlyPrice != null) 'monthly_price': monthlyPrice,
      if (startDate != null) 'start_date': startDate,
      if (renewalDate != null) 'renewal_date': renewalDate,
      if (lastPaymentDate != null) 'last_payment_date': lastPaymentDate,
      if (nextPaymentDate != null) 'next_payment_date': nextPaymentDate,
      if (paymentStatus != null) 'payment_status': paymentStatus,
      if (lastInspectionDate != null)
        'last_inspection_date': lastInspectionDate,
      if (nextInspectionDate != null)
        'next_inspection_date': nextInspectionDate,
      if (observations != null) 'observations': observations,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  AbonnementsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<int>? clientId,
    Value<int>? logementId,
    Value<String>? formula,
    Value<double>? monthlyPrice,
    Value<DateTime>? startDate,
    Value<DateTime?>? renewalDate,
    Value<DateTime?>? lastPaymentDate,
    Value<DateTime?>? nextPaymentDate,
    Value<PaymentStatus>? paymentStatus,
    Value<DateTime?>? lastInspectionDate,
    Value<DateTime?>? nextInspectionDate,
    Value<String?>? observations,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return AbonnementsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      clientId: clientId ?? this.clientId,
      logementId: logementId ?? this.logementId,
      formula: formula ?? this.formula,
      monthlyPrice: monthlyPrice ?? this.monthlyPrice,
      startDate: startDate ?? this.startDate,
      renewalDate: renewalDate ?? this.renewalDate,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      lastInspectionDate: lastInspectionDate ?? this.lastInspectionDate,
      nextInspectionDate: nextInspectionDate ?? this.nextInspectionDate,
      observations: observations ?? this.observations,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (logementId.present) {
      map['logement_id'] = Variable<int>(logementId.value);
    }
    if (formula.present) {
      map['formula'] = Variable<String>(formula.value);
    }
    if (monthlyPrice.present) {
      map['monthly_price'] = Variable<double>(monthlyPrice.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (renewalDate.present) {
      map['renewal_date'] = Variable<DateTime>(renewalDate.value);
    }
    if (lastPaymentDate.present) {
      map['last_payment_date'] = Variable<DateTime>(lastPaymentDate.value);
    }
    if (nextPaymentDate.present) {
      map['next_payment_date'] = Variable<DateTime>(nextPaymentDate.value);
    }
    if (paymentStatus.present) {
      map['payment_status'] = Variable<String>(
        $AbonnementsTable.$converterpaymentStatus.toSql(paymentStatus.value),
      );
    }
    if (lastInspectionDate.present) {
      map['last_inspection_date'] = Variable<DateTime>(
        lastInspectionDate.value,
      );
    }
    if (nextInspectionDate.present) {
      map['next_inspection_date'] = Variable<DateTime>(
        nextInspectionDate.value,
      );
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $AbonnementsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AbonnementsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('clientId: $clientId, ')
          ..write('logementId: $logementId, ')
          ..write('formula: $formula, ')
          ..write('monthlyPrice: $monthlyPrice, ')
          ..write('startDate: $startDate, ')
          ..write('renewalDate: $renewalDate, ')
          ..write('lastPaymentDate: $lastPaymentDate, ')
          ..write('nextPaymentDate: $nextPaymentDate, ')
          ..write('paymentStatus: $paymentStatus, ')
          ..write('lastInspectionDate: $lastInspectionDate, ')
          ..write('nextInspectionDate: $nextInspectionDate, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $InspectionsTable extends Inspections
    with TableInfo<$InspectionsTable, Inspection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _logementIdMeta = const VerificationMeta(
    'logementId',
  );
  @override
  late final GeneratedColumn<int> logementId = GeneratedColumn<int>(
    'logement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES logements (id)',
    ),
  );
  static const VerificationMeta _agentUserIdMeta = const VerificationMeta(
    'agentUserId',
  );
  @override
  late final GeneratedColumn<int> agentUserId = GeneratedColumn<int>(
    'agent_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inspectionDateMeta = const VerificationMeta(
    'inspectionDate',
  );
  @override
  late final GeneratedColumn<DateTime> inspectionDate =
      GeneratedColumn<DateTime>(
        'inspection_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<HousingCondition?, String>
  generalCondition =
      GeneratedColumn<String>(
        'general_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HousingCondition?>(
        $InspectionsTable.$convertergeneralConditionn,
      );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isValidatedMeta = const VerificationMeta(
    'isValidated',
  );
  @override
  late final GeneratedColumn<bool> isValidated = GeneratedColumn<bool>(
    'is_validated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_validated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _validatedAtMeta = const VerificationMeta(
    'validatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> validatedAt = GeneratedColumn<DateTime>(
    'validated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($InspectionsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    logementId,
    agentUserId,
    inspectionDate,
    generalCondition,
    recommendations,
    isValidated,
    validatedAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspections';
  @override
  VerificationContext validateIntegrity(
    Insertable<Inspection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('logement_id')) {
      context.handle(
        _logementIdMeta,
        logementId.isAcceptableOrUnknown(data['logement_id']!, _logementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logementIdMeta);
    }
    if (data.containsKey('agent_user_id')) {
      context.handle(
        _agentUserIdMeta,
        agentUserId.isAcceptableOrUnknown(
          data['agent_user_id']!,
          _agentUserIdMeta,
        ),
      );
    }
    if (data.containsKey('inspection_date')) {
      context.handle(
        _inspectionDateMeta,
        inspectionDate.isAcceptableOrUnknown(
          data['inspection_date']!,
          _inspectionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionDateMeta);
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    }
    if (data.containsKey('is_validated')) {
      context.handle(
        _isValidatedMeta,
        isValidated.isAcceptableOrUnknown(
          data['is_validated']!,
          _isValidatedMeta,
        ),
      );
    }
    if (data.containsKey('validated_at')) {
      context.handle(
        _validatedAtMeta,
        validatedAt.isAcceptableOrUnknown(
          data['validated_at']!,
          _validatedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Inspection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Inspection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      logementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logement_id'],
      )!,
      agentUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}agent_user_id'],
      ),
      inspectionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}inspection_date'],
      )!,
      generalCondition: $InspectionsTable.$convertergeneralConditionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}general_condition'],
        ),
      ),
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      ),
      isValidated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_validated'],
      )!,
      validatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}validated_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $InspectionsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $InspectionsTable createAlias(String alias) {
    return $InspectionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HousingCondition, String, String>
  $convertergeneralCondition = const EnumNameConverter<HousingCondition>(
    HousingCondition.values,
  );
  static JsonTypeConverter2<HousingCondition?, String?, String?>
  $convertergeneralConditionn = JsonTypeConverter2.asNullable(
    $convertergeneralCondition,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Inspection extends DataClass implements Insertable<Inspection> {
  final int id;
  final String reference;
  final int logementId;
  final int? agentUserId;
  final DateTime inspectionDate;
  final HousingCondition? generalCondition;
  final String? recommendations;
  final bool isValidated;
  final DateTime? validatedAt;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Inspection({
    required this.id,
    required this.reference,
    required this.logementId,
    this.agentUserId,
    required this.inspectionDate,
    this.generalCondition,
    this.recommendations,
    required this.isValidated,
    this.validatedAt,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['logement_id'] = Variable<int>(logementId);
    if (!nullToAbsent || agentUserId != null) {
      map['agent_user_id'] = Variable<int>(agentUserId);
    }
    map['inspection_date'] = Variable<DateTime>(inspectionDate);
    if (!nullToAbsent || generalCondition != null) {
      map['general_condition'] = Variable<String>(
        $InspectionsTable.$convertergeneralConditionn.toSql(generalCondition),
      );
    }
    if (!nullToAbsent || recommendations != null) {
      map['recommendations'] = Variable<String>(recommendations);
    }
    map['is_validated'] = Variable<bool>(isValidated);
    if (!nullToAbsent || validatedAt != null) {
      map['validated_at'] = Variable<DateTime>(validatedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $InspectionsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  InspectionsCompanion toCompanion(bool nullToAbsent) {
    return InspectionsCompanion(
      id: Value(id),
      reference: Value(reference),
      logementId: Value(logementId),
      agentUserId: agentUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(agentUserId),
      inspectionDate: Value(inspectionDate),
      generalCondition: generalCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(generalCondition),
      recommendations: recommendations == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendations),
      isValidated: Value(isValidated),
      validatedAt: validatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(validatedAt),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Inspection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Inspection(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      logementId: serializer.fromJson<int>(json['logementId']),
      agentUserId: serializer.fromJson<int?>(json['agentUserId']),
      inspectionDate: serializer.fromJson<DateTime>(json['inspectionDate']),
      generalCondition: $InspectionsTable.$convertergeneralConditionn.fromJson(
        serializer.fromJson<String?>(json['generalCondition']),
      ),
      recommendations: serializer.fromJson<String?>(json['recommendations']),
      isValidated: serializer.fromJson<bool>(json['isValidated']),
      validatedAt: serializer.fromJson<DateTime?>(json['validatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $InspectionsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'logementId': serializer.toJson<int>(logementId),
      'agentUserId': serializer.toJson<int?>(agentUserId),
      'inspectionDate': serializer.toJson<DateTime>(inspectionDate),
      'generalCondition': serializer.toJson<String?>(
        $InspectionsTable.$convertergeneralConditionn.toJson(generalCondition),
      ),
      'recommendations': serializer.toJson<String?>(recommendations),
      'isValidated': serializer.toJson<bool>(isValidated),
      'validatedAt': serializer.toJson<DateTime?>(validatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $InspectionsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Inspection copyWith({
    int? id,
    String? reference,
    int? logementId,
    Value<int?> agentUserId = const Value.absent(),
    DateTime? inspectionDate,
    Value<HousingCondition?> generalCondition = const Value.absent(),
    Value<String?> recommendations = const Value.absent(),
    bool? isValidated,
    Value<DateTime?> validatedAt = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Inspection(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    logementId: logementId ?? this.logementId,
    agentUserId: agentUserId.present ? agentUserId.value : this.agentUserId,
    inspectionDate: inspectionDate ?? this.inspectionDate,
    generalCondition: generalCondition.present
        ? generalCondition.value
        : this.generalCondition,
    recommendations: recommendations.present
        ? recommendations.value
        : this.recommendations,
    isValidated: isValidated ?? this.isValidated,
    validatedAt: validatedAt.present ? validatedAt.value : this.validatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Inspection copyWithCompanion(InspectionsCompanion data) {
    return Inspection(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      logementId: data.logementId.present
          ? data.logementId.value
          : this.logementId,
      agentUserId: data.agentUserId.present
          ? data.agentUserId.value
          : this.agentUserId,
      inspectionDate: data.inspectionDate.present
          ? data.inspectionDate.value
          : this.inspectionDate,
      generalCondition: data.generalCondition.present
          ? data.generalCondition.value
          : this.generalCondition,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      isValidated: data.isValidated.present
          ? data.isValidated.value
          : this.isValidated,
      validatedAt: data.validatedAt.present
          ? data.validatedAt.value
          : this.validatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Inspection(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('agentUserId: $agentUserId, ')
          ..write('inspectionDate: $inspectionDate, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('recommendations: $recommendations, ')
          ..write('isValidated: $isValidated, ')
          ..write('validatedAt: $validatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    logementId,
    agentUserId,
    inspectionDate,
    generalCondition,
    recommendations,
    isValidated,
    validatedAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Inspection &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.logementId == this.logementId &&
          other.agentUserId == this.agentUserId &&
          other.inspectionDate == this.inspectionDate &&
          other.generalCondition == this.generalCondition &&
          other.recommendations == this.recommendations &&
          other.isValidated == this.isValidated &&
          other.validatedAt == this.validatedAt &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class InspectionsCompanion extends UpdateCompanion<Inspection> {
  final Value<int> id;
  final Value<String> reference;
  final Value<int> logementId;
  final Value<int?> agentUserId;
  final Value<DateTime> inspectionDate;
  final Value<HousingCondition?> generalCondition;
  final Value<String?> recommendations;
  final Value<bool> isValidated;
  final Value<DateTime?> validatedAt;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const InspectionsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.logementId = const Value.absent(),
    this.agentUserId = const Value.absent(),
    this.inspectionDate = const Value.absent(),
    this.generalCondition = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.isValidated = const Value.absent(),
    this.validatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  InspectionsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required int logementId,
    this.agentUserId = const Value.absent(),
    required DateTime inspectionDate,
    this.generalCondition = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.isValidated = const Value.absent(),
    this.validatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       logementId = Value(logementId),
       inspectionDate = Value(inspectionDate);
  static Insertable<Inspection> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<int>? logementId,
    Expression<int>? agentUserId,
    Expression<DateTime>? inspectionDate,
    Expression<String>? generalCondition,
    Expression<String>? recommendations,
    Expression<bool>? isValidated,
    Expression<DateTime>? validatedAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (logementId != null) 'logement_id': logementId,
      if (agentUserId != null) 'agent_user_id': agentUserId,
      if (inspectionDate != null) 'inspection_date': inspectionDate,
      if (generalCondition != null) 'general_condition': generalCondition,
      if (recommendations != null) 'recommendations': recommendations,
      if (isValidated != null) 'is_validated': isValidated,
      if (validatedAt != null) 'validated_at': validatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  InspectionsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<int>? logementId,
    Value<int?>? agentUserId,
    Value<DateTime>? inspectionDate,
    Value<HousingCondition?>? generalCondition,
    Value<String?>? recommendations,
    Value<bool>? isValidated,
    Value<DateTime?>? validatedAt,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return InspectionsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      logementId: logementId ?? this.logementId,
      agentUserId: agentUserId ?? this.agentUserId,
      inspectionDate: inspectionDate ?? this.inspectionDate,
      generalCondition: generalCondition ?? this.generalCondition,
      recommendations: recommendations ?? this.recommendations,
      isValidated: isValidated ?? this.isValidated,
      validatedAt: validatedAt ?? this.validatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (logementId.present) {
      map['logement_id'] = Variable<int>(logementId.value);
    }
    if (agentUserId.present) {
      map['agent_user_id'] = Variable<int>(agentUserId.value);
    }
    if (inspectionDate.present) {
      map['inspection_date'] = Variable<DateTime>(inspectionDate.value);
    }
    if (generalCondition.present) {
      map['general_condition'] = Variable<String>(
        $InspectionsTable.$convertergeneralConditionn.toSql(
          generalCondition.value,
        ),
      );
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (isValidated.present) {
      map['is_validated'] = Variable<bool>(isValidated.value);
    }
    if (validatedAt.present) {
      map['validated_at'] = Variable<DateTime>(validatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $InspectionsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('agentUserId: $agentUserId, ')
          ..write('inspectionDate: $inspectionDate, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('recommendations: $recommendations, ')
          ..write('isValidated: $isValidated, ')
          ..write('validatedAt: $validatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $InspectionItemsTable extends InspectionItems
    with TableInfo<$InspectionItemsTable, InspectionItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InspectionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<int> inspectionId = GeneratedColumn<int>(
    'inspection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<InspectionCategory, String>
  category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<InspectionCategory>($InspectionItemsTable.$convertercategory);
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOkMeta = const VerificationMeta('isOk');
  @override
  late final GeneratedColumn<bool> isOk = GeneratedColumn<bool>(
    'is_ok',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ok" IN (0, 1))',
    ),
  );
  static const VerificationMeta _observationMeta = const VerificationMeta(
    'observation',
  );
  @override
  late final GeneratedColumn<String> observation = GeneratedColumn<String>(
    'observation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($InspectionItemsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    inspectionId,
    category,
    label,
    isOk,
    observation,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inspection_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InspectionItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inspectionIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('is_ok')) {
      context.handle(
        _isOkMeta,
        isOk.isAcceptableOrUnknown(data['is_ok']!, _isOkMeta),
      );
    }
    if (data.containsKey('observation')) {
      context.handle(
        _observationMeta,
        observation.isAcceptableOrUnknown(
          data['observation']!,
          _observationMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InspectionItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InspectionItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inspection_id'],
      )!,
      category: $InspectionItemsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}category'],
        )!,
      ),
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      isOk: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ok'],
      ),
      observation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observation'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $InspectionItemsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $InspectionItemsTable createAlias(String alias) {
    return $InspectionItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<InspectionCategory, String, String>
  $convertercategory = const EnumNameConverter<InspectionCategory>(
    InspectionCategory.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class InspectionItem extends DataClass implements Insertable<InspectionItem> {
  final int id;
  final int inspectionId;
  final InspectionCategory category;
  final String label;
  final bool? isOk;
  final String? observation;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const InspectionItem({
    required this.id,
    required this.inspectionId,
    required this.category,
    required this.label,
    this.isOk,
    this.observation,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['inspection_id'] = Variable<int>(inspectionId);
    {
      map['category'] = Variable<String>(
        $InspectionItemsTable.$convertercategory.toSql(category),
      );
    }
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || isOk != null) {
      map['is_ok'] = Variable<bool>(isOk);
    }
    if (!nullToAbsent || observation != null) {
      map['observation'] = Variable<String>(observation);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $InspectionItemsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  InspectionItemsCompanion toCompanion(bool nullToAbsent) {
    return InspectionItemsCompanion(
      id: Value(id),
      inspectionId: Value(inspectionId),
      category: Value(category),
      label: Value(label),
      isOk: isOk == null && nullToAbsent ? const Value.absent() : Value(isOk),
      observation: observation == null && nullToAbsent
          ? const Value.absent()
          : Value(observation),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory InspectionItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InspectionItem(
      id: serializer.fromJson<int>(json['id']),
      inspectionId: serializer.fromJson<int>(json['inspectionId']),
      category: $InspectionItemsTable.$convertercategory.fromJson(
        serializer.fromJson<String>(json['category']),
      ),
      label: serializer.fromJson<String>(json['label']),
      isOk: serializer.fromJson<bool?>(json['isOk']),
      observation: serializer.fromJson<String?>(json['observation']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $InspectionItemsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'inspectionId': serializer.toJson<int>(inspectionId),
      'category': serializer.toJson<String>(
        $InspectionItemsTable.$convertercategory.toJson(category),
      ),
      'label': serializer.toJson<String>(label),
      'isOk': serializer.toJson<bool?>(isOk),
      'observation': serializer.toJson<String?>(observation),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $InspectionItemsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  InspectionItem copyWith({
    int? id,
    int? inspectionId,
    InspectionCategory? category,
    String? label,
    Value<bool?> isOk = const Value.absent(),
    Value<String?> observation = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => InspectionItem(
    id: id ?? this.id,
    inspectionId: inspectionId ?? this.inspectionId,
    category: category ?? this.category,
    label: label ?? this.label,
    isOk: isOk.present ? isOk.value : this.isOk,
    observation: observation.present ? observation.value : this.observation,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  InspectionItem copyWithCompanion(InspectionItemsCompanion data) {
    return InspectionItem(
      id: data.id.present ? data.id.value : this.id,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      category: data.category.present ? data.category.value : this.category,
      label: data.label.present ? data.label.value : this.label,
      isOk: data.isOk.present ? data.isOk.value : this.isOk,
      observation: data.observation.present
          ? data.observation.value
          : this.observation,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItem(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('isOk: $isOk, ')
          ..write('observation: $observation, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    inspectionId,
    category,
    label,
    isOk,
    observation,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InspectionItem &&
          other.id == this.id &&
          other.inspectionId == this.inspectionId &&
          other.category == this.category &&
          other.label == this.label &&
          other.isOk == this.isOk &&
          other.observation == this.observation &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class InspectionItemsCompanion extends UpdateCompanion<InspectionItem> {
  final Value<int> id;
  final Value<int> inspectionId;
  final Value<InspectionCategory> category;
  final Value<String> label;
  final Value<bool?> isOk;
  final Value<String?> observation;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const InspectionItemsCompanion({
    this.id = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.category = const Value.absent(),
    this.label = const Value.absent(),
    this.isOk = const Value.absent(),
    this.observation = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  InspectionItemsCompanion.insert({
    this.id = const Value.absent(),
    required int inspectionId,
    required InspectionCategory category,
    required String label,
    this.isOk = const Value.absent(),
    this.observation = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : inspectionId = Value(inspectionId),
       category = Value(category),
       label = Value(label);
  static Insertable<InspectionItem> custom({
    Expression<int>? id,
    Expression<int>? inspectionId,
    Expression<String>? category,
    Expression<String>? label,
    Expression<bool>? isOk,
    Expression<String>? observation,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (category != null) 'category': category,
      if (label != null) 'label': label,
      if (isOk != null) 'is_ok': isOk,
      if (observation != null) 'observation': observation,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  InspectionItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? inspectionId,
    Value<InspectionCategory>? category,
    Value<String>? label,
    Value<bool?>? isOk,
    Value<String?>? observation,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return InspectionItemsCompanion(
      id: id ?? this.id,
      inspectionId: inspectionId ?? this.inspectionId,
      category: category ?? this.category,
      label: label ?? this.label,
      isOk: isOk ?? this.isOk,
      observation: observation ?? this.observation,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<int>(inspectionId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(
        $InspectionItemsTable.$convertercategory.toSql(category.value),
      );
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (isOk.present) {
      map['is_ok'] = Variable<bool>(isOk.value);
    }
    if (observation.present) {
      map['observation'] = Variable<String>(observation.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $InspectionItemsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InspectionItemsCompanion(')
          ..write('id: $id, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('category: $category, ')
          ..write('label: $label, ')
          ..write('isOk: $isOk, ')
          ..write('observation: $observation, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $PrestatairesTable extends Prestataires
    with TableInfo<$PrestatairesTable, Prestataire> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrestatairesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _specialtyMeta = const VerificationMeta(
    'specialty',
  );
  @override
  late final GeneratedColumn<String> specialty = GeneratedColumn<String>(
    'specialty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _zoneMeta = const VerificationMeta('zone');
  @override
  late final GeneratedColumn<String> zone = GeneratedColumn<String>(
    'zone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _experienceYearsMeta = const VerificationMeta(
    'experienceYears',
  );
  @override
  late final GeneratedColumn<int> experienceYears = GeneratedColumn<int>(
    'experience_years',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _identityVerifiedMeta = const VerificationMeta(
    'identityVerified',
  );
  @override
  late final GeneratedColumn<bool> identityVerified = GeneratedColumn<bool>(
    'identity_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("identity_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _referencesVerifiedMeta =
      const VerificationMeta('referencesVerified');
  @override
  late final GeneratedColumn<bool> referencesVerified = GeneratedColumn<bool>(
    'references_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("references_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _indicativeRateMeta = const VerificationMeta(
    'indicativeRate',
  );
  @override
  late final GeneratedColumn<double> indicativeRate = GeneratedColumn<double>(
    'indicative_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityRatingMeta = const VerificationMeta(
    'qualityRating',
  );
  @override
  late final GeneratedColumn<double> qualityRating = GeneratedColumn<double>(
    'quality_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _punctualityRatingMeta = const VerificationMeta(
    'punctualityRating',
  );
  @override
  late final GeneratedColumn<double> punctualityRating =
      GeneratedColumn<double>(
        'punctuality_rating',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _communicationRatingMeta =
      const VerificationMeta('communicationRating');
  @override
  late final GeneratedColumn<double> communicationRating =
      GeneratedColumn<double>(
        'communication_rating',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<PrestataireStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<PrestataireStatus>($PrestatairesTable.$converterstatus);
  static const VerificationMeta _interventionsCountMeta =
      const VerificationMeta('interventionsCount');
  @override
  late final GeneratedColumn<int> interventionsCount = GeneratedColumn<int>(
    'interventions_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastInterventionDateMeta =
      const VerificationMeta('lastInterventionDate');
  @override
  late final GeneratedColumn<DateTime> lastInterventionDate =
      GeneratedColumn<DateTime>(
        'last_intervention_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($PrestatairesTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    fullName,
    phone,
    specialty,
    zone,
    experienceYears,
    identityVerified,
    referencesVerified,
    indicativeRate,
    qualityRating,
    punctualityRating,
    communicationRating,
    status,
    interventionsCount,
    lastInterventionDate,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'prestataires';
  @override
  VerificationContext validateIntegrity(
    Insertable<Prestataire> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('specialty')) {
      context.handle(
        _specialtyMeta,
        specialty.isAcceptableOrUnknown(data['specialty']!, _specialtyMeta),
      );
    } else if (isInserting) {
      context.missing(_specialtyMeta);
    }
    if (data.containsKey('zone')) {
      context.handle(
        _zoneMeta,
        zone.isAcceptableOrUnknown(data['zone']!, _zoneMeta),
      );
    }
    if (data.containsKey('experience_years')) {
      context.handle(
        _experienceYearsMeta,
        experienceYears.isAcceptableOrUnknown(
          data['experience_years']!,
          _experienceYearsMeta,
        ),
      );
    }
    if (data.containsKey('identity_verified')) {
      context.handle(
        _identityVerifiedMeta,
        identityVerified.isAcceptableOrUnknown(
          data['identity_verified']!,
          _identityVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('references_verified')) {
      context.handle(
        _referencesVerifiedMeta,
        referencesVerified.isAcceptableOrUnknown(
          data['references_verified']!,
          _referencesVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('indicative_rate')) {
      context.handle(
        _indicativeRateMeta,
        indicativeRate.isAcceptableOrUnknown(
          data['indicative_rate']!,
          _indicativeRateMeta,
        ),
      );
    }
    if (data.containsKey('quality_rating')) {
      context.handle(
        _qualityRatingMeta,
        qualityRating.isAcceptableOrUnknown(
          data['quality_rating']!,
          _qualityRatingMeta,
        ),
      );
    }
    if (data.containsKey('punctuality_rating')) {
      context.handle(
        _punctualityRatingMeta,
        punctualityRating.isAcceptableOrUnknown(
          data['punctuality_rating']!,
          _punctualityRatingMeta,
        ),
      );
    }
    if (data.containsKey('communication_rating')) {
      context.handle(
        _communicationRatingMeta,
        communicationRating.isAcceptableOrUnknown(
          data['communication_rating']!,
          _communicationRatingMeta,
        ),
      );
    }
    if (data.containsKey('interventions_count')) {
      context.handle(
        _interventionsCountMeta,
        interventionsCount.isAcceptableOrUnknown(
          data['interventions_count']!,
          _interventionsCountMeta,
        ),
      );
    }
    if (data.containsKey('last_intervention_date')) {
      context.handle(
        _lastInterventionDateMeta,
        lastInterventionDate.isAcceptableOrUnknown(
          data['last_intervention_date']!,
          _lastInterventionDateMeta,
        ),
      );
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Prestataire map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Prestataire(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      specialty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}specialty'],
      )!,
      zone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zone'],
      ),
      experienceYears: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}experience_years'],
      ),
      identityVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}identity_verified'],
      )!,
      referencesVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}references_verified'],
      )!,
      indicativeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}indicative_rate'],
      ),
      qualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quality_rating'],
      ),
      punctualityRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}punctuality_rating'],
      ),
      communicationRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}communication_rating'],
      ),
      status: $PrestatairesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      interventionsCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interventions_count'],
      )!,
      lastInterventionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_intervention_date'],
      ),
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $PrestatairesTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $PrestatairesTable createAlias(String alias) {
    return $PrestatairesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PrestataireStatus, String, String>
  $converterstatus = const EnumNameConverter<PrestataireStatus>(
    PrestataireStatus.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Prestataire extends DataClass implements Insertable<Prestataire> {
  final int id;
  final String reference;
  final String fullName;
  final String phone;
  final String specialty;
  final String? zone;
  final int? experienceYears;
  final bool identityVerified;
  final bool referencesVerified;
  final double? indicativeRate;
  final double? qualityRating;
  final double? punctualityRating;
  final double? communicationRating;
  final PrestataireStatus status;
  final int interventionsCount;
  final DateTime? lastInterventionDate;
  final String? observations;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Prestataire({
    required this.id,
    required this.reference,
    required this.fullName,
    required this.phone,
    required this.specialty,
    this.zone,
    this.experienceYears,
    required this.identityVerified,
    required this.referencesVerified,
    this.indicativeRate,
    this.qualityRating,
    this.punctualityRating,
    this.communicationRating,
    required this.status,
    required this.interventionsCount,
    this.lastInterventionDate,
    this.observations,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['full_name'] = Variable<String>(fullName);
    map['phone'] = Variable<String>(phone);
    map['specialty'] = Variable<String>(specialty);
    if (!nullToAbsent || zone != null) {
      map['zone'] = Variable<String>(zone);
    }
    if (!nullToAbsent || experienceYears != null) {
      map['experience_years'] = Variable<int>(experienceYears);
    }
    map['identity_verified'] = Variable<bool>(identityVerified);
    map['references_verified'] = Variable<bool>(referencesVerified);
    if (!nullToAbsent || indicativeRate != null) {
      map['indicative_rate'] = Variable<double>(indicativeRate);
    }
    if (!nullToAbsent || qualityRating != null) {
      map['quality_rating'] = Variable<double>(qualityRating);
    }
    if (!nullToAbsent || punctualityRating != null) {
      map['punctuality_rating'] = Variable<double>(punctualityRating);
    }
    if (!nullToAbsent || communicationRating != null) {
      map['communication_rating'] = Variable<double>(communicationRating);
    }
    {
      map['status'] = Variable<String>(
        $PrestatairesTable.$converterstatus.toSql(status),
      );
    }
    map['interventions_count'] = Variable<int>(interventionsCount);
    if (!nullToAbsent || lastInterventionDate != null) {
      map['last_intervention_date'] = Variable<DateTime>(lastInterventionDate);
    }
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $PrestatairesTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PrestatairesCompanion toCompanion(bool nullToAbsent) {
    return PrestatairesCompanion(
      id: Value(id),
      reference: Value(reference),
      fullName: Value(fullName),
      phone: Value(phone),
      specialty: Value(specialty),
      zone: zone == null && nullToAbsent ? const Value.absent() : Value(zone),
      experienceYears: experienceYears == null && nullToAbsent
          ? const Value.absent()
          : Value(experienceYears),
      identityVerified: Value(identityVerified),
      referencesVerified: Value(referencesVerified),
      indicativeRate: indicativeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(indicativeRate),
      qualityRating: qualityRating == null && nullToAbsent
          ? const Value.absent()
          : Value(qualityRating),
      punctualityRating: punctualityRating == null && nullToAbsent
          ? const Value.absent()
          : Value(punctualityRating),
      communicationRating: communicationRating == null && nullToAbsent
          ? const Value.absent()
          : Value(communicationRating),
      status: Value(status),
      interventionsCount: Value(interventionsCount),
      lastInterventionDate: lastInterventionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastInterventionDate),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Prestataire.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Prestataire(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      fullName: serializer.fromJson<String>(json['fullName']),
      phone: serializer.fromJson<String>(json['phone']),
      specialty: serializer.fromJson<String>(json['specialty']),
      zone: serializer.fromJson<String?>(json['zone']),
      experienceYears: serializer.fromJson<int?>(json['experienceYears']),
      identityVerified: serializer.fromJson<bool>(json['identityVerified']),
      referencesVerified: serializer.fromJson<bool>(json['referencesVerified']),
      indicativeRate: serializer.fromJson<double?>(json['indicativeRate']),
      qualityRating: serializer.fromJson<double?>(json['qualityRating']),
      punctualityRating: serializer.fromJson<double?>(
        json['punctualityRating'],
      ),
      communicationRating: serializer.fromJson<double?>(
        json['communicationRating'],
      ),
      status: $PrestatairesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      interventionsCount: serializer.fromJson<int>(json['interventionsCount']),
      lastInterventionDate: serializer.fromJson<DateTime?>(
        json['lastInterventionDate'],
      ),
      observations: serializer.fromJson<String?>(json['observations']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $PrestatairesTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'fullName': serializer.toJson<String>(fullName),
      'phone': serializer.toJson<String>(phone),
      'specialty': serializer.toJson<String>(specialty),
      'zone': serializer.toJson<String?>(zone),
      'experienceYears': serializer.toJson<int?>(experienceYears),
      'identityVerified': serializer.toJson<bool>(identityVerified),
      'referencesVerified': serializer.toJson<bool>(referencesVerified),
      'indicativeRate': serializer.toJson<double?>(indicativeRate),
      'qualityRating': serializer.toJson<double?>(qualityRating),
      'punctualityRating': serializer.toJson<double?>(punctualityRating),
      'communicationRating': serializer.toJson<double?>(communicationRating),
      'status': serializer.toJson<String>(
        $PrestatairesTable.$converterstatus.toJson(status),
      ),
      'interventionsCount': serializer.toJson<int>(interventionsCount),
      'lastInterventionDate': serializer.toJson<DateTime?>(
        lastInterventionDate,
      ),
      'observations': serializer.toJson<String?>(observations),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $PrestatairesTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Prestataire copyWith({
    int? id,
    String? reference,
    String? fullName,
    String? phone,
    String? specialty,
    Value<String?> zone = const Value.absent(),
    Value<int?> experienceYears = const Value.absent(),
    bool? identityVerified,
    bool? referencesVerified,
    Value<double?> indicativeRate = const Value.absent(),
    Value<double?> qualityRating = const Value.absent(),
    Value<double?> punctualityRating = const Value.absent(),
    Value<double?> communicationRating = const Value.absent(),
    PrestataireStatus? status,
    int? interventionsCount,
    Value<DateTime?> lastInterventionDate = const Value.absent(),
    Value<String?> observations = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Prestataire(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    fullName: fullName ?? this.fullName,
    phone: phone ?? this.phone,
    specialty: specialty ?? this.specialty,
    zone: zone.present ? zone.value : this.zone,
    experienceYears: experienceYears.present
        ? experienceYears.value
        : this.experienceYears,
    identityVerified: identityVerified ?? this.identityVerified,
    referencesVerified: referencesVerified ?? this.referencesVerified,
    indicativeRate: indicativeRate.present
        ? indicativeRate.value
        : this.indicativeRate,
    qualityRating: qualityRating.present
        ? qualityRating.value
        : this.qualityRating,
    punctualityRating: punctualityRating.present
        ? punctualityRating.value
        : this.punctualityRating,
    communicationRating: communicationRating.present
        ? communicationRating.value
        : this.communicationRating,
    status: status ?? this.status,
    interventionsCount: interventionsCount ?? this.interventionsCount,
    lastInterventionDate: lastInterventionDate.present
        ? lastInterventionDate.value
        : this.lastInterventionDate,
    observations: observations.present ? observations.value : this.observations,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Prestataire copyWithCompanion(PrestatairesCompanion data) {
    return Prestataire(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      phone: data.phone.present ? data.phone.value : this.phone,
      specialty: data.specialty.present ? data.specialty.value : this.specialty,
      zone: data.zone.present ? data.zone.value : this.zone,
      experienceYears: data.experienceYears.present
          ? data.experienceYears.value
          : this.experienceYears,
      identityVerified: data.identityVerified.present
          ? data.identityVerified.value
          : this.identityVerified,
      referencesVerified: data.referencesVerified.present
          ? data.referencesVerified.value
          : this.referencesVerified,
      indicativeRate: data.indicativeRate.present
          ? data.indicativeRate.value
          : this.indicativeRate,
      qualityRating: data.qualityRating.present
          ? data.qualityRating.value
          : this.qualityRating,
      punctualityRating: data.punctualityRating.present
          ? data.punctualityRating.value
          : this.punctualityRating,
      communicationRating: data.communicationRating.present
          ? data.communicationRating.value
          : this.communicationRating,
      status: data.status.present ? data.status.value : this.status,
      interventionsCount: data.interventionsCount.present
          ? data.interventionsCount.value
          : this.interventionsCount,
      lastInterventionDate: data.lastInterventionDate.present
          ? data.lastInterventionDate.value
          : this.lastInterventionDate,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Prestataire(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('specialty: $specialty, ')
          ..write('zone: $zone, ')
          ..write('experienceYears: $experienceYears, ')
          ..write('identityVerified: $identityVerified, ')
          ..write('referencesVerified: $referencesVerified, ')
          ..write('indicativeRate: $indicativeRate, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('punctualityRating: $punctualityRating, ')
          ..write('communicationRating: $communicationRating, ')
          ..write('status: $status, ')
          ..write('interventionsCount: $interventionsCount, ')
          ..write('lastInterventionDate: $lastInterventionDate, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    reference,
    fullName,
    phone,
    specialty,
    zone,
    experienceYears,
    identityVerified,
    referencesVerified,
    indicativeRate,
    qualityRating,
    punctualityRating,
    communicationRating,
    status,
    interventionsCount,
    lastInterventionDate,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Prestataire &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.fullName == this.fullName &&
          other.phone == this.phone &&
          other.specialty == this.specialty &&
          other.zone == this.zone &&
          other.experienceYears == this.experienceYears &&
          other.identityVerified == this.identityVerified &&
          other.referencesVerified == this.referencesVerified &&
          other.indicativeRate == this.indicativeRate &&
          other.qualityRating == this.qualityRating &&
          other.punctualityRating == this.punctualityRating &&
          other.communicationRating == this.communicationRating &&
          other.status == this.status &&
          other.interventionsCount == this.interventionsCount &&
          other.lastInterventionDate == this.lastInterventionDate &&
          other.observations == this.observations &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class PrestatairesCompanion extends UpdateCompanion<Prestataire> {
  final Value<int> id;
  final Value<String> reference;
  final Value<String> fullName;
  final Value<String> phone;
  final Value<String> specialty;
  final Value<String?> zone;
  final Value<int?> experienceYears;
  final Value<bool> identityVerified;
  final Value<bool> referencesVerified;
  final Value<double?> indicativeRate;
  final Value<double?> qualityRating;
  final Value<double?> punctualityRating;
  final Value<double?> communicationRating;
  final Value<PrestataireStatus> status;
  final Value<int> interventionsCount;
  final Value<DateTime?> lastInterventionDate;
  final Value<String?> observations;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const PrestatairesCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.fullName = const Value.absent(),
    this.phone = const Value.absent(),
    this.specialty = const Value.absent(),
    this.zone = const Value.absent(),
    this.experienceYears = const Value.absent(),
    this.identityVerified = const Value.absent(),
    this.referencesVerified = const Value.absent(),
    this.indicativeRate = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.punctualityRating = const Value.absent(),
    this.communicationRating = const Value.absent(),
    this.status = const Value.absent(),
    this.interventionsCount = const Value.absent(),
    this.lastInterventionDate = const Value.absent(),
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PrestatairesCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required String fullName,
    required String phone,
    required String specialty,
    this.zone = const Value.absent(),
    this.experienceYears = const Value.absent(),
    this.identityVerified = const Value.absent(),
    this.referencesVerified = const Value.absent(),
    this.indicativeRate = const Value.absent(),
    this.qualityRating = const Value.absent(),
    this.punctualityRating = const Value.absent(),
    this.communicationRating = const Value.absent(),
    required PrestataireStatus status,
    this.interventionsCount = const Value.absent(),
    this.lastInterventionDate = const Value.absent(),
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       fullName = Value(fullName),
       phone = Value(phone),
       specialty = Value(specialty),
       status = Value(status);
  static Insertable<Prestataire> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<String>? fullName,
    Expression<String>? phone,
    Expression<String>? specialty,
    Expression<String>? zone,
    Expression<int>? experienceYears,
    Expression<bool>? identityVerified,
    Expression<bool>? referencesVerified,
    Expression<double>? indicativeRate,
    Expression<double>? qualityRating,
    Expression<double>? punctualityRating,
    Expression<double>? communicationRating,
    Expression<String>? status,
    Expression<int>? interventionsCount,
    Expression<DateTime>? lastInterventionDate,
    Expression<String>? observations,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (specialty != null) 'specialty': specialty,
      if (zone != null) 'zone': zone,
      if (experienceYears != null) 'experience_years': experienceYears,
      if (identityVerified != null) 'identity_verified': identityVerified,
      if (referencesVerified != null) 'references_verified': referencesVerified,
      if (indicativeRate != null) 'indicative_rate': indicativeRate,
      if (qualityRating != null) 'quality_rating': qualityRating,
      if (punctualityRating != null) 'punctuality_rating': punctualityRating,
      if (communicationRating != null)
        'communication_rating': communicationRating,
      if (status != null) 'status': status,
      if (interventionsCount != null) 'interventions_count': interventionsCount,
      if (lastInterventionDate != null)
        'last_intervention_date': lastInterventionDate,
      if (observations != null) 'observations': observations,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PrestatairesCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<String>? fullName,
    Value<String>? phone,
    Value<String>? specialty,
    Value<String?>? zone,
    Value<int?>? experienceYears,
    Value<bool>? identityVerified,
    Value<bool>? referencesVerified,
    Value<double?>? indicativeRate,
    Value<double?>? qualityRating,
    Value<double?>? punctualityRating,
    Value<double?>? communicationRating,
    Value<PrestataireStatus>? status,
    Value<int>? interventionsCount,
    Value<DateTime?>? lastInterventionDate,
    Value<String?>? observations,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return PrestatairesCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      specialty: specialty ?? this.specialty,
      zone: zone ?? this.zone,
      experienceYears: experienceYears ?? this.experienceYears,
      identityVerified: identityVerified ?? this.identityVerified,
      referencesVerified: referencesVerified ?? this.referencesVerified,
      indicativeRate: indicativeRate ?? this.indicativeRate,
      qualityRating: qualityRating ?? this.qualityRating,
      punctualityRating: punctualityRating ?? this.punctualityRating,
      communicationRating: communicationRating ?? this.communicationRating,
      status: status ?? this.status,
      interventionsCount: interventionsCount ?? this.interventionsCount,
      lastInterventionDate: lastInterventionDate ?? this.lastInterventionDate,
      observations: observations ?? this.observations,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (specialty.present) {
      map['specialty'] = Variable<String>(specialty.value);
    }
    if (zone.present) {
      map['zone'] = Variable<String>(zone.value);
    }
    if (experienceYears.present) {
      map['experience_years'] = Variable<int>(experienceYears.value);
    }
    if (identityVerified.present) {
      map['identity_verified'] = Variable<bool>(identityVerified.value);
    }
    if (referencesVerified.present) {
      map['references_verified'] = Variable<bool>(referencesVerified.value);
    }
    if (indicativeRate.present) {
      map['indicative_rate'] = Variable<double>(indicativeRate.value);
    }
    if (qualityRating.present) {
      map['quality_rating'] = Variable<double>(qualityRating.value);
    }
    if (punctualityRating.present) {
      map['punctuality_rating'] = Variable<double>(punctualityRating.value);
    }
    if (communicationRating.present) {
      map['communication_rating'] = Variable<double>(communicationRating.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $PrestatairesTable.$converterstatus.toSql(status.value),
      );
    }
    if (interventionsCount.present) {
      map['interventions_count'] = Variable<int>(interventionsCount.value);
    }
    if (lastInterventionDate.present) {
      map['last_intervention_date'] = Variable<DateTime>(
        lastInterventionDate.value,
      );
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $PrestatairesTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrestatairesCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('fullName: $fullName, ')
          ..write('phone: $phone, ')
          ..write('specialty: $specialty, ')
          ..write('zone: $zone, ')
          ..write('experienceYears: $experienceYears, ')
          ..write('identityVerified: $identityVerified, ')
          ..write('referencesVerified: $referencesVerified, ')
          ..write('indicativeRate: $indicativeRate, ')
          ..write('qualityRating: $qualityRating, ')
          ..write('punctualityRating: $punctualityRating, ')
          ..write('communicationRating: $communicationRating, ')
          ..write('status: $status, ')
          ..write('interventionsCount: $interventionsCount, ')
          ..write('lastInterventionDate: $lastInterventionDate, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $InterventionsTable extends Interventions
    with TableInfo<$InterventionsTable, Intervention> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InterventionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _logementIdMeta = const VerificationMeta(
    'logementId',
  );
  @override
  late final GeneratedColumn<int> logementId = GeneratedColumn<int>(
    'logement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES logements (id)',
    ),
  );
  static const VerificationMeta _clientIdMeta = const VerificationMeta(
    'clientId',
  );
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
    'client_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _problemDescriptionMeta =
      const VerificationMeta('problemDescription');
  @override
  late final GeneratedColumn<String> problemDescription =
      GeneratedColumn<String>(
        'problem_description',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<UrgencyLevel, String>
  urgencyLevel = GeneratedColumn<String>(
    'urgency_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<UrgencyLevel>($InterventionsTable.$converterurgencyLevel);
  static const VerificationMeta _prestataireIdMeta = const VerificationMeta(
    'prestataireId',
  );
  @override
  late final GeneratedColumn<int> prestataireId = GeneratedColumn<int>(
    'prestataire_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prestataires (id)',
    ),
  );
  static const VerificationMeta _quoteAmountMeta = const VerificationMeta(
    'quoteAmount',
  );
  @override
  late final GeneratedColumn<double> quoteAmount = GeneratedColumn<double>(
    'quote_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientValidatedMeta = const VerificationMeta(
    'clientValidated',
  );
  @override
  late final GeneratedColumn<bool> clientValidated = GeneratedColumn<bool>(
    'client_validated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("client_validated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _interventionDateMeta = const VerificationMeta(
    'interventionDate',
  );
  @override
  late final GeneratedColumn<DateTime> interventionDate =
      GeneratedColumn<DateTime>(
        'intervention_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _clientAmountMeta = const VerificationMeta(
    'clientAmount',
  );
  @override
  late final GeneratedColumn<double> clientAmount = GeneratedColumn<double>(
    'client_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prestataireAmountMeta = const VerificationMeta(
    'prestataireAmount',
  );
  @override
  late final GeneratedColumn<double> prestataireAmount =
      GeneratedColumn<double>(
        'prestataire_amount',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _havenaMarginMeta = const VerificationMeta(
    'havenaMargin',
  );
  @override
  late final GeneratedColumn<double> havenaMargin = GeneratedColumn<double>(
    'havena_margin',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<InterventionStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<InterventionStatus>($InterventionsTable.$converterstatus);
  static const VerificationMeta _clientSatisfactionMeta =
      const VerificationMeta('clientSatisfaction');
  @override
  late final GeneratedColumn<int> clientSatisfaction = GeneratedColumn<int>(
    'client_satisfaction',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($InterventionsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    logementId,
    clientId,
    problemDescription,
    category,
    urgencyLevel,
    prestataireId,
    quoteAmount,
    clientValidated,
    interventionDate,
    clientAmount,
    prestataireAmount,
    havenaMargin,
    status,
    clientSatisfaction,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'interventions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Intervention> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('logement_id')) {
      context.handle(
        _logementIdMeta,
        logementId.isAcceptableOrUnknown(data['logement_id']!, _logementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logementIdMeta);
    }
    if (data.containsKey('client_id')) {
      context.handle(
        _clientIdMeta,
        clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta),
      );
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('problem_description')) {
      context.handle(
        _problemDescriptionMeta,
        problemDescription.isAcceptableOrUnknown(
          data['problem_description']!,
          _problemDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_problemDescriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('prestataire_id')) {
      context.handle(
        _prestataireIdMeta,
        prestataireId.isAcceptableOrUnknown(
          data['prestataire_id']!,
          _prestataireIdMeta,
        ),
      );
    }
    if (data.containsKey('quote_amount')) {
      context.handle(
        _quoteAmountMeta,
        quoteAmount.isAcceptableOrUnknown(
          data['quote_amount']!,
          _quoteAmountMeta,
        ),
      );
    }
    if (data.containsKey('client_validated')) {
      context.handle(
        _clientValidatedMeta,
        clientValidated.isAcceptableOrUnknown(
          data['client_validated']!,
          _clientValidatedMeta,
        ),
      );
    }
    if (data.containsKey('intervention_date')) {
      context.handle(
        _interventionDateMeta,
        interventionDate.isAcceptableOrUnknown(
          data['intervention_date']!,
          _interventionDateMeta,
        ),
      );
    }
    if (data.containsKey('client_amount')) {
      context.handle(
        _clientAmountMeta,
        clientAmount.isAcceptableOrUnknown(
          data['client_amount']!,
          _clientAmountMeta,
        ),
      );
    }
    if (data.containsKey('prestataire_amount')) {
      context.handle(
        _prestataireAmountMeta,
        prestataireAmount.isAcceptableOrUnknown(
          data['prestataire_amount']!,
          _prestataireAmountMeta,
        ),
      );
    }
    if (data.containsKey('havena_margin')) {
      context.handle(
        _havenaMarginMeta,
        havenaMargin.isAcceptableOrUnknown(
          data['havena_margin']!,
          _havenaMarginMeta,
        ),
      );
    }
    if (data.containsKey('client_satisfaction')) {
      context.handle(
        _clientSatisfactionMeta,
        clientSatisfaction.isAcceptableOrUnknown(
          data['client_satisfaction']!,
          _clientSatisfactionMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Intervention map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Intervention(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      logementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logement_id'],
      )!,
      clientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_id'],
      )!,
      problemDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}problem_description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      urgencyLevel: $InterventionsTable.$converterurgencyLevel.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}urgency_level'],
        )!,
      ),
      prestataireId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prestataire_id'],
      ),
      quoteAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quote_amount'],
      ),
      clientValidated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}client_validated'],
      )!,
      interventionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}intervention_date'],
      ),
      clientAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}client_amount'],
      ),
      prestataireAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}prestataire_amount'],
      ),
      havenaMargin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}havena_margin'],
      ),
      status: $InterventionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      clientSatisfaction: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}client_satisfaction'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $InterventionsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $InterventionsTable createAlias(String alias) {
    return $InterventionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UrgencyLevel, String, String>
  $converterurgencyLevel = const EnumNameConverter<UrgencyLevel>(
    UrgencyLevel.values,
  );
  static JsonTypeConverter2<InterventionStatus, String, String>
  $converterstatus = const EnumNameConverter<InterventionStatus>(
    InterventionStatus.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Intervention extends DataClass implements Insertable<Intervention> {
  final int id;
  final String reference;
  final int logementId;
  final int clientId;
  final String problemDescription;
  final String? category;
  final UrgencyLevel urgencyLevel;
  final int? prestataireId;
  final double? quoteAmount;
  final bool clientValidated;
  final DateTime? interventionDate;
  final double? clientAmount;
  final double? prestataireAmount;
  final double? havenaMargin;
  final InterventionStatus status;
  final int? clientSatisfaction;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Intervention({
    required this.id,
    required this.reference,
    required this.logementId,
    required this.clientId,
    required this.problemDescription,
    this.category,
    required this.urgencyLevel,
    this.prestataireId,
    this.quoteAmount,
    required this.clientValidated,
    this.interventionDate,
    this.clientAmount,
    this.prestataireAmount,
    this.havenaMargin,
    required this.status,
    this.clientSatisfaction,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['logement_id'] = Variable<int>(logementId);
    map['client_id'] = Variable<int>(clientId);
    map['problem_description'] = Variable<String>(problemDescription);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    {
      map['urgency_level'] = Variable<String>(
        $InterventionsTable.$converterurgencyLevel.toSql(urgencyLevel),
      );
    }
    if (!nullToAbsent || prestataireId != null) {
      map['prestataire_id'] = Variable<int>(prestataireId);
    }
    if (!nullToAbsent || quoteAmount != null) {
      map['quote_amount'] = Variable<double>(quoteAmount);
    }
    map['client_validated'] = Variable<bool>(clientValidated);
    if (!nullToAbsent || interventionDate != null) {
      map['intervention_date'] = Variable<DateTime>(interventionDate);
    }
    if (!nullToAbsent || clientAmount != null) {
      map['client_amount'] = Variable<double>(clientAmount);
    }
    if (!nullToAbsent || prestataireAmount != null) {
      map['prestataire_amount'] = Variable<double>(prestataireAmount);
    }
    if (!nullToAbsent || havenaMargin != null) {
      map['havena_margin'] = Variable<double>(havenaMargin);
    }
    {
      map['status'] = Variable<String>(
        $InterventionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || clientSatisfaction != null) {
      map['client_satisfaction'] = Variable<int>(clientSatisfaction);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $InterventionsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  InterventionsCompanion toCompanion(bool nullToAbsent) {
    return InterventionsCompanion(
      id: Value(id),
      reference: Value(reference),
      logementId: Value(logementId),
      clientId: Value(clientId),
      problemDescription: Value(problemDescription),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      urgencyLevel: Value(urgencyLevel),
      prestataireId: prestataireId == null && nullToAbsent
          ? const Value.absent()
          : Value(prestataireId),
      quoteAmount: quoteAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(quoteAmount),
      clientValidated: Value(clientValidated),
      interventionDate: interventionDate == null && nullToAbsent
          ? const Value.absent()
          : Value(interventionDate),
      clientAmount: clientAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(clientAmount),
      prestataireAmount: prestataireAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(prestataireAmount),
      havenaMargin: havenaMargin == null && nullToAbsent
          ? const Value.absent()
          : Value(havenaMargin),
      status: Value(status),
      clientSatisfaction: clientSatisfaction == null && nullToAbsent
          ? const Value.absent()
          : Value(clientSatisfaction),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Intervention.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Intervention(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      logementId: serializer.fromJson<int>(json['logementId']),
      clientId: serializer.fromJson<int>(json['clientId']),
      problemDescription: serializer.fromJson<String>(
        json['problemDescription'],
      ),
      category: serializer.fromJson<String?>(json['category']),
      urgencyLevel: $InterventionsTable.$converterurgencyLevel.fromJson(
        serializer.fromJson<String>(json['urgencyLevel']),
      ),
      prestataireId: serializer.fromJson<int?>(json['prestataireId']),
      quoteAmount: serializer.fromJson<double?>(json['quoteAmount']),
      clientValidated: serializer.fromJson<bool>(json['clientValidated']),
      interventionDate: serializer.fromJson<DateTime?>(
        json['interventionDate'],
      ),
      clientAmount: serializer.fromJson<double?>(json['clientAmount']),
      prestataireAmount: serializer.fromJson<double?>(
        json['prestataireAmount'],
      ),
      havenaMargin: serializer.fromJson<double?>(json['havenaMargin']),
      status: $InterventionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      clientSatisfaction: serializer.fromJson<int?>(json['clientSatisfaction']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $InterventionsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'logementId': serializer.toJson<int>(logementId),
      'clientId': serializer.toJson<int>(clientId),
      'problemDescription': serializer.toJson<String>(problemDescription),
      'category': serializer.toJson<String?>(category),
      'urgencyLevel': serializer.toJson<String>(
        $InterventionsTable.$converterurgencyLevel.toJson(urgencyLevel),
      ),
      'prestataireId': serializer.toJson<int?>(prestataireId),
      'quoteAmount': serializer.toJson<double?>(quoteAmount),
      'clientValidated': serializer.toJson<bool>(clientValidated),
      'interventionDate': serializer.toJson<DateTime?>(interventionDate),
      'clientAmount': serializer.toJson<double?>(clientAmount),
      'prestataireAmount': serializer.toJson<double?>(prestataireAmount),
      'havenaMargin': serializer.toJson<double?>(havenaMargin),
      'status': serializer.toJson<String>(
        $InterventionsTable.$converterstatus.toJson(status),
      ),
      'clientSatisfaction': serializer.toJson<int?>(clientSatisfaction),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $InterventionsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Intervention copyWith({
    int? id,
    String? reference,
    int? logementId,
    int? clientId,
    String? problemDescription,
    Value<String?> category = const Value.absent(),
    UrgencyLevel? urgencyLevel,
    Value<int?> prestataireId = const Value.absent(),
    Value<double?> quoteAmount = const Value.absent(),
    bool? clientValidated,
    Value<DateTime?> interventionDate = const Value.absent(),
    Value<double?> clientAmount = const Value.absent(),
    Value<double?> prestataireAmount = const Value.absent(),
    Value<double?> havenaMargin = const Value.absent(),
    InterventionStatus? status,
    Value<int?> clientSatisfaction = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Intervention(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    logementId: logementId ?? this.logementId,
    clientId: clientId ?? this.clientId,
    problemDescription: problemDescription ?? this.problemDescription,
    category: category.present ? category.value : this.category,
    urgencyLevel: urgencyLevel ?? this.urgencyLevel,
    prestataireId: prestataireId.present
        ? prestataireId.value
        : this.prestataireId,
    quoteAmount: quoteAmount.present ? quoteAmount.value : this.quoteAmount,
    clientValidated: clientValidated ?? this.clientValidated,
    interventionDate: interventionDate.present
        ? interventionDate.value
        : this.interventionDate,
    clientAmount: clientAmount.present ? clientAmount.value : this.clientAmount,
    prestataireAmount: prestataireAmount.present
        ? prestataireAmount.value
        : this.prestataireAmount,
    havenaMargin: havenaMargin.present ? havenaMargin.value : this.havenaMargin,
    status: status ?? this.status,
    clientSatisfaction: clientSatisfaction.present
        ? clientSatisfaction.value
        : this.clientSatisfaction,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Intervention copyWithCompanion(InterventionsCompanion data) {
    return Intervention(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      logementId: data.logementId.present
          ? data.logementId.value
          : this.logementId,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      problemDescription: data.problemDescription.present
          ? data.problemDescription.value
          : this.problemDescription,
      category: data.category.present ? data.category.value : this.category,
      urgencyLevel: data.urgencyLevel.present
          ? data.urgencyLevel.value
          : this.urgencyLevel,
      prestataireId: data.prestataireId.present
          ? data.prestataireId.value
          : this.prestataireId,
      quoteAmount: data.quoteAmount.present
          ? data.quoteAmount.value
          : this.quoteAmount,
      clientValidated: data.clientValidated.present
          ? data.clientValidated.value
          : this.clientValidated,
      interventionDate: data.interventionDate.present
          ? data.interventionDate.value
          : this.interventionDate,
      clientAmount: data.clientAmount.present
          ? data.clientAmount.value
          : this.clientAmount,
      prestataireAmount: data.prestataireAmount.present
          ? data.prestataireAmount.value
          : this.prestataireAmount,
      havenaMargin: data.havenaMargin.present
          ? data.havenaMargin.value
          : this.havenaMargin,
      status: data.status.present ? data.status.value : this.status,
      clientSatisfaction: data.clientSatisfaction.present
          ? data.clientSatisfaction.value
          : this.clientSatisfaction,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Intervention(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('clientId: $clientId, ')
          ..write('problemDescription: $problemDescription, ')
          ..write('category: $category, ')
          ..write('urgencyLevel: $urgencyLevel, ')
          ..write('prestataireId: $prestataireId, ')
          ..write('quoteAmount: $quoteAmount, ')
          ..write('clientValidated: $clientValidated, ')
          ..write('interventionDate: $interventionDate, ')
          ..write('clientAmount: $clientAmount, ')
          ..write('prestataireAmount: $prestataireAmount, ')
          ..write('havenaMargin: $havenaMargin, ')
          ..write('status: $status, ')
          ..write('clientSatisfaction: $clientSatisfaction, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    logementId,
    clientId,
    problemDescription,
    category,
    urgencyLevel,
    prestataireId,
    quoteAmount,
    clientValidated,
    interventionDate,
    clientAmount,
    prestataireAmount,
    havenaMargin,
    status,
    clientSatisfaction,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Intervention &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.logementId == this.logementId &&
          other.clientId == this.clientId &&
          other.problemDescription == this.problemDescription &&
          other.category == this.category &&
          other.urgencyLevel == this.urgencyLevel &&
          other.prestataireId == this.prestataireId &&
          other.quoteAmount == this.quoteAmount &&
          other.clientValidated == this.clientValidated &&
          other.interventionDate == this.interventionDate &&
          other.clientAmount == this.clientAmount &&
          other.prestataireAmount == this.prestataireAmount &&
          other.havenaMargin == this.havenaMargin &&
          other.status == this.status &&
          other.clientSatisfaction == this.clientSatisfaction &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class InterventionsCompanion extends UpdateCompanion<Intervention> {
  final Value<int> id;
  final Value<String> reference;
  final Value<int> logementId;
  final Value<int> clientId;
  final Value<String> problemDescription;
  final Value<String?> category;
  final Value<UrgencyLevel> urgencyLevel;
  final Value<int?> prestataireId;
  final Value<double?> quoteAmount;
  final Value<bool> clientValidated;
  final Value<DateTime?> interventionDate;
  final Value<double?> clientAmount;
  final Value<double?> prestataireAmount;
  final Value<double?> havenaMargin;
  final Value<InterventionStatus> status;
  final Value<int?> clientSatisfaction;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const InterventionsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.logementId = const Value.absent(),
    this.clientId = const Value.absent(),
    this.problemDescription = const Value.absent(),
    this.category = const Value.absent(),
    this.urgencyLevel = const Value.absent(),
    this.prestataireId = const Value.absent(),
    this.quoteAmount = const Value.absent(),
    this.clientValidated = const Value.absent(),
    this.interventionDate = const Value.absent(),
    this.clientAmount = const Value.absent(),
    this.prestataireAmount = const Value.absent(),
    this.havenaMargin = const Value.absent(),
    this.status = const Value.absent(),
    this.clientSatisfaction = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  InterventionsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required int logementId,
    required int clientId,
    required String problemDescription,
    this.category = const Value.absent(),
    required UrgencyLevel urgencyLevel,
    this.prestataireId = const Value.absent(),
    this.quoteAmount = const Value.absent(),
    this.clientValidated = const Value.absent(),
    this.interventionDate = const Value.absent(),
    this.clientAmount = const Value.absent(),
    this.prestataireAmount = const Value.absent(),
    this.havenaMargin = const Value.absent(),
    required InterventionStatus status,
    this.clientSatisfaction = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       logementId = Value(logementId),
       clientId = Value(clientId),
       problemDescription = Value(problemDescription),
       urgencyLevel = Value(urgencyLevel),
       status = Value(status);
  static Insertable<Intervention> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<int>? logementId,
    Expression<int>? clientId,
    Expression<String>? problemDescription,
    Expression<String>? category,
    Expression<String>? urgencyLevel,
    Expression<int>? prestataireId,
    Expression<double>? quoteAmount,
    Expression<bool>? clientValidated,
    Expression<DateTime>? interventionDate,
    Expression<double>? clientAmount,
    Expression<double>? prestataireAmount,
    Expression<double>? havenaMargin,
    Expression<String>? status,
    Expression<int>? clientSatisfaction,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (logementId != null) 'logement_id': logementId,
      if (clientId != null) 'client_id': clientId,
      if (problemDescription != null) 'problem_description': problemDescription,
      if (category != null) 'category': category,
      if (urgencyLevel != null) 'urgency_level': urgencyLevel,
      if (prestataireId != null) 'prestataire_id': prestataireId,
      if (quoteAmount != null) 'quote_amount': quoteAmount,
      if (clientValidated != null) 'client_validated': clientValidated,
      if (interventionDate != null) 'intervention_date': interventionDate,
      if (clientAmount != null) 'client_amount': clientAmount,
      if (prestataireAmount != null) 'prestataire_amount': prestataireAmount,
      if (havenaMargin != null) 'havena_margin': havenaMargin,
      if (status != null) 'status': status,
      if (clientSatisfaction != null) 'client_satisfaction': clientSatisfaction,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  InterventionsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<int>? logementId,
    Value<int>? clientId,
    Value<String>? problemDescription,
    Value<String?>? category,
    Value<UrgencyLevel>? urgencyLevel,
    Value<int?>? prestataireId,
    Value<double?>? quoteAmount,
    Value<bool>? clientValidated,
    Value<DateTime?>? interventionDate,
    Value<double?>? clientAmount,
    Value<double?>? prestataireAmount,
    Value<double?>? havenaMargin,
    Value<InterventionStatus>? status,
    Value<int?>? clientSatisfaction,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return InterventionsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      logementId: logementId ?? this.logementId,
      clientId: clientId ?? this.clientId,
      problemDescription: problemDescription ?? this.problemDescription,
      category: category ?? this.category,
      urgencyLevel: urgencyLevel ?? this.urgencyLevel,
      prestataireId: prestataireId ?? this.prestataireId,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      clientValidated: clientValidated ?? this.clientValidated,
      interventionDate: interventionDate ?? this.interventionDate,
      clientAmount: clientAmount ?? this.clientAmount,
      prestataireAmount: prestataireAmount ?? this.prestataireAmount,
      havenaMargin: havenaMargin ?? this.havenaMargin,
      status: status ?? this.status,
      clientSatisfaction: clientSatisfaction ?? this.clientSatisfaction,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (logementId.present) {
      map['logement_id'] = Variable<int>(logementId.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (problemDescription.present) {
      map['problem_description'] = Variable<String>(problemDescription.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (urgencyLevel.present) {
      map['urgency_level'] = Variable<String>(
        $InterventionsTable.$converterurgencyLevel.toSql(urgencyLevel.value),
      );
    }
    if (prestataireId.present) {
      map['prestataire_id'] = Variable<int>(prestataireId.value);
    }
    if (quoteAmount.present) {
      map['quote_amount'] = Variable<double>(quoteAmount.value);
    }
    if (clientValidated.present) {
      map['client_validated'] = Variable<bool>(clientValidated.value);
    }
    if (interventionDate.present) {
      map['intervention_date'] = Variable<DateTime>(interventionDate.value);
    }
    if (clientAmount.present) {
      map['client_amount'] = Variable<double>(clientAmount.value);
    }
    if (prestataireAmount.present) {
      map['prestataire_amount'] = Variable<double>(prestataireAmount.value);
    }
    if (havenaMargin.present) {
      map['havena_margin'] = Variable<double>(havenaMargin.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $InterventionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (clientSatisfaction.present) {
      map['client_satisfaction'] = Variable<int>(clientSatisfaction.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $InterventionsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InterventionsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('clientId: $clientId, ')
          ..write('problemDescription: $problemDescription, ')
          ..write('category: $category, ')
          ..write('urgencyLevel: $urgencyLevel, ')
          ..write('prestataireId: $prestataireId, ')
          ..write('quoteAmount: $quoteAmount, ')
          ..write('clientValidated: $clientValidated, ')
          ..write('interventionDate: $interventionDate, ')
          ..write('clientAmount: $clientAmount, ')
          ..write('prestataireAmount: $prestataireAmount, ')
          ..write('havenaMargin: $havenaMargin, ')
          ..write('status: $status, ')
          ..write('clientSatisfaction: $clientSatisfaction, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $FinancesTable extends Finances with TableInfo<$FinancesTable, Finance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String>
  transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionType>($FinancesTable.$convertertransactionType);
  static const VerificationMeta _relatedClientIdMeta = const VerificationMeta(
    'relatedClientId',
  );
  @override
  late final GeneratedColumn<int> relatedClientId = GeneratedColumn<int>(
    'related_client_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES clients (id)',
    ),
  );
  static const VerificationMeta _relatedPrestataireIdMeta =
      const VerificationMeta('relatedPrestataireId');
  @override
  late final GeneratedColumn<int> relatedPrestataireId = GeneratedColumn<int>(
    'related_prestataire_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES prestataires (id)',
    ),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<TransactionStatus, String>
  status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<TransactionStatus>($FinancesTable.$converterstatus);
  static const VerificationMeta _periodMonthMeta = const VerificationMeta(
    'periodMonth',
  );
  @override
  late final GeneratedColumn<String> periodMonth = GeneratedColumn<String>(
    'period_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _observationsMeta = const VerificationMeta(
    'observations',
  );
  @override
  late final GeneratedColumn<String> observations = GeneratedColumn<String>(
    'observations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($FinancesTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    transactionDate,
    transactionType,
    relatedClientId,
    relatedPrestataireId,
    description,
    amount,
    paymentMethod,
    status,
    periodMonth,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finances';
  @override
  VerificationContext validateIntegrity(
    Insertable<Finance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('related_client_id')) {
      context.handle(
        _relatedClientIdMeta,
        relatedClientId.isAcceptableOrUnknown(
          data['related_client_id']!,
          _relatedClientIdMeta,
        ),
      );
    }
    if (data.containsKey('related_prestataire_id')) {
      context.handle(
        _relatedPrestataireIdMeta,
        relatedPrestataireId.isAcceptableOrUnknown(
          data['related_prestataire_id']!,
          _relatedPrestataireIdMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('period_month')) {
      context.handle(
        _periodMonthMeta,
        periodMonth.isAcceptableOrUnknown(
          data['period_month']!,
          _periodMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodMonthMeta);
    }
    if (data.containsKey('observations')) {
      context.handle(
        _observationsMeta,
        observations.isAcceptableOrUnknown(
          data['observations']!,
          _observationsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Finance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Finance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      transactionType: $FinancesTable.$convertertransactionType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}transaction_type'],
        )!,
      ),
      relatedClientId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_client_id'],
      ),
      relatedPrestataireId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}related_prestataire_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      ),
      status: $FinancesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      periodMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_month'],
      )!,
      observations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}observations'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $FinancesTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $FinancesTable createAlias(String alias) {
    return $FinancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TransactionType, String, String>
  $convertertransactionType = const EnumNameConverter<TransactionType>(
    TransactionType.values,
  );
  static JsonTypeConverter2<TransactionStatus, String, String>
  $converterstatus = const EnumNameConverter<TransactionStatus>(
    TransactionStatus.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Finance extends DataClass implements Insertable<Finance> {
  final int id;
  final String reference;
  final DateTime transactionDate;
  final TransactionType transactionType;
  final int? relatedClientId;
  final int? relatedPrestataireId;
  final String description;
  final double amount;
  final String? paymentMethod;
  final TransactionStatus status;
  final String periodMonth;
  final String? observations;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Finance({
    required this.id,
    required this.reference,
    required this.transactionDate,
    required this.transactionType,
    this.relatedClientId,
    this.relatedPrestataireId,
    required this.description,
    required this.amount,
    this.paymentMethod,
    required this.status,
    required this.periodMonth,
    this.observations,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    {
      map['transaction_type'] = Variable<String>(
        $FinancesTable.$convertertransactionType.toSql(transactionType),
      );
    }
    if (!nullToAbsent || relatedClientId != null) {
      map['related_client_id'] = Variable<int>(relatedClientId);
    }
    if (!nullToAbsent || relatedPrestataireId != null) {
      map['related_prestataire_id'] = Variable<int>(relatedPrestataireId);
    }
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || paymentMethod != null) {
      map['payment_method'] = Variable<String>(paymentMethod);
    }
    {
      map['status'] = Variable<String>(
        $FinancesTable.$converterstatus.toSql(status),
      );
    }
    map['period_month'] = Variable<String>(periodMonth);
    if (!nullToAbsent || observations != null) {
      map['observations'] = Variable<String>(observations);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $FinancesTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  FinancesCompanion toCompanion(bool nullToAbsent) {
    return FinancesCompanion(
      id: Value(id),
      reference: Value(reference),
      transactionDate: Value(transactionDate),
      transactionType: Value(transactionType),
      relatedClientId: relatedClientId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedClientId),
      relatedPrestataireId: relatedPrestataireId == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedPrestataireId),
      description: Value(description),
      amount: Value(amount),
      paymentMethod: paymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentMethod),
      status: Value(status),
      periodMonth: Value(periodMonth),
      observations: observations == null && nullToAbsent
          ? const Value.absent()
          : Value(observations),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Finance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Finance(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      transactionType: $FinancesTable.$convertertransactionType.fromJson(
        serializer.fromJson<String>(json['transactionType']),
      ),
      relatedClientId: serializer.fromJson<int?>(json['relatedClientId']),
      relatedPrestataireId: serializer.fromJson<int?>(
        json['relatedPrestataireId'],
      ),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      paymentMethod: serializer.fromJson<String?>(json['paymentMethod']),
      status: $FinancesTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      periodMonth: serializer.fromJson<String>(json['periodMonth']),
      observations: serializer.fromJson<String?>(json['observations']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $FinancesTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'transactionType': serializer.toJson<String>(
        $FinancesTable.$convertertransactionType.toJson(transactionType),
      ),
      'relatedClientId': serializer.toJson<int?>(relatedClientId),
      'relatedPrestataireId': serializer.toJson<int?>(relatedPrestataireId),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'paymentMethod': serializer.toJson<String?>(paymentMethod),
      'status': serializer.toJson<String>(
        $FinancesTable.$converterstatus.toJson(status),
      ),
      'periodMonth': serializer.toJson<String>(periodMonth),
      'observations': serializer.toJson<String?>(observations),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $FinancesTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Finance copyWith({
    int? id,
    String? reference,
    DateTime? transactionDate,
    TransactionType? transactionType,
    Value<int?> relatedClientId = const Value.absent(),
    Value<int?> relatedPrestataireId = const Value.absent(),
    String? description,
    double? amount,
    Value<String?> paymentMethod = const Value.absent(),
    TransactionStatus? status,
    String? periodMonth,
    Value<String?> observations = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Finance(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    transactionDate: transactionDate ?? this.transactionDate,
    transactionType: transactionType ?? this.transactionType,
    relatedClientId: relatedClientId.present
        ? relatedClientId.value
        : this.relatedClientId,
    relatedPrestataireId: relatedPrestataireId.present
        ? relatedPrestataireId.value
        : this.relatedPrestataireId,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    paymentMethod: paymentMethod.present
        ? paymentMethod.value
        : this.paymentMethod,
    status: status ?? this.status,
    periodMonth: periodMonth ?? this.periodMonth,
    observations: observations.present ? observations.value : this.observations,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Finance copyWithCompanion(FinancesCompanion data) {
    return Finance(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      relatedClientId: data.relatedClientId.present
          ? data.relatedClientId.value
          : this.relatedClientId,
      relatedPrestataireId: data.relatedPrestataireId.present
          ? data.relatedPrestataireId.value
          : this.relatedPrestataireId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      status: data.status.present ? data.status.value : this.status,
      periodMonth: data.periodMonth.present
          ? data.periodMonth.value
          : this.periodMonth,
      observations: data.observations.present
          ? data.observations.value
          : this.observations,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Finance(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('relatedClientId: $relatedClientId, ')
          ..write('relatedPrestataireId: $relatedPrestataireId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    transactionDate,
    transactionType,
    relatedClientId,
    relatedPrestataireId,
    description,
    amount,
    paymentMethod,
    status,
    periodMonth,
    observations,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Finance &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.transactionDate == this.transactionDate &&
          other.transactionType == this.transactionType &&
          other.relatedClientId == this.relatedClientId &&
          other.relatedPrestataireId == this.relatedPrestataireId &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.paymentMethod == this.paymentMethod &&
          other.status == this.status &&
          other.periodMonth == this.periodMonth &&
          other.observations == this.observations &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class FinancesCompanion extends UpdateCompanion<Finance> {
  final Value<int> id;
  final Value<String> reference;
  final Value<DateTime> transactionDate;
  final Value<TransactionType> transactionType;
  final Value<int?> relatedClientId;
  final Value<int?> relatedPrestataireId;
  final Value<String> description;
  final Value<double> amount;
  final Value<String?> paymentMethod;
  final Value<TransactionStatus> status;
  final Value<String> periodMonth;
  final Value<String?> observations;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const FinancesCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.relatedClientId = const Value.absent(),
    this.relatedPrestataireId = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.status = const Value.absent(),
    this.periodMonth = const Value.absent(),
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  FinancesCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required DateTime transactionDate,
    required TransactionType transactionType,
    this.relatedClientId = const Value.absent(),
    this.relatedPrestataireId = const Value.absent(),
    required String description,
    required double amount,
    this.paymentMethod = const Value.absent(),
    required TransactionStatus status,
    required String periodMonth,
    this.observations = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       transactionDate = Value(transactionDate),
       transactionType = Value(transactionType),
       description = Value(description),
       amount = Value(amount),
       status = Value(status),
       periodMonth = Value(periodMonth);
  static Insertable<Finance> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<DateTime>? transactionDate,
    Expression<String>? transactionType,
    Expression<int>? relatedClientId,
    Expression<int>? relatedPrestataireId,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? paymentMethod,
    Expression<String>? status,
    Expression<String>? periodMonth,
    Expression<String>? observations,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (transactionType != null) 'transaction_type': transactionType,
      if (relatedClientId != null) 'related_client_id': relatedClientId,
      if (relatedPrestataireId != null)
        'related_prestataire_id': relatedPrestataireId,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (status != null) 'status': status,
      if (periodMonth != null) 'period_month': periodMonth,
      if (observations != null) 'observations': observations,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  FinancesCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<DateTime>? transactionDate,
    Value<TransactionType>? transactionType,
    Value<int?>? relatedClientId,
    Value<int?>? relatedPrestataireId,
    Value<String>? description,
    Value<double>? amount,
    Value<String?>? paymentMethod,
    Value<TransactionStatus>? status,
    Value<String>? periodMonth,
    Value<String?>? observations,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return FinancesCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      transactionDate: transactionDate ?? this.transactionDate,
      transactionType: transactionType ?? this.transactionType,
      relatedClientId: relatedClientId ?? this.relatedClientId,
      relatedPrestataireId: relatedPrestataireId ?? this.relatedPrestataireId,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      periodMonth: periodMonth ?? this.periodMonth,
      observations: observations ?? this.observations,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(
        $FinancesTable.$convertertransactionType.toSql(transactionType.value),
      );
    }
    if (relatedClientId.present) {
      map['related_client_id'] = Variable<int>(relatedClientId.value);
    }
    if (relatedPrestataireId.present) {
      map['related_prestataire_id'] = Variable<int>(relatedPrestataireId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $FinancesTable.$converterstatus.toSql(status.value),
      );
    }
    if (periodMonth.present) {
      map['period_month'] = Variable<String>(periodMonth.value);
    }
    if (observations.present) {
      map['observations'] = Variable<String>(observations.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $FinancesTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancesCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transactionType: $transactionType, ')
          ..write('relatedClientId: $relatedClientId, ')
          ..write('relatedPrestataireId: $relatedPrestataireId, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('status: $status, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('observations: $observations, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _logementIdMeta = const VerificationMeta(
    'logementId',
  );
  @override
  late final GeneratedColumn<int> logementId = GeneratedColumn<int>(
    'logement_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES logements (id)',
    ),
  );
  static const VerificationMeta _interventionIdMeta = const VerificationMeta(
    'interventionId',
  );
  @override
  late final GeneratedColumn<int> interventionId = GeneratedColumn<int>(
    'intervention_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES interventions (id)',
    ),
  );
  static const VerificationMeta _inspectionIdMeta = const VerificationMeta(
    'inspectionId',
  );
  @override
  late final GeneratedColumn<int> inspectionId = GeneratedColumn<int>(
    'inspection_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES inspections (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PhotoType, String> photoType =
      GeneratedColumn<String>(
        'photo_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PhotoType>($PhotosTable.$converterphotoType);
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _driveFileIdMeta = const VerificationMeta(
    'driveFileId',
  );
  @override
  late final GeneratedColumn<String> driveFileId = GeneratedColumn<String>(
    'drive_file_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($PhotosTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logementId,
    interventionId,
    inspectionId,
    photoType,
    fileName,
    localFilePath,
    driveFileId,
    takenAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('logement_id')) {
      context.handle(
        _logementIdMeta,
        logementId.isAcceptableOrUnknown(data['logement_id']!, _logementIdMeta),
      );
    }
    if (data.containsKey('intervention_id')) {
      context.handle(
        _interventionIdMeta,
        interventionId.isAcceptableOrUnknown(
          data['intervention_id']!,
          _interventionIdMeta,
        ),
      );
    }
    if (data.containsKey('inspection_id')) {
      context.handle(
        _inspectionIdMeta,
        inspectionId.isAcceptableOrUnknown(
          data['inspection_id']!,
          _inspectionIdMeta,
        ),
      );
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('drive_file_id')) {
      context.handle(
        _driveFileIdMeta,
        driveFileId.isAcceptableOrUnknown(
          data['drive_file_id']!,
          _driveFileIdMeta,
        ),
      );
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logement_id'],
      ),
      interventionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intervention_id'],
      ),
      inspectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}inspection_id'],
      ),
      photoType: $PhotosTable.$converterphotoType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}photo_type'],
        )!,
      ),
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      driveFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drive_file_id'],
      ),
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $PhotosTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PhotoType, String, String> $converterphotoType =
      const EnumNameConverter<PhotoType>(PhotoType.values);
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Photo extends DataClass implements Insertable<Photo> {
  final int id;
  final int? logementId;
  final int? interventionId;
  final int? inspectionId;
  final PhotoType photoType;
  final String fileName;
  final String localFilePath;
  final String? driveFileId;
  final DateTime takenAt;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Photo({
    required this.id,
    this.logementId,
    this.interventionId,
    this.inspectionId,
    required this.photoType,
    required this.fileName,
    required this.localFilePath,
    this.driveFileId,
    required this.takenAt,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || logementId != null) {
      map['logement_id'] = Variable<int>(logementId);
    }
    if (!nullToAbsent || interventionId != null) {
      map['intervention_id'] = Variable<int>(interventionId);
    }
    if (!nullToAbsent || inspectionId != null) {
      map['inspection_id'] = Variable<int>(inspectionId);
    }
    {
      map['photo_type'] = Variable<String>(
        $PhotosTable.$converterphotoType.toSql(photoType),
      );
    }
    map['file_name'] = Variable<String>(fileName);
    map['local_file_path'] = Variable<String>(localFilePath);
    if (!nullToAbsent || driveFileId != null) {
      map['drive_file_id'] = Variable<String>(driveFileId);
    }
    map['taken_at'] = Variable<DateTime>(takenAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $PhotosTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      logementId: logementId == null && nullToAbsent
          ? const Value.absent()
          : Value(logementId),
      interventionId: interventionId == null && nullToAbsent
          ? const Value.absent()
          : Value(interventionId),
      inspectionId: inspectionId == null && nullToAbsent
          ? const Value.absent()
          : Value(inspectionId),
      photoType: Value(photoType),
      fileName: Value(fileName),
      localFilePath: Value(localFilePath),
      driveFileId: driveFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(driveFileId),
      takenAt: Value(takenAt),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<int>(json['id']),
      logementId: serializer.fromJson<int?>(json['logementId']),
      interventionId: serializer.fromJson<int?>(json['interventionId']),
      inspectionId: serializer.fromJson<int?>(json['inspectionId']),
      photoType: $PhotosTable.$converterphotoType.fromJson(
        serializer.fromJson<String>(json['photoType']),
      ),
      fileName: serializer.fromJson<String>(json['fileName']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      driveFileId: serializer.fromJson<String?>(json['driveFileId']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $PhotosTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logementId': serializer.toJson<int?>(logementId),
      'interventionId': serializer.toJson<int?>(interventionId),
      'inspectionId': serializer.toJson<int?>(inspectionId),
      'photoType': serializer.toJson<String>(
        $PhotosTable.$converterphotoType.toJson(photoType),
      ),
      'fileName': serializer.toJson<String>(fileName),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'driveFileId': serializer.toJson<String?>(driveFileId),
      'takenAt': serializer.toJson<DateTime>(takenAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $PhotosTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Photo copyWith({
    int? id,
    Value<int?> logementId = const Value.absent(),
    Value<int?> interventionId = const Value.absent(),
    Value<int?> inspectionId = const Value.absent(),
    PhotoType? photoType,
    String? fileName,
    String? localFilePath,
    Value<String?> driveFileId = const Value.absent(),
    DateTime? takenAt,
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Photo(
    id: id ?? this.id,
    logementId: logementId.present ? logementId.value : this.logementId,
    interventionId: interventionId.present
        ? interventionId.value
        : this.interventionId,
    inspectionId: inspectionId.present ? inspectionId.value : this.inspectionId,
    photoType: photoType ?? this.photoType,
    fileName: fileName ?? this.fileName,
    localFilePath: localFilePath ?? this.localFilePath,
    driveFileId: driveFileId.present ? driveFileId.value : this.driveFileId,
    takenAt: takenAt ?? this.takenAt,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      logementId: data.logementId.present
          ? data.logementId.value
          : this.logementId,
      interventionId: data.interventionId.present
          ? data.interventionId.value
          : this.interventionId,
      inspectionId: data.inspectionId.present
          ? data.inspectionId.value
          : this.inspectionId,
      photoType: data.photoType.present ? data.photoType.value : this.photoType,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      driveFileId: data.driveFileId.present
          ? data.driveFileId.value
          : this.driveFileId,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('logementId: $logementId, ')
          ..write('interventionId: $interventionId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('photoType: $photoType, ')
          ..write('fileName: $fileName, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('takenAt: $takenAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    logementId,
    interventionId,
    inspectionId,
    photoType,
    fileName,
    localFilePath,
    driveFileId,
    takenAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.logementId == this.logementId &&
          other.interventionId == this.interventionId &&
          other.inspectionId == this.inspectionId &&
          other.photoType == this.photoType &&
          other.fileName == this.fileName &&
          other.localFilePath == this.localFilePath &&
          other.driveFileId == this.driveFileId &&
          other.takenAt == this.takenAt &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> id;
  final Value<int?> logementId;
  final Value<int?> interventionId;
  final Value<int?> inspectionId;
  final Value<PhotoType> photoType;
  final Value<String> fileName;
  final Value<String> localFilePath;
  final Value<String?> driveFileId;
  final Value<DateTime> takenAt;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.logementId = const Value.absent(),
    this.interventionId = const Value.absent(),
    this.inspectionId = const Value.absent(),
    this.photoType = const Value.absent(),
    this.fileName = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.driveFileId = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    this.logementId = const Value.absent(),
    this.interventionId = const Value.absent(),
    this.inspectionId = const Value.absent(),
    required PhotoType photoType,
    required String fileName,
    required String localFilePath,
    this.driveFileId = const Value.absent(),
    required DateTime takenAt,
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : photoType = Value(photoType),
       fileName = Value(fileName),
       localFilePath = Value(localFilePath),
       takenAt = Value(takenAt);
  static Insertable<Photo> custom({
    Expression<int>? id,
    Expression<int>? logementId,
    Expression<int>? interventionId,
    Expression<int>? inspectionId,
    Expression<String>? photoType,
    Expression<String>? fileName,
    Expression<String>? localFilePath,
    Expression<String>? driveFileId,
    Expression<DateTime>? takenAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logementId != null) 'logement_id': logementId,
      if (interventionId != null) 'intervention_id': interventionId,
      if (inspectionId != null) 'inspection_id': inspectionId,
      if (photoType != null) 'photo_type': photoType,
      if (fileName != null) 'file_name': fileName,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (driveFileId != null) 'drive_file_id': driveFileId,
      if (takenAt != null) 'taken_at': takenAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  PhotosCompanion copyWith({
    Value<int>? id,
    Value<int?>? logementId,
    Value<int?>? interventionId,
    Value<int?>? inspectionId,
    Value<PhotoType>? photoType,
    Value<String>? fileName,
    Value<String>? localFilePath,
    Value<String?>? driveFileId,
    Value<DateTime>? takenAt,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      logementId: logementId ?? this.logementId,
      interventionId: interventionId ?? this.interventionId,
      inspectionId: inspectionId ?? this.inspectionId,
      photoType: photoType ?? this.photoType,
      fileName: fileName ?? this.fileName,
      localFilePath: localFilePath ?? this.localFilePath,
      driveFileId: driveFileId ?? this.driveFileId,
      takenAt: takenAt ?? this.takenAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logementId.present) {
      map['logement_id'] = Variable<int>(logementId.value);
    }
    if (interventionId.present) {
      map['intervention_id'] = Variable<int>(interventionId.value);
    }
    if (inspectionId.present) {
      map['inspection_id'] = Variable<int>(inspectionId.value);
    }
    if (photoType.present) {
      map['photo_type'] = Variable<String>(
        $PhotosTable.$converterphotoType.toSql(photoType.value),
      );
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (driveFileId.present) {
      map['drive_file_id'] = Variable<String>(driveFileId.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $PhotosTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('logementId: $logementId, ')
          ..write('interventionId: $interventionId, ')
          ..write('inspectionId: $inspectionId, ')
          ..write('photoType: $photoType, ')
          ..write('fileName: $fileName, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('driveFileId: $driveFileId, ')
          ..write('takenAt: $takenAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $RapportsTable extends Rapports with TableInfo<$RapportsTable, Rapport> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RapportsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _referenceMeta = const VerificationMeta(
    'reference',
  );
  @override
  late final GeneratedColumn<String> reference = GeneratedColumn<String>(
    'reference',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _logementIdMeta = const VerificationMeta(
    'logementId',
  );
  @override
  late final GeneratedColumn<int> logementId = GeneratedColumn<int>(
    'logement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES logements (id)',
    ),
  );
  static const VerificationMeta _periodMonthMeta = const VerificationMeta(
    'periodMonth',
  );
  @override
  late final GeneratedColumn<String> periodMonth = GeneratedColumn<String>(
    'period_month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HousingCondition?, String>
  generalCondition =
      GeneratedColumn<String>(
        'general_condition',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HousingCondition?>(
        $RapportsTable.$convertergeneralConditionn,
      );
  static const VerificationMeta _inspectionDoneMeta = const VerificationMeta(
    'inspectionDone',
  );
  @override
  late final GeneratedColumn<bool> inspectionDone = GeneratedColumn<bool>(
    'inspection_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("inspection_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _anomaliesMeta = const VerificationMeta(
    'anomalies',
  );
  @override
  late final GeneratedColumn<String> anomalies = GeneratedColumn<String>(
    'anomalies',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _interventionsDoneMeta = const VerificationMeta(
    'interventionsDone',
  );
  @override
  late final GeneratedColumn<String> interventionsDone =
      GeneratedColumn<String>(
        'interventions_done',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _totalExpensesMeta = const VerificationMeta(
    'totalExpenses',
  );
  @override
  late final GeneratedColumn<double> totalExpenses = GeneratedColumn<double>(
    'total_expenses',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recommendationsMeta = const VerificationMeta(
    'recommendations',
  );
  @override
  late final GeneratedColumn<String> recommendations = GeneratedColumn<String>(
    'recommendations',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextActionsMeta = const VerificationMeta(
    'nextActions',
  );
  @override
  late final GeneratedColumn<String> nextActions = GeneratedColumn<String>(
    'next_actions',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pdfLocalPathMeta = const VerificationMeta(
    'pdfLocalPath',
  );
  @override
  late final GeneratedColumn<String> pdfLocalPath = GeneratedColumn<String>(
    'pdf_local_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _generatedAtMeta = const VerificationMeta(
    'generatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
    'generated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($RapportsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    reference,
    logementId,
    periodMonth,
    generalCondition,
    inspectionDone,
    anomalies,
    interventionsDone,
    totalExpenses,
    recommendations,
    nextActions,
    pdfLocalPath,
    generatedAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rapports';
  @override
  VerificationContext validateIntegrity(
    Insertable<Rapport> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reference')) {
      context.handle(
        _referenceMeta,
        reference.isAcceptableOrUnknown(data['reference']!, _referenceMeta),
      );
    } else if (isInserting) {
      context.missing(_referenceMeta);
    }
    if (data.containsKey('logement_id')) {
      context.handle(
        _logementIdMeta,
        logementId.isAcceptableOrUnknown(data['logement_id']!, _logementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logementIdMeta);
    }
    if (data.containsKey('period_month')) {
      context.handle(
        _periodMonthMeta,
        periodMonth.isAcceptableOrUnknown(
          data['period_month']!,
          _periodMonthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodMonthMeta);
    }
    if (data.containsKey('inspection_done')) {
      context.handle(
        _inspectionDoneMeta,
        inspectionDone.isAcceptableOrUnknown(
          data['inspection_done']!,
          _inspectionDoneMeta,
        ),
      );
    }
    if (data.containsKey('anomalies')) {
      context.handle(
        _anomaliesMeta,
        anomalies.isAcceptableOrUnknown(data['anomalies']!, _anomaliesMeta),
      );
    }
    if (data.containsKey('interventions_done')) {
      context.handle(
        _interventionsDoneMeta,
        interventionsDone.isAcceptableOrUnknown(
          data['interventions_done']!,
          _interventionsDoneMeta,
        ),
      );
    }
    if (data.containsKey('total_expenses')) {
      context.handle(
        _totalExpensesMeta,
        totalExpenses.isAcceptableOrUnknown(
          data['total_expenses']!,
          _totalExpensesMeta,
        ),
      );
    }
    if (data.containsKey('recommendations')) {
      context.handle(
        _recommendationsMeta,
        recommendations.isAcceptableOrUnknown(
          data['recommendations']!,
          _recommendationsMeta,
        ),
      );
    }
    if (data.containsKey('next_actions')) {
      context.handle(
        _nextActionsMeta,
        nextActions.isAcceptableOrUnknown(
          data['next_actions']!,
          _nextActionsMeta,
        ),
      );
    }
    if (data.containsKey('pdf_local_path')) {
      context.handle(
        _pdfLocalPathMeta,
        pdfLocalPath.isAcceptableOrUnknown(
          data['pdf_local_path']!,
          _pdfLocalPathMeta,
        ),
      );
    }
    if (data.containsKey('generated_at')) {
      context.handle(
        _generatedAtMeta,
        generatedAt.isAcceptableOrUnknown(
          data['generated_at']!,
          _generatedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Rapport map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Rapport(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference'],
      )!,
      logementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}logement_id'],
      )!,
      periodMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_month'],
      )!,
      generalCondition: $RapportsTable.$convertergeneralConditionn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}general_condition'],
        ),
      ),
      inspectionDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}inspection_done'],
      )!,
      anomalies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anomalies'],
      ),
      interventionsDone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}interventions_done'],
      ),
      totalExpenses: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_expenses'],
      ),
      recommendations: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recommendations'],
      ),
      nextActions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}next_actions'],
      ),
      pdfLocalPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_local_path'],
      ),
      generatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}generated_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $RapportsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $RapportsTable createAlias(String alias) {
    return $RapportsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HousingCondition, String, String>
  $convertergeneralCondition = const EnumNameConverter<HousingCondition>(
    HousingCondition.values,
  );
  static JsonTypeConverter2<HousingCondition?, String?, String?>
  $convertergeneralConditionn = JsonTypeConverter2.asNullable(
    $convertergeneralCondition,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class Rapport extends DataClass implements Insertable<Rapport> {
  final int id;
  final String reference;
  final int logementId;
  final String periodMonth;
  final HousingCondition? generalCondition;
  final bool inspectionDone;
  final String? anomalies;
  final String? interventionsDone;
  final double? totalExpenses;
  final String? recommendations;
  final String? nextActions;
  final String? pdfLocalPath;
  final DateTime? generatedAt;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const Rapport({
    required this.id,
    required this.reference,
    required this.logementId,
    required this.periodMonth,
    this.generalCondition,
    required this.inspectionDone,
    this.anomalies,
    this.interventionsDone,
    this.totalExpenses,
    this.recommendations,
    this.nextActions,
    this.pdfLocalPath,
    this.generatedAt,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reference'] = Variable<String>(reference);
    map['logement_id'] = Variable<int>(logementId);
    map['period_month'] = Variable<String>(periodMonth);
    if (!nullToAbsent || generalCondition != null) {
      map['general_condition'] = Variable<String>(
        $RapportsTable.$convertergeneralConditionn.toSql(generalCondition),
      );
    }
    map['inspection_done'] = Variable<bool>(inspectionDone);
    if (!nullToAbsent || anomalies != null) {
      map['anomalies'] = Variable<String>(anomalies);
    }
    if (!nullToAbsent || interventionsDone != null) {
      map['interventions_done'] = Variable<String>(interventionsDone);
    }
    if (!nullToAbsent || totalExpenses != null) {
      map['total_expenses'] = Variable<double>(totalExpenses);
    }
    if (!nullToAbsent || recommendations != null) {
      map['recommendations'] = Variable<String>(recommendations);
    }
    if (!nullToAbsent || nextActions != null) {
      map['next_actions'] = Variable<String>(nextActions);
    }
    if (!nullToAbsent || pdfLocalPath != null) {
      map['pdf_local_path'] = Variable<String>(pdfLocalPath);
    }
    if (!nullToAbsent || generatedAt != null) {
      map['generated_at'] = Variable<DateTime>(generatedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $RapportsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  RapportsCompanion toCompanion(bool nullToAbsent) {
    return RapportsCompanion(
      id: Value(id),
      reference: Value(reference),
      logementId: Value(logementId),
      periodMonth: Value(periodMonth),
      generalCondition: generalCondition == null && nullToAbsent
          ? const Value.absent()
          : Value(generalCondition),
      inspectionDone: Value(inspectionDone),
      anomalies: anomalies == null && nullToAbsent
          ? const Value.absent()
          : Value(anomalies),
      interventionsDone: interventionsDone == null && nullToAbsent
          ? const Value.absent()
          : Value(interventionsDone),
      totalExpenses: totalExpenses == null && nullToAbsent
          ? const Value.absent()
          : Value(totalExpenses),
      recommendations: recommendations == null && nullToAbsent
          ? const Value.absent()
          : Value(recommendations),
      nextActions: nextActions == null && nullToAbsent
          ? const Value.absent()
          : Value(nextActions),
      pdfLocalPath: pdfLocalPath == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfLocalPath),
      generatedAt: generatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(generatedAt),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory Rapport.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Rapport(
      id: serializer.fromJson<int>(json['id']),
      reference: serializer.fromJson<String>(json['reference']),
      logementId: serializer.fromJson<int>(json['logementId']),
      periodMonth: serializer.fromJson<String>(json['periodMonth']),
      generalCondition: $RapportsTable.$convertergeneralConditionn.fromJson(
        serializer.fromJson<String?>(json['generalCondition']),
      ),
      inspectionDone: serializer.fromJson<bool>(json['inspectionDone']),
      anomalies: serializer.fromJson<String?>(json['anomalies']),
      interventionsDone: serializer.fromJson<String?>(
        json['interventionsDone'],
      ),
      totalExpenses: serializer.fromJson<double?>(json['totalExpenses']),
      recommendations: serializer.fromJson<String?>(json['recommendations']),
      nextActions: serializer.fromJson<String?>(json['nextActions']),
      pdfLocalPath: serializer.fromJson<String?>(json['pdfLocalPath']),
      generatedAt: serializer.fromJson<DateTime?>(json['generatedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $RapportsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reference': serializer.toJson<String>(reference),
      'logementId': serializer.toJson<int>(logementId),
      'periodMonth': serializer.toJson<String>(periodMonth),
      'generalCondition': serializer.toJson<String?>(
        $RapportsTable.$convertergeneralConditionn.toJson(generalCondition),
      ),
      'inspectionDone': serializer.toJson<bool>(inspectionDone),
      'anomalies': serializer.toJson<String?>(anomalies),
      'interventionsDone': serializer.toJson<String?>(interventionsDone),
      'totalExpenses': serializer.toJson<double?>(totalExpenses),
      'recommendations': serializer.toJson<String?>(recommendations),
      'nextActions': serializer.toJson<String?>(nextActions),
      'pdfLocalPath': serializer.toJson<String?>(pdfLocalPath),
      'generatedAt': serializer.toJson<DateTime?>(generatedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $RapportsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Rapport copyWith({
    int? id,
    String? reference,
    int? logementId,
    String? periodMonth,
    Value<HousingCondition?> generalCondition = const Value.absent(),
    bool? inspectionDone,
    Value<String?> anomalies = const Value.absent(),
    Value<String?> interventionsDone = const Value.absent(),
    Value<double?> totalExpenses = const Value.absent(),
    Value<String?> recommendations = const Value.absent(),
    Value<String?> nextActions = const Value.absent(),
    Value<String?> pdfLocalPath = const Value.absent(),
    Value<DateTime?> generatedAt = const Value.absent(),
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => Rapport(
    id: id ?? this.id,
    reference: reference ?? this.reference,
    logementId: logementId ?? this.logementId,
    periodMonth: periodMonth ?? this.periodMonth,
    generalCondition: generalCondition.present
        ? generalCondition.value
        : this.generalCondition,
    inspectionDone: inspectionDone ?? this.inspectionDone,
    anomalies: anomalies.present ? anomalies.value : this.anomalies,
    interventionsDone: interventionsDone.present
        ? interventionsDone.value
        : this.interventionsDone,
    totalExpenses: totalExpenses.present
        ? totalExpenses.value
        : this.totalExpenses,
    recommendations: recommendations.present
        ? recommendations.value
        : this.recommendations,
    nextActions: nextActions.present ? nextActions.value : this.nextActions,
    pdfLocalPath: pdfLocalPath.present ? pdfLocalPath.value : this.pdfLocalPath,
    generatedAt: generatedAt.present ? generatedAt.value : this.generatedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Rapport copyWithCompanion(RapportsCompanion data) {
    return Rapport(
      id: data.id.present ? data.id.value : this.id,
      reference: data.reference.present ? data.reference.value : this.reference,
      logementId: data.logementId.present
          ? data.logementId.value
          : this.logementId,
      periodMonth: data.periodMonth.present
          ? data.periodMonth.value
          : this.periodMonth,
      generalCondition: data.generalCondition.present
          ? data.generalCondition.value
          : this.generalCondition,
      inspectionDone: data.inspectionDone.present
          ? data.inspectionDone.value
          : this.inspectionDone,
      anomalies: data.anomalies.present ? data.anomalies.value : this.anomalies,
      interventionsDone: data.interventionsDone.present
          ? data.interventionsDone.value
          : this.interventionsDone,
      totalExpenses: data.totalExpenses.present
          ? data.totalExpenses.value
          : this.totalExpenses,
      recommendations: data.recommendations.present
          ? data.recommendations.value
          : this.recommendations,
      nextActions: data.nextActions.present
          ? data.nextActions.value
          : this.nextActions,
      pdfLocalPath: data.pdfLocalPath.present
          ? data.pdfLocalPath.value
          : this.pdfLocalPath,
      generatedAt: data.generatedAt.present
          ? data.generatedAt.value
          : this.generatedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Rapport(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('inspectionDone: $inspectionDone, ')
          ..write('anomalies: $anomalies, ')
          ..write('interventionsDone: $interventionsDone, ')
          ..write('totalExpenses: $totalExpenses, ')
          ..write('recommendations: $recommendations, ')
          ..write('nextActions: $nextActions, ')
          ..write('pdfLocalPath: $pdfLocalPath, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    reference,
    logementId,
    periodMonth,
    generalCondition,
    inspectionDone,
    anomalies,
    interventionsDone,
    totalExpenses,
    recommendations,
    nextActions,
    pdfLocalPath,
    generatedAt,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Rapport &&
          other.id == this.id &&
          other.reference == this.reference &&
          other.logementId == this.logementId &&
          other.periodMonth == this.periodMonth &&
          other.generalCondition == this.generalCondition &&
          other.inspectionDone == this.inspectionDone &&
          other.anomalies == this.anomalies &&
          other.interventionsDone == this.interventionsDone &&
          other.totalExpenses == this.totalExpenses &&
          other.recommendations == this.recommendations &&
          other.nextActions == this.nextActions &&
          other.pdfLocalPath == this.pdfLocalPath &&
          other.generatedAt == this.generatedAt &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class RapportsCompanion extends UpdateCompanion<Rapport> {
  final Value<int> id;
  final Value<String> reference;
  final Value<int> logementId;
  final Value<String> periodMonth;
  final Value<HousingCondition?> generalCondition;
  final Value<bool> inspectionDone;
  final Value<String?> anomalies;
  final Value<String?> interventionsDone;
  final Value<double?> totalExpenses;
  final Value<String?> recommendations;
  final Value<String?> nextActions;
  final Value<String?> pdfLocalPath;
  final Value<DateTime?> generatedAt;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const RapportsCompanion({
    this.id = const Value.absent(),
    this.reference = const Value.absent(),
    this.logementId = const Value.absent(),
    this.periodMonth = const Value.absent(),
    this.generalCondition = const Value.absent(),
    this.inspectionDone = const Value.absent(),
    this.anomalies = const Value.absent(),
    this.interventionsDone = const Value.absent(),
    this.totalExpenses = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.nextActions = const Value.absent(),
    this.pdfLocalPath = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  RapportsCompanion.insert({
    this.id = const Value.absent(),
    required String reference,
    required int logementId,
    required String periodMonth,
    this.generalCondition = const Value.absent(),
    this.inspectionDone = const Value.absent(),
    this.anomalies = const Value.absent(),
    this.interventionsDone = const Value.absent(),
    this.totalExpenses = const Value.absent(),
    this.recommendations = const Value.absent(),
    this.nextActions = const Value.absent(),
    this.pdfLocalPath = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : reference = Value(reference),
       logementId = Value(logementId),
       periodMonth = Value(periodMonth);
  static Insertable<Rapport> custom({
    Expression<int>? id,
    Expression<String>? reference,
    Expression<int>? logementId,
    Expression<String>? periodMonth,
    Expression<String>? generalCondition,
    Expression<bool>? inspectionDone,
    Expression<String>? anomalies,
    Expression<String>? interventionsDone,
    Expression<double>? totalExpenses,
    Expression<String>? recommendations,
    Expression<String>? nextActions,
    Expression<String>? pdfLocalPath,
    Expression<DateTime>? generatedAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reference != null) 'reference': reference,
      if (logementId != null) 'logement_id': logementId,
      if (periodMonth != null) 'period_month': periodMonth,
      if (generalCondition != null) 'general_condition': generalCondition,
      if (inspectionDone != null) 'inspection_done': inspectionDone,
      if (anomalies != null) 'anomalies': anomalies,
      if (interventionsDone != null) 'interventions_done': interventionsDone,
      if (totalExpenses != null) 'total_expenses': totalExpenses,
      if (recommendations != null) 'recommendations': recommendations,
      if (nextActions != null) 'next_actions': nextActions,
      if (pdfLocalPath != null) 'pdf_local_path': pdfLocalPath,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  RapportsCompanion copyWith({
    Value<int>? id,
    Value<String>? reference,
    Value<int>? logementId,
    Value<String>? periodMonth,
    Value<HousingCondition?>? generalCondition,
    Value<bool>? inspectionDone,
    Value<String?>? anomalies,
    Value<String?>? interventionsDone,
    Value<double?>? totalExpenses,
    Value<String?>? recommendations,
    Value<String?>? nextActions,
    Value<String?>? pdfLocalPath,
    Value<DateTime?>? generatedAt,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return RapportsCompanion(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      logementId: logementId ?? this.logementId,
      periodMonth: periodMonth ?? this.periodMonth,
      generalCondition: generalCondition ?? this.generalCondition,
      inspectionDone: inspectionDone ?? this.inspectionDone,
      anomalies: anomalies ?? this.anomalies,
      interventionsDone: interventionsDone ?? this.interventionsDone,
      totalExpenses: totalExpenses ?? this.totalExpenses,
      recommendations: recommendations ?? this.recommendations,
      nextActions: nextActions ?? this.nextActions,
      pdfLocalPath: pdfLocalPath ?? this.pdfLocalPath,
      generatedAt: generatedAt ?? this.generatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reference.present) {
      map['reference'] = Variable<String>(reference.value);
    }
    if (logementId.present) {
      map['logement_id'] = Variable<int>(logementId.value);
    }
    if (periodMonth.present) {
      map['period_month'] = Variable<String>(periodMonth.value);
    }
    if (generalCondition.present) {
      map['general_condition'] = Variable<String>(
        $RapportsTable.$convertergeneralConditionn.toSql(
          generalCondition.value,
        ),
      );
    }
    if (inspectionDone.present) {
      map['inspection_done'] = Variable<bool>(inspectionDone.value);
    }
    if (anomalies.present) {
      map['anomalies'] = Variable<String>(anomalies.value);
    }
    if (interventionsDone.present) {
      map['interventions_done'] = Variable<String>(interventionsDone.value);
    }
    if (totalExpenses.present) {
      map['total_expenses'] = Variable<double>(totalExpenses.value);
    }
    if (recommendations.present) {
      map['recommendations'] = Variable<String>(recommendations.value);
    }
    if (nextActions.present) {
      map['next_actions'] = Variable<String>(nextActions.value);
    }
    if (pdfLocalPath.present) {
      map['pdf_local_path'] = Variable<String>(pdfLocalPath.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $RapportsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RapportsCompanion(')
          ..write('id: $id, ')
          ..write('reference: $reference, ')
          ..write('logementId: $logementId, ')
          ..write('periodMonth: $periodMonth, ')
          ..write('generalCondition: $generalCondition, ')
          ..write('inspectionDone: $inspectionDone, ')
          ..write('anomalies: $anomalies, ')
          ..write('interventionsDone: $interventionsDone, ')
          ..write('totalExpenses: $totalExpenses, ')
          ..write('recommendations: $recommendations, ')
          ..write('nextActions: $nextActions, ')
          ..write('pdfLocalPath: $pdfLocalPath, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $ModelesDocumentsTable extends ModelesDocuments
    with TableInfo<$ModelesDocumentsTable, ModelesDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ModelesDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DocumentTemplateType, String>
  documentType =
      GeneratedColumn<String>(
        'document_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<DocumentTemplateType>(
        $ModelesDocumentsTable.$converterdocumentType,
      );
  static const VerificationMeta _contentTemplateMeta = const VerificationMeta(
    'contentTemplate',
  );
  @override
  late final GeneratedColumn<String> contentTemplate = GeneratedColumn<String>(
    'content_template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>($ModelesDocumentsTable.$convertersyncStatus);
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    documentType,
    contentTemplate,
    isActive,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'modeles_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ModelesDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('content_template')) {
      context.handle(
        _contentTemplateMeta,
        contentTemplate.isAcceptableOrUnknown(
          data['content_template']!,
          _contentTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTemplateMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ModelesDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ModelesDocument(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      documentType: $ModelesDocumentsTable.$converterdocumentType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}document_type'],
        )!,
      ),
      contentTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_template'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $ModelesDocumentsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $ModelesDocumentsTable createAlias(String alias) {
    return $ModelesDocumentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DocumentTemplateType, String, String>
  $converterdocumentType = const EnumNameConverter<DocumentTemplateType>(
    DocumentTemplateType.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class ModelesDocument extends DataClass implements Insertable<ModelesDocument> {
  final int id;
  final String name;
  final DocumentTemplateType documentType;
  final String contentTemplate;
  final bool isActive;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const ModelesDocument({
    required this.id,
    required this.name,
    required this.documentType,
    required this.contentTemplate,
    required this.isActive,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['document_type'] = Variable<String>(
        $ModelesDocumentsTable.$converterdocumentType.toSql(documentType),
      );
    }
    map['content_template'] = Variable<String>(contentTemplate);
    map['is_active'] = Variable<bool>(isActive);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $ModelesDocumentsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  ModelesDocumentsCompanion toCompanion(bool nullToAbsent) {
    return ModelesDocumentsCompanion(
      id: Value(id),
      name: Value(name),
      documentType: Value(documentType),
      contentTemplate: Value(contentTemplate),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory ModelesDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ModelesDocument(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      documentType: $ModelesDocumentsTable.$converterdocumentType.fromJson(
        serializer.fromJson<String>(json['documentType']),
      ),
      contentTemplate: serializer.fromJson<String>(json['contentTemplate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $ModelesDocumentsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'documentType': serializer.toJson<String>(
        $ModelesDocumentsTable.$converterdocumentType.toJson(documentType),
      ),
      'contentTemplate': serializer.toJson<String>(contentTemplate),
      'isActive': serializer.toJson<bool>(isActive),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $ModelesDocumentsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  ModelesDocument copyWith({
    int? id,
    String? name,
    DocumentTemplateType? documentType,
    String? contentTemplate,
    bool? isActive,
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => ModelesDocument(
    id: id ?? this.id,
    name: name ?? this.name,
    documentType: documentType ?? this.documentType,
    contentTemplate: contentTemplate ?? this.contentTemplate,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ModelesDocument copyWithCompanion(ModelesDocumentsCompanion data) {
    return ModelesDocument(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      contentTemplate: data.contentTemplate.present
          ? data.contentTemplate.value
          : this.contentTemplate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ModelesDocument(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentType: $documentType, ')
          ..write('contentTemplate: $contentTemplate, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    documentType,
    contentTemplate,
    isActive,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ModelesDocument &&
          other.id == this.id &&
          other.name == this.name &&
          other.documentType == this.documentType &&
          other.contentTemplate == this.contentTemplate &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class ModelesDocumentsCompanion extends UpdateCompanion<ModelesDocument> {
  final Value<int> id;
  final Value<String> name;
  final Value<DocumentTemplateType> documentType;
  final Value<String> contentTemplate;
  final Value<bool> isActive;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const ModelesDocumentsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.documentType = const Value.absent(),
    this.contentTemplate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  ModelesDocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DocumentTemplateType documentType,
    required String contentTemplate,
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : name = Value(name),
       documentType = Value(documentType),
       contentTemplate = Value(contentTemplate);
  static Insertable<ModelesDocument> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? documentType,
    Expression<String>? contentTemplate,
    Expression<bool>? isActive,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (documentType != null) 'document_type': documentType,
      if (contentTemplate != null) 'content_template': contentTemplate,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  ModelesDocumentsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DocumentTemplateType>? documentType,
    Value<String>? contentTemplate,
    Value<bool>? isActive,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return ModelesDocumentsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      documentType: documentType ?? this.documentType,
      contentTemplate: contentTemplate ?? this.contentTemplate,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<String>(
        $ModelesDocumentsTable.$converterdocumentType.toSql(documentType.value),
      );
    }
    if (contentTemplate.present) {
      map['content_template'] = Variable<String>(contentTemplate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $ModelesDocumentsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ModelesDocumentsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('documentType: $documentType, ')
          ..write('contentTemplate: $contentTemplate, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $CalendrierEvenementsTable extends CalendrierEvenements
    with TableInfo<$CalendrierEvenementsTable, CalendrierEvenement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendrierEvenementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<CalendarEventType, String>
  eventType =
      GeneratedColumn<String>(
        'event_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CalendarEventType>(
        $CalendrierEvenementsTable.$convertereventType,
      );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventDateMeta = const VerificationMeta(
    'eventDate',
  );
  @override
  late final GeneratedColumn<DateTime> eventDate = GeneratedColumn<DateTime>(
    'event_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _relatedReferenceMeta = const VerificationMeta(
    'relatedReference',
  );
  @override
  late final GeneratedColumn<String> relatedReference = GeneratedColumn<String>(
    'related_reference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _responsibleUserIdMeta = const VerificationMeta(
    'responsibleUserId',
  );
  @override
  late final GeneratedColumn<int> responsibleUserId = GeneratedColumn<int>(
    'responsible_user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<CalendarEventStatus, String>
  status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<CalendarEventStatus>(
        $CalendrierEvenementsTable.$converterstatus,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedByMeta = const VerificationMeta(
    'updatedBy',
  );
  @override
  late final GeneratedColumn<String> updatedBy = GeneratedColumn<String>(
    'updated_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => SyncStatus.local.name,
      ).withConverter<SyncStatus>(
        $CalendrierEvenementsTable.$convertersyncStatus,
      );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventType,
    title,
    eventDate,
    relatedReference,
    responsibleUserId,
    status,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendrier_evenements';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendrierEvenement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('event_date')) {
      context.handle(
        _eventDateMeta,
        eventDate.isAcceptableOrUnknown(data['event_date']!, _eventDateMeta),
      );
    } else if (isInserting) {
      context.missing(_eventDateMeta);
    }
    if (data.containsKey('related_reference')) {
      context.handle(
        _relatedReferenceMeta,
        relatedReference.isAcceptableOrUnknown(
          data['related_reference']!,
          _relatedReferenceMeta,
        ),
      );
    }
    if (data.containsKey('responsible_user_id')) {
      context.handle(
        _responsibleUserIdMeta,
        responsibleUserId.isAcceptableOrUnknown(
          data['responsible_user_id']!,
          _responsibleUserIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('updated_by')) {
      context.handle(
        _updatedByMeta,
        updatedBy.isAcceptableOrUnknown(data['updated_by']!, _updatedByMeta),
      );
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendrierEvenement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendrierEvenement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventType: $CalendrierEvenementsTable.$convertereventType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}event_type'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      eventDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}event_date'],
      )!,
      relatedReference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}related_reference'],
      ),
      responsibleUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}responsible_user_id'],
      ),
      status: $CalendrierEvenementsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      updatedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_by'],
      ),
      syncStatus: $CalendrierEvenementsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $CalendrierEvenementsTable createAlias(String alias) {
    return $CalendrierEvenementsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<CalendarEventType, String, String>
  $convertereventType = const EnumNameConverter<CalendarEventType>(
    CalendarEventType.values,
  );
  static JsonTypeConverter2<CalendarEventStatus, String, String>
  $converterstatus = const EnumNameConverter<CalendarEventStatus>(
    CalendarEventStatus.values,
  );
  static JsonTypeConverter2<SyncStatus, String, String> $convertersyncStatus =
      const EnumNameConverter<SyncStatus>(SyncStatus.values);
}

class CalendrierEvenement extends DataClass
    implements Insertable<CalendrierEvenement> {
  final int id;
  final CalendarEventType eventType;
  final String title;
  final DateTime eventDate;
  final String? relatedReference;
  final int? responsibleUserId;
  final CalendarEventStatus status;
  final DateTime updatedAt;
  final String? updatedBy;
  final SyncStatus syncStatus;
  final bool isDeleted;
  const CalendrierEvenement({
    required this.id,
    required this.eventType,
    required this.title,
    required this.eventDate,
    this.relatedReference,
    this.responsibleUserId,
    required this.status,
    required this.updatedAt,
    this.updatedBy,
    required this.syncStatus,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['event_type'] = Variable<String>(
        $CalendrierEvenementsTable.$convertereventType.toSql(eventType),
      );
    }
    map['title'] = Variable<String>(title);
    map['event_date'] = Variable<DateTime>(eventDate);
    if (!nullToAbsent || relatedReference != null) {
      map['related_reference'] = Variable<String>(relatedReference);
    }
    if (!nullToAbsent || responsibleUserId != null) {
      map['responsible_user_id'] = Variable<int>(responsibleUserId);
    }
    {
      map['status'] = Variable<String>(
        $CalendrierEvenementsTable.$converterstatus.toSql(status),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || updatedBy != null) {
      map['updated_by'] = Variable<String>(updatedBy);
    }
    {
      map['sync_status'] = Variable<String>(
        $CalendrierEvenementsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  CalendrierEvenementsCompanion toCompanion(bool nullToAbsent) {
    return CalendrierEvenementsCompanion(
      id: Value(id),
      eventType: Value(eventType),
      title: Value(title),
      eventDate: Value(eventDate),
      relatedReference: relatedReference == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedReference),
      responsibleUserId: responsibleUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(responsibleUserId),
      status: Value(status),
      updatedAt: Value(updatedAt),
      updatedBy: updatedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedBy),
      syncStatus: Value(syncStatus),
      isDeleted: Value(isDeleted),
    );
  }

  factory CalendrierEvenement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendrierEvenement(
      id: serializer.fromJson<int>(json['id']),
      eventType: $CalendrierEvenementsTable.$convertereventType.fromJson(
        serializer.fromJson<String>(json['eventType']),
      ),
      title: serializer.fromJson<String>(json['title']),
      eventDate: serializer.fromJson<DateTime>(json['eventDate']),
      relatedReference: serializer.fromJson<String?>(json['relatedReference']),
      responsibleUserId: serializer.fromJson<int?>(json['responsibleUserId']),
      status: $CalendrierEvenementsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      updatedBy: serializer.fromJson<String?>(json['updatedBy']),
      syncStatus: $CalendrierEvenementsTable.$convertersyncStatus.fromJson(
        serializer.fromJson<String>(json['syncStatus']),
      ),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventType': serializer.toJson<String>(
        $CalendrierEvenementsTable.$convertereventType.toJson(eventType),
      ),
      'title': serializer.toJson<String>(title),
      'eventDate': serializer.toJson<DateTime>(eventDate),
      'relatedReference': serializer.toJson<String?>(relatedReference),
      'responsibleUserId': serializer.toJson<int?>(responsibleUserId),
      'status': serializer.toJson<String>(
        $CalendrierEvenementsTable.$converterstatus.toJson(status),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'updatedBy': serializer.toJson<String?>(updatedBy),
      'syncStatus': serializer.toJson<String>(
        $CalendrierEvenementsTable.$convertersyncStatus.toJson(syncStatus),
      ),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  CalendrierEvenement copyWith({
    int? id,
    CalendarEventType? eventType,
    String? title,
    DateTime? eventDate,
    Value<String?> relatedReference = const Value.absent(),
    Value<int?> responsibleUserId = const Value.absent(),
    CalendarEventStatus? status,
    DateTime? updatedAt,
    Value<String?> updatedBy = const Value.absent(),
    SyncStatus? syncStatus,
    bool? isDeleted,
  }) => CalendrierEvenement(
    id: id ?? this.id,
    eventType: eventType ?? this.eventType,
    title: title ?? this.title,
    eventDate: eventDate ?? this.eventDate,
    relatedReference: relatedReference.present
        ? relatedReference.value
        : this.relatedReference,
    responsibleUserId: responsibleUserId.present
        ? responsibleUserId.value
        : this.responsibleUserId,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    updatedBy: updatedBy.present ? updatedBy.value : this.updatedBy,
    syncStatus: syncStatus ?? this.syncStatus,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  CalendrierEvenement copyWithCompanion(CalendrierEvenementsCompanion data) {
    return CalendrierEvenement(
      id: data.id.present ? data.id.value : this.id,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      title: data.title.present ? data.title.value : this.title,
      eventDate: data.eventDate.present ? data.eventDate.value : this.eventDate,
      relatedReference: data.relatedReference.present
          ? data.relatedReference.value
          : this.relatedReference,
      responsibleUserId: data.responsibleUserId.present
          ? data.responsibleUserId.value
          : this.responsibleUserId,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      updatedBy: data.updatedBy.present ? data.updatedBy.value : this.updatedBy,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendrierEvenement(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('title: $title, ')
          ..write('eventDate: $eventDate, ')
          ..write('relatedReference: $relatedReference, ')
          ..write('responsibleUserId: $responsibleUserId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventType,
    title,
    eventDate,
    relatedReference,
    responsibleUserId,
    status,
    updatedAt,
    updatedBy,
    syncStatus,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendrierEvenement &&
          other.id == this.id &&
          other.eventType == this.eventType &&
          other.title == this.title &&
          other.eventDate == this.eventDate &&
          other.relatedReference == this.relatedReference &&
          other.responsibleUserId == this.responsibleUserId &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.updatedBy == this.updatedBy &&
          other.syncStatus == this.syncStatus &&
          other.isDeleted == this.isDeleted);
}

class CalendrierEvenementsCompanion
    extends UpdateCompanion<CalendrierEvenement> {
  final Value<int> id;
  final Value<CalendarEventType> eventType;
  final Value<String> title;
  final Value<DateTime> eventDate;
  final Value<String?> relatedReference;
  final Value<int?> responsibleUserId;
  final Value<CalendarEventStatus> status;
  final Value<DateTime> updatedAt;
  final Value<String?> updatedBy;
  final Value<SyncStatus> syncStatus;
  final Value<bool> isDeleted;
  const CalendrierEvenementsCompanion({
    this.id = const Value.absent(),
    this.eventType = const Value.absent(),
    this.title = const Value.absent(),
    this.eventDate = const Value.absent(),
    this.relatedReference = const Value.absent(),
    this.responsibleUserId = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  CalendrierEvenementsCompanion.insert({
    this.id = const Value.absent(),
    required CalendarEventType eventType,
    required String title,
    required DateTime eventDate,
    this.relatedReference = const Value.absent(),
    this.responsibleUserId = const Value.absent(),
    required CalendarEventStatus status,
    this.updatedAt = const Value.absent(),
    this.updatedBy = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.isDeleted = const Value.absent(),
  }) : eventType = Value(eventType),
       title = Value(title),
       eventDate = Value(eventDate),
       status = Value(status);
  static Insertable<CalendrierEvenement> custom({
    Expression<int>? id,
    Expression<String>? eventType,
    Expression<String>? title,
    Expression<DateTime>? eventDate,
    Expression<String>? relatedReference,
    Expression<int>? responsibleUserId,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<String>? updatedBy,
    Expression<String>? syncStatus,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventType != null) 'event_type': eventType,
      if (title != null) 'title': title,
      if (eventDate != null) 'event_date': eventDate,
      if (relatedReference != null) 'related_reference': relatedReference,
      if (responsibleUserId != null) 'responsible_user_id': responsibleUserId,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (updatedBy != null) 'updated_by': updatedBy,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  CalendrierEvenementsCompanion copyWith({
    Value<int>? id,
    Value<CalendarEventType>? eventType,
    Value<String>? title,
    Value<DateTime>? eventDate,
    Value<String?>? relatedReference,
    Value<int?>? responsibleUserId,
    Value<CalendarEventStatus>? status,
    Value<DateTime>? updatedAt,
    Value<String?>? updatedBy,
    Value<SyncStatus>? syncStatus,
    Value<bool>? isDeleted,
  }) {
    return CalendrierEvenementsCompanion(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      eventDate: eventDate ?? this.eventDate,
      relatedReference: relatedReference ?? this.relatedReference,
      responsibleUserId: responsibleUserId ?? this.responsibleUserId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      updatedBy: updatedBy ?? this.updatedBy,
      syncStatus: syncStatus ?? this.syncStatus,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(
        $CalendrierEvenementsTable.$convertereventType.toSql(eventType.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (eventDate.present) {
      map['event_date'] = Variable<DateTime>(eventDate.value);
    }
    if (relatedReference.present) {
      map['related_reference'] = Variable<String>(relatedReference.value);
    }
    if (responsibleUserId.present) {
      map['responsible_user_id'] = Variable<int>(responsibleUserId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $CalendrierEvenementsTable.$converterstatus.toSql(status.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (updatedBy.present) {
      map['updated_by'] = Variable<String>(updatedBy.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $CalendrierEvenementsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendrierEvenementsCompanion(')
          ..write('id: $id, ')
          ..write('eventType: $eventType, ')
          ..write('title: $title, ')
          ..write('eventDate: $eventDate, ')
          ..write('relatedReference: $relatedReference, ')
          ..write('responsibleUserId: $responsibleUserId, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('updatedBy: $updatedBy, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $SyncLogTable extends SyncLog with TableInfo<$SyncLogTable, SyncLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityTableMeta = const VerificationMeta(
    'entityTable',
  );
  @override
  late final GeneratedColumn<String> entityTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncLogStatus?, String>
  lastSyncStatus = GeneratedColumn<String>(
    'last_sync_status',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<SyncLogStatus?>($SyncLogTable.$converterlastSyncStatusn);
  @override
  List<GeneratedColumn> get $columns => [
    entityTable,
    lastSyncedAt,
    lastSyncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('table_name')) {
      context.handle(
        _entityTableMeta,
        entityTable.isAcceptableOrUnknown(
          data['table_name']!,
          _entityTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_entityTableMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entityTable};
  @override
  SyncLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncLogData(
      entityTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      lastSyncStatus: $SyncLogTable.$converterlastSyncStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}last_sync_status'],
        ),
      ),
    );
  }

  @override
  $SyncLogTable createAlias(String alias) {
    return $SyncLogTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncLogStatus, String, String>
  $converterlastSyncStatus = const EnumNameConverter<SyncLogStatus>(
    SyncLogStatus.values,
  );
  static JsonTypeConverter2<SyncLogStatus?, String?, String?>
  $converterlastSyncStatusn = JsonTypeConverter2.asNullable(
    $converterlastSyncStatus,
  );
}

class SyncLogData extends DataClass implements Insertable<SyncLogData> {
  final String entityTable;
  final DateTime? lastSyncedAt;
  final SyncLogStatus? lastSyncStatus;
  const SyncLogData({
    required this.entityTable,
    this.lastSyncedAt,
    this.lastSyncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['table_name'] = Variable<String>(entityTable);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || lastSyncStatus != null) {
      map['last_sync_status'] = Variable<String>(
        $SyncLogTable.$converterlastSyncStatusn.toSql(lastSyncStatus),
      );
    }
    return map;
  }

  SyncLogCompanion toCompanion(bool nullToAbsent) {
    return SyncLogCompanion(
      entityTable: Value(entityTable),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastSyncStatus: lastSyncStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncStatus),
    );
  }

  factory SyncLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncLogData(
      entityTable: serializer.fromJson<String>(json['entityTable']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      lastSyncStatus: $SyncLogTable.$converterlastSyncStatusn.fromJson(
        serializer.fromJson<String?>(json['lastSyncStatus']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entityTable': serializer.toJson<String>(entityTable),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'lastSyncStatus': serializer.toJson<String?>(
        $SyncLogTable.$converterlastSyncStatusn.toJson(lastSyncStatus),
      ),
    };
  }

  SyncLogData copyWith({
    String? entityTable,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<SyncLogStatus?> lastSyncStatus = const Value.absent(),
  }) => SyncLogData(
    entityTable: entityTable ?? this.entityTable,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    lastSyncStatus: lastSyncStatus.present
        ? lastSyncStatus.value
        : this.lastSyncStatus,
  );
  SyncLogData copyWithCompanion(SyncLogCompanion data) {
    return SyncLogData(
      entityTable: data.entityTable.present
          ? data.entityTable.value
          : this.entityTable,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastSyncStatus: data.lastSyncStatus.present
          ? data.lastSyncStatus.value
          : this.lastSyncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogData(')
          ..write('entityTable: $entityTable, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastSyncStatus: $lastSyncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(entityTable, lastSyncedAt, lastSyncStatus);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncLogData &&
          other.entityTable == this.entityTable &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastSyncStatus == this.lastSyncStatus);
}

class SyncLogCompanion extends UpdateCompanion<SyncLogData> {
  final Value<String> entityTable;
  final Value<DateTime?> lastSyncedAt;
  final Value<SyncLogStatus?> lastSyncStatus;
  final Value<int> rowid;
  const SyncLogCompanion({
    this.entityTable = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastSyncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncLogCompanion.insert({
    required String entityTable,
    this.lastSyncedAt = const Value.absent(),
    this.lastSyncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entityTable = Value(entityTable);
  static Insertable<SyncLogData> custom({
    Expression<String>? entityTable,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? lastSyncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entityTable != null) 'table_name': entityTable,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastSyncStatus != null) 'last_sync_status': lastSyncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncLogCompanion copyWith({
    Value<String>? entityTable,
    Value<DateTime?>? lastSyncedAt,
    Value<SyncLogStatus?>? lastSyncStatus,
    Value<int>? rowid,
  }) {
    return SyncLogCompanion(
      entityTable: entityTable ?? this.entityTable,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastSyncStatus: lastSyncStatus ?? this.lastSyncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityTable.present) {
      map['table_name'] = Variable<String>(entityTable.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastSyncStatus.present) {
      map['last_sync_status'] = Variable<String>(
        $SyncLogTable.$converterlastSyncStatusn.toSql(lastSyncStatus.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncLogCompanion(')
          ..write('entityTable: $entityTable, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastSyncStatus: $lastSyncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $ClientsTable clients = $ClientsTable(this);
  late final $LogementsTable logements = $LogementsTable(this);
  late final $AbonnementsTable abonnements = $AbonnementsTable(this);
  late final $InspectionsTable inspections = $InspectionsTable(this);
  late final $InspectionItemsTable inspectionItems = $InspectionItemsTable(
    this,
  );
  late final $PrestatairesTable prestataires = $PrestatairesTable(this);
  late final $InterventionsTable interventions = $InterventionsTable(this);
  late final $FinancesTable finances = $FinancesTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final $RapportsTable rapports = $RapportsTable(this);
  late final $ModelesDocumentsTable modelesDocuments = $ModelesDocumentsTable(
    this,
  );
  late final $CalendrierEvenementsTable calendrierEvenements =
      $CalendrierEvenementsTable(this);
  late final $SyncLogTable syncLog = $SyncLogTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final LogementsDao logementsDao = LogementsDao(this as AppDatabase);
  late final AbonnementsDao abonnementsDao = AbonnementsDao(
    this as AppDatabase,
  );
  late final InspectionsDao inspectionsDao = InspectionsDao(
    this as AppDatabase,
  );
  late final InspectionItemsDao inspectionItemsDao = InspectionItemsDao(
    this as AppDatabase,
  );
  late final InterventionsDao interventionsDao = InterventionsDao(
    this as AppDatabase,
  );
  late final PrestatairesDao prestatairesDao = PrestatairesDao(
    this as AppDatabase,
  );
  late final FinancesDao financesDao = FinancesDao(this as AppDatabase);
  late final PhotosDao photosDao = PhotosDao(this as AppDatabase);
  late final RapportsDao rapportsDao = RapportsDao(this as AppDatabase);
  late final ModelesDocumentsDao modelesDocumentsDao = ModelesDocumentsDao(
    this as AppDatabase,
  );
  late final CalendrierEvenementsDao calendrierEvenementsDao =
      CalendrierEvenementsDao(this as AppDatabase);
  late final SyncLogDao syncLogDao = SyncLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    clients,
    logements,
    abonnements,
    inspections,
    inspectionItems,
    prestataires,
    interventions,
    finances,
    photos,
    rapports,
    modelesDocuments,
    calendrierEvenements,
    syncLog,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String uid,
      required String fullName,
      required String email,
      required AppRole roleId,
      Value<bool> active,
      Value<DateTime?> lastSyncedAt,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> uid,
      Value<String> fullName,
      Value<String> email,
      Value<AppRole> roleId,
      Value<bool> active,
      Value<DateTime?> lastSyncedAt,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AppRole, AppRole, String> get roleId =>
      $composableBuilder(
        column: $table.roleId,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get roleId => $composableBuilder(
    column: $table.roleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AppRole, String> get roleId =>
      $composableBuilder(column: $table.roleId, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<AppRole> roleId = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                uid: uid,
                fullName: fullName,
                email: email,
                roleId: roleId,
                active: active,
                lastSyncedAt: lastSyncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uid,
                required String fullName,
                required String email,
                required AppRole roleId,
                Value<bool> active = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                uid: uid,
                fullName: fullName,
                email: email,
                roleId: roleId,
                active: active,
                lastSyncedAt: lastSyncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$ClientsTableCreateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      required String reference,
      required String fullName,
      required String phone,
      Value<String?> whatsapp,
      Value<String?> email,
      required String country,
      required String city,
      required String clientType,
      Value<String?> logementReference,
      Value<String?> subscriptionFormula,
      Value<DateTime?> startDate,
      Value<DateTime?> renewalDate,
      required ClientStatus status,
      Value<DateTime?> lastContactDate,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$ClientsTableUpdateCompanionBuilder =
    ClientsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<String> fullName,
      Value<String> phone,
      Value<String?> whatsapp,
      Value<String?> email,
      Value<String> country,
      Value<String> city,
      Value<String> clientType,
      Value<String?> logementReference,
      Value<String?> subscriptionFormula,
      Value<DateTime?> startDate,
      Value<DateTime?> renewalDate,
      Value<ClientStatus> status,
      Value<DateTime?> lastContactDate,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$ClientsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsTable, Client> {
  $$ClientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LogementsTable, List<Logement>>
  _logementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.logements,
    aliasName: 'clients__id__logements__client_id',
  );

  $$LogementsTableProcessedTableManager get logementsRefs {
    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_logementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AbonnementsTable, List<Abonnement>>
  _abonnementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.abonnements,
    aliasName: 'clients__id__abonnements__client_id',
  );

  $$AbonnementsTableProcessedTableManager get abonnementsRefs {
    final manager = $$AbonnementsTableTableManager(
      $_db,
      $_db.abonnements,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_abonnementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InterventionsTable, List<Intervention>>
  _interventionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interventions,
    aliasName: 'clients__id__interventions__client_id',
  );

  $$InterventionsTableProcessedTableManager get interventionsRefs {
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_interventionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinancesTable, List<Finance>> _financesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.finances,
    aliasName: 'clients__id__finances__related_client_id',
  );

  $$FinancesTableProcessedTableManager get financesRefs {
    final manager = $$FinancesTableTableManager(
      $_db,
      $_db.finances,
    ).filter((f) => f.relatedClientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_financesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatsapp => $composableBuilder(
    column: $table.whatsapp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get logementReference => $composableBuilder(
    column: $table.logementReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subscriptionFormula => $composableBuilder(
    column: $table.subscriptionFormula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ClientStatus, ClientStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> logementsRefs(
    Expression<bool> Function($$LogementsTableFilterComposer f) f,
  ) {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> abonnementsRefs(
    Expression<bool> Function($$AbonnementsTableFilterComposer f) f,
  ) {
    final $$AbonnementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonnements,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonnementsTableFilterComposer(
            $db: $db,
            $table: $db.abonnements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> interventionsRefs(
    Expression<bool> Function($$InterventionsTableFilterComposer f) f,
  ) {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> financesRefs(
    Expression<bool> Function($$FinancesTableFilterComposer f) f,
  ) {
    final $$FinancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finances,
      getReferencedColumn: (t) => t.relatedClientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancesTableFilterComposer(
            $db: $db,
            $table: $db.finances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatsapp => $composableBuilder(
    column: $table.whatsapp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get country => $composableBuilder(
    column: $table.country,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get logementReference => $composableBuilder(
    column: $table.logementReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subscriptionFormula => $composableBuilder(
    column: $table.subscriptionFormula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get whatsapp =>
      $composableBuilder(column: $table.whatsapp, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get clientType => $composableBuilder(
    column: $table.clientType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get logementReference => $composableBuilder(
    column: $table.logementReference,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subscriptionFormula => $composableBuilder(
    column: $table.subscriptionFormula,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ClientStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get lastContactDate => $composableBuilder(
    column: $table.lastContactDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> logementsRefs<T extends Object>(
    Expression<T> Function($$LogementsTableAnnotationComposer a) f,
  ) {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> abonnementsRefs<T extends Object>(
    Expression<T> Function($$AbonnementsTableAnnotationComposer a) f,
  ) {
    final $$AbonnementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonnements,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonnementsTableAnnotationComposer(
            $db: $db,
            $table: $db.abonnements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> interventionsRefs<T extends Object>(
    Expression<T> Function($$InterventionsTableAnnotationComposer a) f,
  ) {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.clientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> financesRefs<T extends Object>(
    Expression<T> Function($$FinancesTableAnnotationComposer a) f,
  ) {
    final $$FinancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finances,
      getReferencedColumn: (t) => t.relatedClientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancesTableAnnotationComposer(
            $db: $db,
            $table: $db.finances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ClientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClientsTable,
          Client,
          $$ClientsTableFilterComposer,
          $$ClientsTableOrderingComposer,
          $$ClientsTableAnnotationComposer,
          $$ClientsTableCreateCompanionBuilder,
          $$ClientsTableUpdateCompanionBuilder,
          (Client, $$ClientsTableReferences),
          Client,
          PrefetchHooks Function({
            bool logementsRefs,
            bool abonnementsRefs,
            bool interventionsRefs,
            bool financesRefs,
          })
        > {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String?> whatsapp = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> country = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> clientType = const Value.absent(),
                Value<String?> logementReference = const Value.absent(),
                Value<String?> subscriptionFormula = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> renewalDate = const Value.absent(),
                Value<ClientStatus> status = const Value.absent(),
                Value<DateTime?> lastContactDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ClientsCompanion(
                id: id,
                reference: reference,
                fullName: fullName,
                phone: phone,
                whatsapp: whatsapp,
                email: email,
                country: country,
                city: city,
                clientType: clientType,
                logementReference: logementReference,
                subscriptionFormula: subscriptionFormula,
                startDate: startDate,
                renewalDate: renewalDate,
                status: status,
                lastContactDate: lastContactDate,
                notes: notes,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required String fullName,
                required String phone,
                Value<String?> whatsapp = const Value.absent(),
                Value<String?> email = const Value.absent(),
                required String country,
                required String city,
                required String clientType,
                Value<String?> logementReference = const Value.absent(),
                Value<String?> subscriptionFormula = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> renewalDate = const Value.absent(),
                required ClientStatus status,
                Value<DateTime?> lastContactDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ClientsCompanion.insert(
                id: id,
                reference: reference,
                fullName: fullName,
                phone: phone,
                whatsapp: whatsapp,
                email: email,
                country: country,
                city: city,
                clientType: clientType,
                logementReference: logementReference,
                subscriptionFormula: subscriptionFormula,
                startDate: startDate,
                renewalDate: renewalDate,
                status: status,
                lastContactDate: lastContactDate,
                notes: notes,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ClientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                logementsRefs = false,
                abonnementsRefs = false,
                interventionsRefs = false,
                financesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (logementsRefs) db.logements,
                    if (abonnementsRefs) db.abonnements,
                    if (interventionsRefs) db.interventions,
                    if (financesRefs) db.finances,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (logementsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Logement
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._logementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).logementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (abonnementsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Abonnement
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._abonnementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).abonnementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (interventionsRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Intervention
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._interventionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).interventionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.clientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (financesRefs)
                        await $_getPrefetchedData<
                          Client,
                          $ClientsTable,
                          Finance
                        >(
                          currentTable: table,
                          referencedTable: $$ClientsTableReferences
                              ._financesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ClientsTableReferences(
                                db,
                                table,
                                p0,
                              ).financesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedClientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ClientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClientsTable,
      Client,
      $$ClientsTableFilterComposer,
      $$ClientsTableOrderingComposer,
      $$ClientsTableAnnotationComposer,
      $$ClientsTableCreateCompanionBuilder,
      $$ClientsTableUpdateCompanionBuilder,
      (Client, $$ClientsTableReferences),
      Client,
      PrefetchHooks Function({
        bool logementsRefs,
        bool abonnementsRefs,
        bool interventionsRefs,
        bool financesRefs,
      })
    >;
typedef $$LogementsTableCreateCompanionBuilder =
    LogementsCompanion Function({
      Value<int> id,
      required String reference,
      Value<int?> clientId,
      required String address,
      Value<String?> neighborhood,
      Value<String?> housingType,
      Value<int?> bedroomsCount,
      Value<String?> occupancy,
      Value<String?> localContact,
      Value<String?> guardian,
      Value<int?> keysCount,
      Value<String?> mainEquipment,
      Value<DateTime?> lastInspectionDate,
      Value<DateTime?> nextInspectionDate,
      Value<HousingCondition?> generalCondition,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$LogementsTableUpdateCompanionBuilder =
    LogementsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<int?> clientId,
      Value<String> address,
      Value<String?> neighborhood,
      Value<String?> housingType,
      Value<int?> bedroomsCount,
      Value<String?> occupancy,
      Value<String?> localContact,
      Value<String?> guardian,
      Value<int?> keysCount,
      Value<String?> mainEquipment,
      Value<DateTime?> lastInspectionDate,
      Value<DateTime?> nextInspectionDate,
      Value<HousingCondition?> generalCondition,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$LogementsTableReferences
    extends BaseReferences<_$AppDatabase, $LogementsTable, Logement> {
  $$LogementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('logements__client_id__clients__id');

  $$ClientsTableProcessedTableManager? get clientId {
    final $_column = $_itemColumn<int>('client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AbonnementsTable, List<Abonnement>>
  _abonnementsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.abonnements,
    aliasName: 'logements__id__abonnements__logement_id',
  );

  $$AbonnementsTableProcessedTableManager get abonnementsRefs {
    final manager = $$AbonnementsTableTableManager(
      $_db,
      $_db.abonnements,
    ).filter((f) => f.logementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_abonnementsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InspectionsTable, List<Inspection>>
  _inspectionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspections,
    aliasName: 'logements__id__inspections__logement_id',
  );

  $$InspectionsTableProcessedTableManager get inspectionsRefs {
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.logementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inspectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$InterventionsTable, List<Intervention>>
  _interventionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interventions,
    aliasName: 'logements__id__interventions__logement_id',
  );

  $$InterventionsTableProcessedTableManager get interventionsRefs {
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.logementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_interventionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'logements__id__photos__logement_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.logementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RapportsTable, List<Rapport>> _rapportsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rapports,
    aliasName: 'logements__id__rapports__logement_id',
  );

  $$RapportsTableProcessedTableManager get rapportsRefs {
    final manager = $$RapportsTableTableManager(
      $_db,
      $_db.rapports,
    ).filter((f) => f.logementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rapportsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LogementsTableFilterComposer
    extends Composer<_$AppDatabase, $LogementsTable> {
  $$LogementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get housingType => $composableBuilder(
    column: $table.housingType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedroomsCount => $composableBuilder(
    column: $table.bedroomsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occupancy => $composableBuilder(
    column: $table.occupancy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localContact => $composableBuilder(
    column: $table.localContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get guardian => $composableBuilder(
    column: $table.guardian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get keysCount => $composableBuilder(
    column: $table.keysCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mainEquipment => $composableBuilder(
    column: $table.mainEquipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HousingCondition?, HousingCondition, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> abonnementsRefs(
    Expression<bool> Function($$AbonnementsTableFilterComposer f) f,
  ) {
    final $$AbonnementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonnements,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonnementsTableFilterComposer(
            $db: $db,
            $table: $db.abonnements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> inspectionsRefs(
    Expression<bool> Function($$InspectionsTableFilterComposer f) f,
  ) {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> interventionsRefs(
    Expression<bool> Function($$InterventionsTableFilterComposer f) f,
  ) {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rapportsRefs(
    Expression<bool> Function($$RapportsTableFilterComposer f) f,
  ) {
    final $$RapportsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rapports,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RapportsTableFilterComposer(
            $db: $db,
            $table: $db.rapports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LogementsTableOrderingComposer
    extends Composer<_$AppDatabase, $LogementsTable> {
  $$LogementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get housingType => $composableBuilder(
    column: $table.housingType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedroomsCount => $composableBuilder(
    column: $table.bedroomsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occupancy => $composableBuilder(
    column: $table.occupancy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localContact => $composableBuilder(
    column: $table.localContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get guardian => $composableBuilder(
    column: $table.guardian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get keysCount => $composableBuilder(
    column: $table.keysCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mainEquipment => $composableBuilder(
    column: $table.mainEquipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogementsTable> {
  $$LogementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get neighborhood => $composableBuilder(
    column: $table.neighborhood,
    builder: (column) => column,
  );

  GeneratedColumn<String> get housingType => $composableBuilder(
    column: $table.housingType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedroomsCount => $composableBuilder(
    column: $table.bedroomsCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occupancy =>
      $composableBuilder(column: $table.occupancy, builder: (column) => column);

  GeneratedColumn<String> get localContact => $composableBuilder(
    column: $table.localContact,
    builder: (column) => column,
  );

  GeneratedColumn<String> get guardian =>
      $composableBuilder(column: $table.guardian, builder: (column) => column);

  GeneratedColumn<int> get keysCount =>
      $composableBuilder(column: $table.keysCount, builder: (column) => column);

  GeneratedColumn<String> get mainEquipment => $composableBuilder(
    column: $table.mainEquipment,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HousingCondition?, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> abonnementsRefs<T extends Object>(
    Expression<T> Function($$AbonnementsTableAnnotationComposer a) f,
  ) {
    final $$AbonnementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.abonnements,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AbonnementsTableAnnotationComposer(
            $db: $db,
            $table: $db.abonnements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> inspectionsRefs<T extends Object>(
    Expression<T> Function($$InspectionsTableAnnotationComposer a) f,
  ) {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> interventionsRefs<T extends Object>(
    Expression<T> Function($$InterventionsTableAnnotationComposer a) f,
  ) {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rapportsRefs<T extends Object>(
    Expression<T> Function($$RapportsTableAnnotationComposer a) f,
  ) {
    final $$RapportsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rapports,
      getReferencedColumn: (t) => t.logementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RapportsTableAnnotationComposer(
            $db: $db,
            $table: $db.rapports,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LogementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogementsTable,
          Logement,
          $$LogementsTableFilterComposer,
          $$LogementsTableOrderingComposer,
          $$LogementsTableAnnotationComposer,
          $$LogementsTableCreateCompanionBuilder,
          $$LogementsTableUpdateCompanionBuilder,
          (Logement, $$LogementsTableReferences),
          Logement,
          PrefetchHooks Function({
            bool clientId,
            bool abonnementsRefs,
            bool inspectionsRefs,
            bool interventionsRefs,
            bool photosRefs,
            bool rapportsRefs,
          })
        > {
  $$LogementsTableTableManager(_$AppDatabase db, $LogementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int?> clientId = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> housingType = const Value.absent(),
                Value<int?> bedroomsCount = const Value.absent(),
                Value<String?> occupancy = const Value.absent(),
                Value<String?> localContact = const Value.absent(),
                Value<String?> guardian = const Value.absent(),
                Value<int?> keysCount = const Value.absent(),
                Value<String?> mainEquipment = const Value.absent(),
                Value<DateTime?> lastInspectionDate = const Value.absent(),
                Value<DateTime?> nextInspectionDate = const Value.absent(),
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => LogementsCompanion(
                id: id,
                reference: reference,
                clientId: clientId,
                address: address,
                neighborhood: neighborhood,
                housingType: housingType,
                bedroomsCount: bedroomsCount,
                occupancy: occupancy,
                localContact: localContact,
                guardian: guardian,
                keysCount: keysCount,
                mainEquipment: mainEquipment,
                lastInspectionDate: lastInspectionDate,
                nextInspectionDate: nextInspectionDate,
                generalCondition: generalCondition,
                notes: notes,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                Value<int?> clientId = const Value.absent(),
                required String address,
                Value<String?> neighborhood = const Value.absent(),
                Value<String?> housingType = const Value.absent(),
                Value<int?> bedroomsCount = const Value.absent(),
                Value<String?> occupancy = const Value.absent(),
                Value<String?> localContact = const Value.absent(),
                Value<String?> guardian = const Value.absent(),
                Value<int?> keysCount = const Value.absent(),
                Value<String?> mainEquipment = const Value.absent(),
                Value<DateTime?> lastInspectionDate = const Value.absent(),
                Value<DateTime?> nextInspectionDate = const Value.absent(),
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => LogementsCompanion.insert(
                id: id,
                reference: reference,
                clientId: clientId,
                address: address,
                neighborhood: neighborhood,
                housingType: housingType,
                bedroomsCount: bedroomsCount,
                occupancy: occupancy,
                localContact: localContact,
                guardian: guardian,
                keysCount: keysCount,
                mainEquipment: mainEquipment,
                lastInspectionDate: lastInspectionDate,
                nextInspectionDate: nextInspectionDate,
                generalCondition: generalCondition,
                notes: notes,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LogementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                clientId = false,
                abonnementsRefs = false,
                inspectionsRefs = false,
                interventionsRefs = false,
                photosRefs = false,
                rapportsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (abonnementsRefs) db.abonnements,
                    if (inspectionsRefs) db.inspections,
                    if (interventionsRefs) db.interventions,
                    if (photosRefs) db.photos,
                    if (rapportsRefs) db.rapports,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (clientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clientId,
                                    referencedTable: $$LogementsTableReferences
                                        ._clientIdTable(db),
                                    referencedColumn: $$LogementsTableReferences
                                        ._clientIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (abonnementsRefs)
                        await $_getPrefetchedData<
                          Logement,
                          $LogementsTable,
                          Abonnement
                        >(
                          currentTable: table,
                          referencedTable: $$LogementsTableReferences
                              ._abonnementsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LogementsTableReferences(
                                db,
                                table,
                                p0,
                              ).abonnementsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.logementId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (inspectionsRefs)
                        await $_getPrefetchedData<
                          Logement,
                          $LogementsTable,
                          Inspection
                        >(
                          currentTable: table,
                          referencedTable: $$LogementsTableReferences
                              ._inspectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LogementsTableReferences(
                                db,
                                table,
                                p0,
                              ).inspectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.logementId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (interventionsRefs)
                        await $_getPrefetchedData<
                          Logement,
                          $LogementsTable,
                          Intervention
                        >(
                          currentTable: table,
                          referencedTable: $$LogementsTableReferences
                              ._interventionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LogementsTableReferences(
                                db,
                                table,
                                p0,
                              ).interventionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.logementId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (photosRefs)
                        await $_getPrefetchedData<
                          Logement,
                          $LogementsTable,
                          Photo
                        >(
                          currentTable: table,
                          referencedTable: $$LogementsTableReferences
                              ._photosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LogementsTableReferences(
                                db,
                                table,
                                p0,
                              ).photosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.logementId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rapportsRefs)
                        await $_getPrefetchedData<
                          Logement,
                          $LogementsTable,
                          Rapport
                        >(
                          currentTable: table,
                          referencedTable: $$LogementsTableReferences
                              ._rapportsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LogementsTableReferences(
                                db,
                                table,
                                p0,
                              ).rapportsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.logementId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LogementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogementsTable,
      Logement,
      $$LogementsTableFilterComposer,
      $$LogementsTableOrderingComposer,
      $$LogementsTableAnnotationComposer,
      $$LogementsTableCreateCompanionBuilder,
      $$LogementsTableUpdateCompanionBuilder,
      (Logement, $$LogementsTableReferences),
      Logement,
      PrefetchHooks Function({
        bool clientId,
        bool abonnementsRefs,
        bool inspectionsRefs,
        bool interventionsRefs,
        bool photosRefs,
        bool rapportsRefs,
      })
    >;
typedef $$AbonnementsTableCreateCompanionBuilder =
    AbonnementsCompanion Function({
      Value<int> id,
      required String reference,
      required int clientId,
      required int logementId,
      required String formula,
      required double monthlyPrice,
      required DateTime startDate,
      Value<DateTime?> renewalDate,
      Value<DateTime?> lastPaymentDate,
      Value<DateTime?> nextPaymentDate,
      required PaymentStatus paymentStatus,
      Value<DateTime?> lastInspectionDate,
      Value<DateTime?> nextInspectionDate,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$AbonnementsTableUpdateCompanionBuilder =
    AbonnementsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<int> clientId,
      Value<int> logementId,
      Value<String> formula,
      Value<double> monthlyPrice,
      Value<DateTime> startDate,
      Value<DateTime?> renewalDate,
      Value<DateTime?> lastPaymentDate,
      Value<DateTime?> nextPaymentDate,
      Value<PaymentStatus> paymentStatus,
      Value<DateTime?> lastInspectionDate,
      Value<DateTime?> nextInspectionDate,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$AbonnementsTableReferences
    extends BaseReferences<_$AppDatabase, $AbonnementsTable, Abonnement> {
  $$AbonnementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('abonnements__client_id__clients__id');

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LogementsTable _logementIdTable(_$AppDatabase db) =>
      db.logements.createAlias('abonnements__logement_id__logements__id');

  $$LogementsTableProcessedTableManager get logementId {
    final $_column = $_itemColumn<int>('logement_id')!;

    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AbonnementsTableFilterComposer
    extends Composer<_$AppDatabase, $AbonnementsTable> {
  $$AbonnementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPaymentDate => $composableBuilder(
    column: $table.lastPaymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PaymentStatus, PaymentStatus, String>
  get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LogementsTableFilterComposer get logementId {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonnementsTableOrderingComposer
    extends Composer<_$AppDatabase, $AbonnementsTable> {
  $$AbonnementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formula => $composableBuilder(
    column: $table.formula,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPaymentDate => $composableBuilder(
    column: $table.lastPaymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentStatus => $composableBuilder(
    column: $table.paymentStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LogementsTableOrderingComposer get logementId {
    final $$LogementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableOrderingComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonnementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AbonnementsTable> {
  $$AbonnementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get formula =>
      $composableBuilder(column: $table.formula, builder: (column) => column);

  GeneratedColumn<double> get monthlyPrice => $composableBuilder(
    column: $table.monthlyPrice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get renewalDate => $composableBuilder(
    column: $table.renewalDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPaymentDate => $composableBuilder(
    column: $table.lastPaymentDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextPaymentDate => $composableBuilder(
    column: $table.nextPaymentDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PaymentStatus, String> get paymentStatus =>
      $composableBuilder(
        column: $table.paymentStatus,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get lastInspectionDate => $composableBuilder(
    column: $table.lastInspectionDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextInspectionDate => $composableBuilder(
    column: $table.nextInspectionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LogementsTableAnnotationComposer get logementId {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AbonnementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AbonnementsTable,
          Abonnement,
          $$AbonnementsTableFilterComposer,
          $$AbonnementsTableOrderingComposer,
          $$AbonnementsTableAnnotationComposer,
          $$AbonnementsTableCreateCompanionBuilder,
          $$AbonnementsTableUpdateCompanionBuilder,
          (Abonnement, $$AbonnementsTableReferences),
          Abonnement,
          PrefetchHooks Function({bool clientId, bool logementId})
        > {
  $$AbonnementsTableTableManager(_$AppDatabase db, $AbonnementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AbonnementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AbonnementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AbonnementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<int> logementId = const Value.absent(),
                Value<String> formula = const Value.absent(),
                Value<double> monthlyPrice = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> renewalDate = const Value.absent(),
                Value<DateTime?> lastPaymentDate = const Value.absent(),
                Value<DateTime?> nextPaymentDate = const Value.absent(),
                Value<PaymentStatus> paymentStatus = const Value.absent(),
                Value<DateTime?> lastInspectionDate = const Value.absent(),
                Value<DateTime?> nextInspectionDate = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => AbonnementsCompanion(
                id: id,
                reference: reference,
                clientId: clientId,
                logementId: logementId,
                formula: formula,
                monthlyPrice: monthlyPrice,
                startDate: startDate,
                renewalDate: renewalDate,
                lastPaymentDate: lastPaymentDate,
                nextPaymentDate: nextPaymentDate,
                paymentStatus: paymentStatus,
                lastInspectionDate: lastInspectionDate,
                nextInspectionDate: nextInspectionDate,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required int clientId,
                required int logementId,
                required String formula,
                required double monthlyPrice,
                required DateTime startDate,
                Value<DateTime?> renewalDate = const Value.absent(),
                Value<DateTime?> lastPaymentDate = const Value.absent(),
                Value<DateTime?> nextPaymentDate = const Value.absent(),
                required PaymentStatus paymentStatus,
                Value<DateTime?> lastInspectionDate = const Value.absent(),
                Value<DateTime?> nextInspectionDate = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => AbonnementsCompanion.insert(
                id: id,
                reference: reference,
                clientId: clientId,
                logementId: logementId,
                formula: formula,
                monthlyPrice: monthlyPrice,
                startDate: startDate,
                renewalDate: renewalDate,
                lastPaymentDate: lastPaymentDate,
                nextPaymentDate: nextPaymentDate,
                paymentStatus: paymentStatus,
                lastInspectionDate: lastInspectionDate,
                nextInspectionDate: nextInspectionDate,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AbonnementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({clientId = false, logementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (clientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.clientId,
                                referencedTable: $$AbonnementsTableReferences
                                    ._clientIdTable(db),
                                referencedColumn: $$AbonnementsTableReferences
                                    ._clientIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (logementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.logementId,
                                referencedTable: $$AbonnementsTableReferences
                                    ._logementIdTable(db),
                                referencedColumn: $$AbonnementsTableReferences
                                    ._logementIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AbonnementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AbonnementsTable,
      Abonnement,
      $$AbonnementsTableFilterComposer,
      $$AbonnementsTableOrderingComposer,
      $$AbonnementsTableAnnotationComposer,
      $$AbonnementsTableCreateCompanionBuilder,
      $$AbonnementsTableUpdateCompanionBuilder,
      (Abonnement, $$AbonnementsTableReferences),
      Abonnement,
      PrefetchHooks Function({bool clientId, bool logementId})
    >;
typedef $$InspectionsTableCreateCompanionBuilder =
    InspectionsCompanion Function({
      Value<int> id,
      required String reference,
      required int logementId,
      Value<int?> agentUserId,
      required DateTime inspectionDate,
      Value<HousingCondition?> generalCondition,
      Value<String?> recommendations,
      Value<bool> isValidated,
      Value<DateTime?> validatedAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$InspectionsTableUpdateCompanionBuilder =
    InspectionsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<int> logementId,
      Value<int?> agentUserId,
      Value<DateTime> inspectionDate,
      Value<HousingCondition?> generalCondition,
      Value<String?> recommendations,
      Value<bool> isValidated,
      Value<DateTime?> validatedAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$InspectionsTableReferences
    extends BaseReferences<_$AppDatabase, $InspectionsTable, Inspection> {
  $$InspectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LogementsTable _logementIdTable(_$AppDatabase db) =>
      db.logements.createAlias('inspections__logement_id__logements__id');

  $$LogementsTableProcessedTableManager get logementId {
    final $_column = $_itemColumn<int>('logement_id')!;

    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$InspectionItemsTable, List<InspectionItem>>
  _inspectionItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inspectionItems,
    aliasName: 'inspections__id__inspection_items__inspection_id',
  );

  $$InspectionItemsTableProcessedTableManager get inspectionItemsRefs {
    final manager = $$InspectionItemsTableTableManager(
      $_db,
      $_db.inspectionItems,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _inspectionItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'inspections__id__photos__inspection_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.inspectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InspectionsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get agentUserId => $composableBuilder(
    column: $table.agentUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HousingCondition?, HousingCondition, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isValidated => $composableBuilder(
    column: $table.isValidated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$LogementsTableFilterComposer get logementId {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> inspectionItemsRefs(
    Expression<bool> Function($$InspectionItemsTableFilterComposer f) f,
  ) {
    final $$InspectionItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspectionItems,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionItemsTableFilterComposer(
            $db: $db,
            $table: $db.inspectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get agentUserId => $composableBuilder(
    column: $table.agentUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isValidated => $composableBuilder(
    column: $table.isValidated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$LogementsTableOrderingComposer get logementId {
    final $$LogementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableOrderingComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionsTable> {
  $$InspectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<int> get agentUserId => $composableBuilder(
    column: $table.agentUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get inspectionDate => $composableBuilder(
    column: $table.inspectionDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HousingCondition?, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isValidated => $composableBuilder(
    column: $table.isValidated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get validatedAt => $composableBuilder(
    column: $table.validatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$LogementsTableAnnotationComposer get logementId {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> inspectionItemsRefs<T extends Object>(
    Expression<T> Function($$InspectionItemsTableAnnotationComposer a) f,
  ) {
    final $$InspectionItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inspectionItems,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspectionItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.inspectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InspectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionsTable,
          Inspection,
          $$InspectionsTableFilterComposer,
          $$InspectionsTableOrderingComposer,
          $$InspectionsTableAnnotationComposer,
          $$InspectionsTableCreateCompanionBuilder,
          $$InspectionsTableUpdateCompanionBuilder,
          (Inspection, $$InspectionsTableReferences),
          Inspection,
          PrefetchHooks Function({
            bool logementId,
            bool inspectionItemsRefs,
            bool photosRefs,
          })
        > {
  $$InspectionsTableTableManager(_$AppDatabase db, $InspectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int> logementId = const Value.absent(),
                Value<int?> agentUserId = const Value.absent(),
                Value<DateTime> inspectionDate = const Value.absent(),
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<bool> isValidated = const Value.absent(),
                Value<DateTime?> validatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InspectionsCompanion(
                id: id,
                reference: reference,
                logementId: logementId,
                agentUserId: agentUserId,
                inspectionDate: inspectionDate,
                generalCondition: generalCondition,
                recommendations: recommendations,
                isValidated: isValidated,
                validatedAt: validatedAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required int logementId,
                Value<int?> agentUserId = const Value.absent(),
                required DateTime inspectionDate,
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<bool> isValidated = const Value.absent(),
                Value<DateTime?> validatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InspectionsCompanion.insert(
                id: id,
                reference: reference,
                logementId: logementId,
                agentUserId: agentUserId,
                inspectionDate: inspectionDate,
                generalCondition: generalCondition,
                recommendations: recommendations,
                isValidated: isValidated,
                validatedAt: validatedAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                logementId = false,
                inspectionItemsRefs = false,
                photosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (inspectionItemsRefs) db.inspectionItems,
                    if (photosRefs) db.photos,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (logementId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.logementId,
                                    referencedTable:
                                        $$InspectionsTableReferences
                                            ._logementIdTable(db),
                                    referencedColumn:
                                        $$InspectionsTableReferences
                                            ._logementIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (inspectionItemsRefs)
                        await $_getPrefetchedData<
                          Inspection,
                          $InspectionsTable,
                          InspectionItem
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._inspectionItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).inspectionItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (photosRefs)
                        await $_getPrefetchedData<
                          Inspection,
                          $InspectionsTable,
                          Photo
                        >(
                          currentTable: table,
                          referencedTable: $$InspectionsTableReferences
                              ._photosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InspectionsTableReferences(
                                db,
                                table,
                                p0,
                              ).photosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.inspectionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InspectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionsTable,
      Inspection,
      $$InspectionsTableFilterComposer,
      $$InspectionsTableOrderingComposer,
      $$InspectionsTableAnnotationComposer,
      $$InspectionsTableCreateCompanionBuilder,
      $$InspectionsTableUpdateCompanionBuilder,
      (Inspection, $$InspectionsTableReferences),
      Inspection,
      PrefetchHooks Function({
        bool logementId,
        bool inspectionItemsRefs,
        bool photosRefs,
      })
    >;
typedef $$InspectionItemsTableCreateCompanionBuilder =
    InspectionItemsCompanion Function({
      Value<int> id,
      required int inspectionId,
      required InspectionCategory category,
      required String label,
      Value<bool?> isOk,
      Value<String?> observation,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$InspectionItemsTableUpdateCompanionBuilder =
    InspectionItemsCompanion Function({
      Value<int> id,
      Value<int> inspectionId,
      Value<InspectionCategory> category,
      Value<String> label,
      Value<bool?> isOk,
      Value<String?> observation,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$InspectionItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $InspectionItemsTable, InspectionItem> {
  $$InspectionItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) => db
      .inspections
      .createAlias('inspection_items__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager get inspectionId {
    final $_column = $_itemColumn<int>('inspection_id')!;

    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InspectionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InspectionCategory, InspectionCategory, String>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOk => $composableBuilder(
    column: $table.isOk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOk => $composableBuilder(
    column: $table.isOk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InspectionItemsTable> {
  $$InspectionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<InspectionCategory, String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<bool> get isOk =>
      $composableBuilder(column: $table.isOk, builder: (column) => column);

  GeneratedColumn<String> get observation => $composableBuilder(
    column: $table.observation,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InspectionItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InspectionItemsTable,
          InspectionItem,
          $$InspectionItemsTableFilterComposer,
          $$InspectionItemsTableOrderingComposer,
          $$InspectionItemsTableAnnotationComposer,
          $$InspectionItemsTableCreateCompanionBuilder,
          $$InspectionItemsTableUpdateCompanionBuilder,
          (InspectionItem, $$InspectionItemsTableReferences),
          InspectionItem,
          PrefetchHooks Function({bool inspectionId})
        > {
  $$InspectionItemsTableTableManager(
    _$AppDatabase db,
    $InspectionItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InspectionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InspectionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InspectionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> inspectionId = const Value.absent(),
                Value<InspectionCategory> category = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<bool?> isOk = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InspectionItemsCompanion(
                id: id,
                inspectionId: inspectionId,
                category: category,
                label: label,
                isOk: isOk,
                observation: observation,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int inspectionId,
                required InspectionCategory category,
                required String label,
                Value<bool?> isOk = const Value.absent(),
                Value<String?> observation = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InspectionItemsCompanion.insert(
                id: id,
                inspectionId: inspectionId,
                category: category,
                label: label,
                isOk: isOk,
                observation: observation,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InspectionItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inspectionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (inspectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.inspectionId,
                                referencedTable:
                                    $$InspectionItemsTableReferences
                                        ._inspectionIdTable(db),
                                referencedColumn:
                                    $$InspectionItemsTableReferences
                                        ._inspectionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InspectionItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InspectionItemsTable,
      InspectionItem,
      $$InspectionItemsTableFilterComposer,
      $$InspectionItemsTableOrderingComposer,
      $$InspectionItemsTableAnnotationComposer,
      $$InspectionItemsTableCreateCompanionBuilder,
      $$InspectionItemsTableUpdateCompanionBuilder,
      (InspectionItem, $$InspectionItemsTableReferences),
      InspectionItem,
      PrefetchHooks Function({bool inspectionId})
    >;
typedef $$PrestatairesTableCreateCompanionBuilder =
    PrestatairesCompanion Function({
      Value<int> id,
      required String reference,
      required String fullName,
      required String phone,
      required String specialty,
      Value<String?> zone,
      Value<int?> experienceYears,
      Value<bool> identityVerified,
      Value<bool> referencesVerified,
      Value<double?> indicativeRate,
      Value<double?> qualityRating,
      Value<double?> punctualityRating,
      Value<double?> communicationRating,
      required PrestataireStatus status,
      Value<int> interventionsCount,
      Value<DateTime?> lastInterventionDate,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$PrestatairesTableUpdateCompanionBuilder =
    PrestatairesCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<String> fullName,
      Value<String> phone,
      Value<String> specialty,
      Value<String?> zone,
      Value<int?> experienceYears,
      Value<bool> identityVerified,
      Value<bool> referencesVerified,
      Value<double?> indicativeRate,
      Value<double?> qualityRating,
      Value<double?> punctualityRating,
      Value<double?> communicationRating,
      Value<PrestataireStatus> status,
      Value<int> interventionsCount,
      Value<DateTime?> lastInterventionDate,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$PrestatairesTableReferences
    extends BaseReferences<_$AppDatabase, $PrestatairesTable, Prestataire> {
  $$PrestatairesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InterventionsTable, List<Intervention>>
  _interventionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.interventions,
    aliasName: 'prestataires__id__interventions__prestataire_id',
  );

  $$InterventionsTableProcessedTableManager get interventionsRefs {
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.prestataireId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_interventionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FinancesTable, List<Finance>> _financesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.finances,
    aliasName: 'prestataires__id__finances__related_prestataire_id',
  );

  $$FinancesTableProcessedTableManager get financesRefs {
    final manager = $$FinancesTableTableManager($_db, $_db.finances).filter(
      (f) => f.relatedPrestataireId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_financesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PrestatairesTableFilterComposer
    extends Composer<_$AppDatabase, $PrestatairesTable> {
  $$PrestatairesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get identityVerified => $composableBuilder(
    column: $table.identityVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get referencesVerified => $composableBuilder(
    column: $table.referencesVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get indicativeRate => $composableBuilder(
    column: $table.indicativeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get punctualityRating => $composableBuilder(
    column: $table.punctualityRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get communicationRating => $composableBuilder(
    column: $table.communicationRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PrestataireStatus, PrestataireStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get interventionsCount => $composableBuilder(
    column: $table.interventionsCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastInterventionDate => $composableBuilder(
    column: $table.lastInterventionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> interventionsRefs(
    Expression<bool> Function($$InterventionsTableFilterComposer f) f,
  ) {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.prestataireId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> financesRefs(
    Expression<bool> Function($$FinancesTableFilterComposer f) f,
  ) {
    final $$FinancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finances,
      getReferencedColumn: (t) => t.relatedPrestataireId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancesTableFilterComposer(
            $db: $db,
            $table: $db.finances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrestatairesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrestatairesTable> {
  $$PrestatairesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specialty => $composableBuilder(
    column: $table.specialty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zone => $composableBuilder(
    column: $table.zone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get identityVerified => $composableBuilder(
    column: $table.identityVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get referencesVerified => $composableBuilder(
    column: $table.referencesVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get indicativeRate => $composableBuilder(
    column: $table.indicativeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get punctualityRating => $composableBuilder(
    column: $table.punctualityRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get communicationRating => $composableBuilder(
    column: $table.communicationRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get interventionsCount => $composableBuilder(
    column: $table.interventionsCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastInterventionDate => $composableBuilder(
    column: $table.lastInterventionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrestatairesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrestatairesTable> {
  $$PrestatairesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get specialty =>
      $composableBuilder(column: $table.specialty, builder: (column) => column);

  GeneratedColumn<String> get zone =>
      $composableBuilder(column: $table.zone, builder: (column) => column);

  GeneratedColumn<int> get experienceYears => $composableBuilder(
    column: $table.experienceYears,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get identityVerified => $composableBuilder(
    column: $table.identityVerified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get referencesVerified => $composableBuilder(
    column: $table.referencesVerified,
    builder: (column) => column,
  );

  GeneratedColumn<double> get indicativeRate => $composableBuilder(
    column: $table.indicativeRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get qualityRating => $composableBuilder(
    column: $table.qualityRating,
    builder: (column) => column,
  );

  GeneratedColumn<double> get punctualityRating => $composableBuilder(
    column: $table.punctualityRating,
    builder: (column) => column,
  );

  GeneratedColumn<double> get communicationRating => $composableBuilder(
    column: $table.communicationRating,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PrestataireStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get interventionsCount => $composableBuilder(
    column: $table.interventionsCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastInterventionDate => $composableBuilder(
    column: $table.lastInterventionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> interventionsRefs<T extends Object>(
    Expression<T> Function($$InterventionsTableAnnotationComposer a) f,
  ) {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.prestataireId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> financesRefs<T extends Object>(
    Expression<T> Function($$FinancesTableAnnotationComposer a) f,
  ) {
    final $$FinancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.finances,
      getReferencedColumn: (t) => t.relatedPrestataireId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancesTableAnnotationComposer(
            $db: $db,
            $table: $db.finances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PrestatairesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrestatairesTable,
          Prestataire,
          $$PrestatairesTableFilterComposer,
          $$PrestatairesTableOrderingComposer,
          $$PrestatairesTableAnnotationComposer,
          $$PrestatairesTableCreateCompanionBuilder,
          $$PrestatairesTableUpdateCompanionBuilder,
          (Prestataire, $$PrestatairesTableReferences),
          Prestataire,
          PrefetchHooks Function({bool interventionsRefs, bool financesRefs})
        > {
  $$PrestatairesTableTableManager(_$AppDatabase db, $PrestatairesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrestatairesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrestatairesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrestatairesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> specialty = const Value.absent(),
                Value<String?> zone = const Value.absent(),
                Value<int?> experienceYears = const Value.absent(),
                Value<bool> identityVerified = const Value.absent(),
                Value<bool> referencesVerified = const Value.absent(),
                Value<double?> indicativeRate = const Value.absent(),
                Value<double?> qualityRating = const Value.absent(),
                Value<double?> punctualityRating = const Value.absent(),
                Value<double?> communicationRating = const Value.absent(),
                Value<PrestataireStatus> status = const Value.absent(),
                Value<int> interventionsCount = const Value.absent(),
                Value<DateTime?> lastInterventionDate = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => PrestatairesCompanion(
                id: id,
                reference: reference,
                fullName: fullName,
                phone: phone,
                specialty: specialty,
                zone: zone,
                experienceYears: experienceYears,
                identityVerified: identityVerified,
                referencesVerified: referencesVerified,
                indicativeRate: indicativeRate,
                qualityRating: qualityRating,
                punctualityRating: punctualityRating,
                communicationRating: communicationRating,
                status: status,
                interventionsCount: interventionsCount,
                lastInterventionDate: lastInterventionDate,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required String fullName,
                required String phone,
                required String specialty,
                Value<String?> zone = const Value.absent(),
                Value<int?> experienceYears = const Value.absent(),
                Value<bool> identityVerified = const Value.absent(),
                Value<bool> referencesVerified = const Value.absent(),
                Value<double?> indicativeRate = const Value.absent(),
                Value<double?> qualityRating = const Value.absent(),
                Value<double?> punctualityRating = const Value.absent(),
                Value<double?> communicationRating = const Value.absent(),
                required PrestataireStatus status,
                Value<int> interventionsCount = const Value.absent(),
                Value<DateTime?> lastInterventionDate = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => PrestatairesCompanion.insert(
                id: id,
                reference: reference,
                fullName: fullName,
                phone: phone,
                specialty: specialty,
                zone: zone,
                experienceYears: experienceYears,
                identityVerified: identityVerified,
                referencesVerified: referencesVerified,
                indicativeRate: indicativeRate,
                qualityRating: qualityRating,
                punctualityRating: punctualityRating,
                communicationRating: communicationRating,
                status: status,
                interventionsCount: interventionsCount,
                lastInterventionDate: lastInterventionDate,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PrestatairesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({interventionsRefs = false, financesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (interventionsRefs) db.interventions,
                    if (financesRefs) db.finances,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (interventionsRefs)
                        await $_getPrefetchedData<
                          Prestataire,
                          $PrestatairesTable,
                          Intervention
                        >(
                          currentTable: table,
                          referencedTable: $$PrestatairesTableReferences
                              ._interventionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrestatairesTableReferences(
                                db,
                                table,
                                p0,
                              ).interventionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.prestataireId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (financesRefs)
                        await $_getPrefetchedData<
                          Prestataire,
                          $PrestatairesTable,
                          Finance
                        >(
                          currentTable: table,
                          referencedTable: $$PrestatairesTableReferences
                              ._financesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PrestatairesTableReferences(
                                db,
                                table,
                                p0,
                              ).financesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.relatedPrestataireId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PrestatairesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrestatairesTable,
      Prestataire,
      $$PrestatairesTableFilterComposer,
      $$PrestatairesTableOrderingComposer,
      $$PrestatairesTableAnnotationComposer,
      $$PrestatairesTableCreateCompanionBuilder,
      $$PrestatairesTableUpdateCompanionBuilder,
      (Prestataire, $$PrestatairesTableReferences),
      Prestataire,
      PrefetchHooks Function({bool interventionsRefs, bool financesRefs})
    >;
typedef $$InterventionsTableCreateCompanionBuilder =
    InterventionsCompanion Function({
      Value<int> id,
      required String reference,
      required int logementId,
      required int clientId,
      required String problemDescription,
      Value<String?> category,
      required UrgencyLevel urgencyLevel,
      Value<int?> prestataireId,
      Value<double?> quoteAmount,
      Value<bool> clientValidated,
      Value<DateTime?> interventionDate,
      Value<double?> clientAmount,
      Value<double?> prestataireAmount,
      Value<double?> havenaMargin,
      required InterventionStatus status,
      Value<int?> clientSatisfaction,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$InterventionsTableUpdateCompanionBuilder =
    InterventionsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<int> logementId,
      Value<int> clientId,
      Value<String> problemDescription,
      Value<String?> category,
      Value<UrgencyLevel> urgencyLevel,
      Value<int?> prestataireId,
      Value<double?> quoteAmount,
      Value<bool> clientValidated,
      Value<DateTime?> interventionDate,
      Value<double?> clientAmount,
      Value<double?> prestataireAmount,
      Value<double?> havenaMargin,
      Value<InterventionStatus> status,
      Value<int?> clientSatisfaction,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$InterventionsTableReferences
    extends BaseReferences<_$AppDatabase, $InterventionsTable, Intervention> {
  $$InterventionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LogementsTable _logementIdTable(_$AppDatabase db) =>
      db.logements.createAlias('interventions__logement_id__logements__id');

  $$LogementsTableProcessedTableManager get logementId {
    final $_column = $_itemColumn<int>('logement_id')!;

    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ClientsTable _clientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('interventions__client_id__clients__id');

  $$ClientsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PrestatairesTable _prestataireIdTable(_$AppDatabase db) => db
      .prestataires
      .createAlias('interventions__prestataire_id__prestataires__id');

  $$PrestatairesTableProcessedTableManager? get prestataireId {
    final $_column = $_itemColumn<int>('prestataire_id');
    if ($_column == null) return null;
    final manager = $$PrestatairesTableTableManager(
      $_db,
      $_db.prestataires,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_prestataireIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: 'interventions__id__photos__intervention_id',
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.interventionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InterventionsTableFilterComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get problemDescription => $composableBuilder(
    column: $table.problemDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UrgencyLevel, UrgencyLevel, String>
  get urgencyLevel => $composableBuilder(
    column: $table.urgencyLevel,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<double> get quoteAmount => $composableBuilder(
    column: $table.quoteAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get clientValidated => $composableBuilder(
    column: $table.clientValidated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get interventionDate => $composableBuilder(
    column: $table.interventionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clientAmount => $composableBuilder(
    column: $table.clientAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get prestataireAmount => $composableBuilder(
    column: $table.prestataireAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get havenaMargin => $composableBuilder(
    column: $table.havenaMargin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<InterventionStatus, InterventionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get clientSatisfaction => $composableBuilder(
    column: $table.clientSatisfaction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$LogementsTableFilterComposer get logementId {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableFilterComposer get clientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableFilterComposer get prestataireId {
    final $$PrestatairesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableFilterComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.interventionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterventionsTableOrderingComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get problemDescription => $composableBuilder(
    column: $table.problemDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get urgencyLevel => $composableBuilder(
    column: $table.urgencyLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quoteAmount => $composableBuilder(
    column: $table.quoteAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get clientValidated => $composableBuilder(
    column: $table.clientValidated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get interventionDate => $composableBuilder(
    column: $table.interventionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clientAmount => $composableBuilder(
    column: $table.clientAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get prestataireAmount => $composableBuilder(
    column: $table.prestataireAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get havenaMargin => $composableBuilder(
    column: $table.havenaMargin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clientSatisfaction => $composableBuilder(
    column: $table.clientSatisfaction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$LogementsTableOrderingComposer get logementId {
    final $$LogementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableOrderingComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableOrderingComposer get clientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableOrderingComposer get prestataireId {
    final $$PrestatairesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableOrderingComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InterventionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InterventionsTable> {
  $$InterventionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get problemDescription => $composableBuilder(
    column: $table.problemDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UrgencyLevel, String> get urgencyLevel =>
      $composableBuilder(
        column: $table.urgencyLevel,
        builder: (column) => column,
      );

  GeneratedColumn<double> get quoteAmount => $composableBuilder(
    column: $table.quoteAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get clientValidated => $composableBuilder(
    column: $table.clientValidated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get interventionDate => $composableBuilder(
    column: $table.interventionDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get clientAmount => $composableBuilder(
    column: $table.clientAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get prestataireAmount => $composableBuilder(
    column: $table.prestataireAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get havenaMargin => $composableBuilder(
    column: $table.havenaMargin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<InterventionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get clientSatisfaction => $composableBuilder(
    column: $table.clientSatisfaction,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$LogementsTableAnnotationComposer get logementId {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ClientsTableAnnotationComposer get clientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.clientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableAnnotationComposer get prestataireId {
    final $$PrestatairesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.prestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableAnnotationComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.interventionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$InterventionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InterventionsTable,
          Intervention,
          $$InterventionsTableFilterComposer,
          $$InterventionsTableOrderingComposer,
          $$InterventionsTableAnnotationComposer,
          $$InterventionsTableCreateCompanionBuilder,
          $$InterventionsTableUpdateCompanionBuilder,
          (Intervention, $$InterventionsTableReferences),
          Intervention,
          PrefetchHooks Function({
            bool logementId,
            bool clientId,
            bool prestataireId,
            bool photosRefs,
          })
        > {
  $$InterventionsTableTableManager(_$AppDatabase db, $InterventionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InterventionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InterventionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InterventionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int> logementId = const Value.absent(),
                Value<int> clientId = const Value.absent(),
                Value<String> problemDescription = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<UrgencyLevel> urgencyLevel = const Value.absent(),
                Value<int?> prestataireId = const Value.absent(),
                Value<double?> quoteAmount = const Value.absent(),
                Value<bool> clientValidated = const Value.absent(),
                Value<DateTime?> interventionDate = const Value.absent(),
                Value<double?> clientAmount = const Value.absent(),
                Value<double?> prestataireAmount = const Value.absent(),
                Value<double?> havenaMargin = const Value.absent(),
                Value<InterventionStatus> status = const Value.absent(),
                Value<int?> clientSatisfaction = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InterventionsCompanion(
                id: id,
                reference: reference,
                logementId: logementId,
                clientId: clientId,
                problemDescription: problemDescription,
                category: category,
                urgencyLevel: urgencyLevel,
                prestataireId: prestataireId,
                quoteAmount: quoteAmount,
                clientValidated: clientValidated,
                interventionDate: interventionDate,
                clientAmount: clientAmount,
                prestataireAmount: prestataireAmount,
                havenaMargin: havenaMargin,
                status: status,
                clientSatisfaction: clientSatisfaction,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required int logementId,
                required int clientId,
                required String problemDescription,
                Value<String?> category = const Value.absent(),
                required UrgencyLevel urgencyLevel,
                Value<int?> prestataireId = const Value.absent(),
                Value<double?> quoteAmount = const Value.absent(),
                Value<bool> clientValidated = const Value.absent(),
                Value<DateTime?> interventionDate = const Value.absent(),
                Value<double?> clientAmount = const Value.absent(),
                Value<double?> prestataireAmount = const Value.absent(),
                Value<double?> havenaMargin = const Value.absent(),
                required InterventionStatus status,
                Value<int?> clientSatisfaction = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => InterventionsCompanion.insert(
                id: id,
                reference: reference,
                logementId: logementId,
                clientId: clientId,
                problemDescription: problemDescription,
                category: category,
                urgencyLevel: urgencyLevel,
                prestataireId: prestataireId,
                quoteAmount: quoteAmount,
                clientValidated: clientValidated,
                interventionDate: interventionDate,
                clientAmount: clientAmount,
                prestataireAmount: prestataireAmount,
                havenaMargin: havenaMargin,
                status: status,
                clientSatisfaction: clientSatisfaction,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InterventionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                logementId = false,
                clientId = false,
                prestataireId = false,
                photosRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (photosRefs) db.photos],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (logementId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.logementId,
                                    referencedTable:
                                        $$InterventionsTableReferences
                                            ._logementIdTable(db),
                                    referencedColumn:
                                        $$InterventionsTableReferences
                                            ._logementIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (clientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.clientId,
                                    referencedTable:
                                        $$InterventionsTableReferences
                                            ._clientIdTable(db),
                                    referencedColumn:
                                        $$InterventionsTableReferences
                                            ._clientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (prestataireId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.prestataireId,
                                    referencedTable:
                                        $$InterventionsTableReferences
                                            ._prestataireIdTable(db),
                                    referencedColumn:
                                        $$InterventionsTableReferences
                                            ._prestataireIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (photosRefs)
                        await $_getPrefetchedData<
                          Intervention,
                          $InterventionsTable,
                          Photo
                        >(
                          currentTable: table,
                          referencedTable: $$InterventionsTableReferences
                              ._photosRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InterventionsTableReferences(
                                db,
                                table,
                                p0,
                              ).photosRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.interventionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$InterventionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InterventionsTable,
      Intervention,
      $$InterventionsTableFilterComposer,
      $$InterventionsTableOrderingComposer,
      $$InterventionsTableAnnotationComposer,
      $$InterventionsTableCreateCompanionBuilder,
      $$InterventionsTableUpdateCompanionBuilder,
      (Intervention, $$InterventionsTableReferences),
      Intervention,
      PrefetchHooks Function({
        bool logementId,
        bool clientId,
        bool prestataireId,
        bool photosRefs,
      })
    >;
typedef $$FinancesTableCreateCompanionBuilder =
    FinancesCompanion Function({
      Value<int> id,
      required String reference,
      required DateTime transactionDate,
      required TransactionType transactionType,
      Value<int?> relatedClientId,
      Value<int?> relatedPrestataireId,
      required String description,
      required double amount,
      Value<String?> paymentMethod,
      required TransactionStatus status,
      required String periodMonth,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$FinancesTableUpdateCompanionBuilder =
    FinancesCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<DateTime> transactionDate,
      Value<TransactionType> transactionType,
      Value<int?> relatedClientId,
      Value<int?> relatedPrestataireId,
      Value<String> description,
      Value<double> amount,
      Value<String?> paymentMethod,
      Value<TransactionStatus> status,
      Value<String> periodMonth,
      Value<String?> observations,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$FinancesTableReferences
    extends BaseReferences<_$AppDatabase, $FinancesTable, Finance> {
  $$FinancesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsTable _relatedClientIdTable(_$AppDatabase db) =>
      db.clients.createAlias('finances__related_client_id__clients__id');

  $$ClientsTableProcessedTableManager? get relatedClientId {
    final $_column = $_itemColumn<int>('related_client_id');
    if ($_column == null) return null;
    final manager = $$ClientsTableTableManager(
      $_db,
      $_db.clients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_relatedClientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PrestatairesTable _relatedPrestataireIdTable(_$AppDatabase db) => db
      .prestataires
      .createAlias('finances__related_prestataire_id__prestataires__id');

  $$PrestatairesTableProcessedTableManager? get relatedPrestataireId {
    final $_column = $_itemColumn<int>('related_prestataire_id');
    if ($_column == null) return null;
    final manager = $$PrestatairesTableTableManager(
      $_db,
      $_db.prestataires,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _relatedPrestataireIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinancesTableFilterComposer
    extends Composer<_$AppDatabase, $FinancesTable> {
  $$FinancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TransactionStatus, TransactionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ClientsTableFilterComposer get relatedClientId {
    final $$ClientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedClientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableFilterComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableFilterComposer get relatedPrestataireId {
    final $$PrestatairesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedPrestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableFilterComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancesTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancesTable> {
  $$FinancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ClientsTableOrderingComposer get relatedClientId {
    final $$ClientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedClientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableOrderingComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableOrderingComposer get relatedPrestataireId {
    final $$PrestatairesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedPrestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableOrderingComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancesTable> {
  $$FinancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionType, String>
  get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<TransactionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => column,
  );

  GeneratedColumn<String> get observations => $composableBuilder(
    column: $table.observations,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ClientsTableAnnotationComposer get relatedClientId {
    final $$ClientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedClientId,
      referencedTable: $db.clients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ClientsTableAnnotationComposer(
            $db: $db,
            $table: $db.clients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PrestatairesTableAnnotationComposer get relatedPrestataireId {
    final $$PrestatairesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.relatedPrestataireId,
      referencedTable: $db.prestataires,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PrestatairesTableAnnotationComposer(
            $db: $db,
            $table: $db.prestataires,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancesTable,
          Finance,
          $$FinancesTableFilterComposer,
          $$FinancesTableOrderingComposer,
          $$FinancesTableAnnotationComposer,
          $$FinancesTableCreateCompanionBuilder,
          $$FinancesTableUpdateCompanionBuilder,
          (Finance, $$FinancesTableReferences),
          Finance,
          PrefetchHooks Function({
            bool relatedClientId,
            bool relatedPrestataireId,
          })
        > {
  $$FinancesTableTableManager(_$AppDatabase db, $FinancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FinancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<TransactionType> transactionType = const Value.absent(),
                Value<int?> relatedClientId = const Value.absent(),
                Value<int?> relatedPrestataireId = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> paymentMethod = const Value.absent(),
                Value<TransactionStatus> status = const Value.absent(),
                Value<String> periodMonth = const Value.absent(),
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => FinancesCompanion(
                id: id,
                reference: reference,
                transactionDate: transactionDate,
                transactionType: transactionType,
                relatedClientId: relatedClientId,
                relatedPrestataireId: relatedPrestataireId,
                description: description,
                amount: amount,
                paymentMethod: paymentMethod,
                status: status,
                periodMonth: periodMonth,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required DateTime transactionDate,
                required TransactionType transactionType,
                Value<int?> relatedClientId = const Value.absent(),
                Value<int?> relatedPrestataireId = const Value.absent(),
                required String description,
                required double amount,
                Value<String?> paymentMethod = const Value.absent(),
                required TransactionStatus status,
                required String periodMonth,
                Value<String?> observations = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => FinancesCompanion.insert(
                id: id,
                reference: reference,
                transactionDate: transactionDate,
                transactionType: transactionType,
                relatedClientId: relatedClientId,
                relatedPrestataireId: relatedPrestataireId,
                description: description,
                amount: amount,
                paymentMethod: paymentMethod,
                status: status,
                periodMonth: periodMonth,
                observations: observations,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FinancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({relatedClientId = false, relatedPrestataireId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (relatedClientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.relatedClientId,
                                    referencedTable: $$FinancesTableReferences
                                        ._relatedClientIdTable(db),
                                    referencedColumn: $$FinancesTableReferences
                                        ._relatedClientIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (relatedPrestataireId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.relatedPrestataireId,
                                    referencedTable: $$FinancesTableReferences
                                        ._relatedPrestataireIdTable(db),
                                    referencedColumn: $$FinancesTableReferences
                                        ._relatedPrestataireIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$FinancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancesTable,
      Finance,
      $$FinancesTableFilterComposer,
      $$FinancesTableOrderingComposer,
      $$FinancesTableAnnotationComposer,
      $$FinancesTableCreateCompanionBuilder,
      $$FinancesTableUpdateCompanionBuilder,
      (Finance, $$FinancesTableReferences),
      Finance,
      PrefetchHooks Function({bool relatedClientId, bool relatedPrestataireId})
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int?> logementId,
      Value<int?> interventionId,
      Value<int?> inspectionId,
      required PhotoType photoType,
      required String fileName,
      required String localFilePath,
      Value<String?> driveFileId,
      required DateTime takenAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int?> logementId,
      Value<int?> interventionId,
      Value<int?> inspectionId,
      Value<PhotoType> photoType,
      Value<String> fileName,
      Value<String> localFilePath,
      Value<String?> driveFileId,
      Value<DateTime> takenAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$AppDatabase, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LogementsTable _logementIdTable(_$AppDatabase db) =>
      db.logements.createAlias('photos__logement_id__logements__id');

  $$LogementsTableProcessedTableManager? get logementId {
    final $_column = $_itemColumn<int>('logement_id');
    if ($_column == null) return null;
    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InterventionsTable _interventionIdTable(_$AppDatabase db) => db
      .interventions
      .createAlias('photos__intervention_id__interventions__id');

  $$InterventionsTableProcessedTableManager? get interventionId {
    final $_column = $_itemColumn<int>('intervention_id');
    if ($_column == null) return null;
    final manager = $$InterventionsTableTableManager(
      $_db,
      $_db.interventions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_interventionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $InspectionsTable _inspectionIdTable(_$AppDatabase db) =>
      db.inspections.createAlias('photos__inspection_id__inspections__id');

  $$InspectionsTableProcessedTableManager? get inspectionId {
    final $_column = $_itemColumn<int>('inspection_id');
    if ($_column == null) return null;
    final manager = $$InspectionsTableTableManager(
      $_db,
      $_db.inspections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_inspectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PhotoType, PhotoType, String> get photoType =>
      $composableBuilder(
        column: $table.photoType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$LogementsTableFilterComposer get logementId {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableFilterComposer get interventionId {
    final $$InterventionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableFilterComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableFilterComposer get inspectionId {
    final $$InspectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableFilterComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoType => $composableBuilder(
    column: $table.photoType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$LogementsTableOrderingComposer get logementId {
    final $$LogementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableOrderingComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableOrderingComposer get interventionId {
    final $$InterventionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableOrderingComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableOrderingComposer get inspectionId {
    final $$InspectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableOrderingComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PhotoType, String> get photoType =>
      $composableBuilder(column: $table.photoType, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get driveFileId => $composableBuilder(
    column: $table.driveFileId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$LogementsTableAnnotationComposer get logementId {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InterventionsTableAnnotationComposer get interventionId {
    final $$InterventionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.interventionId,
      referencedTable: $db.interventions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InterventionsTableAnnotationComposer(
            $db: $db,
            $table: $db.interventions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$InspectionsTableAnnotationComposer get inspectionId {
    final $$InspectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.inspectionId,
      referencedTable: $db.inspections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InspectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.inspections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({
            bool logementId,
            bool interventionId,
            bool inspectionId,
          })
        > {
  $$PhotosTableTableManager(_$AppDatabase db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> logementId = const Value.absent(),
                Value<int?> interventionId = const Value.absent(),
                Value<int?> inspectionId = const Value.absent(),
                Value<PhotoType> photoType = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<String?> driveFileId = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                logementId: logementId,
                interventionId: interventionId,
                inspectionId: inspectionId,
                photoType: photoType,
                fileName: fileName,
                localFilePath: localFilePath,
                driveFileId: driveFileId,
                takenAt: takenAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> logementId = const Value.absent(),
                Value<int?> interventionId = const Value.absent(),
                Value<int?> inspectionId = const Value.absent(),
                required PhotoType photoType,
                required String fileName,
                required String localFilePath,
                Value<String?> driveFileId = const Value.absent(),
                required DateTime takenAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => PhotosCompanion.insert(
                id: id,
                logementId: logementId,
                interventionId: interventionId,
                inspectionId: inspectionId,
                photoType: photoType,
                fileName: fileName,
                localFilePath: localFilePath,
                driveFileId: driveFileId,
                takenAt: takenAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$PhotosTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                logementId = false,
                interventionId = false,
                inspectionId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (logementId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.logementId,
                                    referencedTable: $$PhotosTableReferences
                                        ._logementIdTable(db),
                                    referencedColumn: $$PhotosTableReferences
                                        ._logementIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (interventionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.interventionId,
                                    referencedTable: $$PhotosTableReferences
                                        ._interventionIdTable(db),
                                    referencedColumn: $$PhotosTableReferences
                                        ._interventionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (inspectionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.inspectionId,
                                    referencedTable: $$PhotosTableReferences
                                        ._inspectionIdTable(db),
                                    referencedColumn: $$PhotosTableReferences
                                        ._inspectionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({
        bool logementId,
        bool interventionId,
        bool inspectionId,
      })
    >;
typedef $$RapportsTableCreateCompanionBuilder =
    RapportsCompanion Function({
      Value<int> id,
      required String reference,
      required int logementId,
      required String periodMonth,
      Value<HousingCondition?> generalCondition,
      Value<bool> inspectionDone,
      Value<String?> anomalies,
      Value<String?> interventionsDone,
      Value<double?> totalExpenses,
      Value<String?> recommendations,
      Value<String?> nextActions,
      Value<String?> pdfLocalPath,
      Value<DateTime?> generatedAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$RapportsTableUpdateCompanionBuilder =
    RapportsCompanion Function({
      Value<int> id,
      Value<String> reference,
      Value<int> logementId,
      Value<String> periodMonth,
      Value<HousingCondition?> generalCondition,
      Value<bool> inspectionDone,
      Value<String?> anomalies,
      Value<String?> interventionsDone,
      Value<double?> totalExpenses,
      Value<String?> recommendations,
      Value<String?> nextActions,
      Value<String?> pdfLocalPath,
      Value<DateTime?> generatedAt,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

final class $$RapportsTableReferences
    extends BaseReferences<_$AppDatabase, $RapportsTable, Rapport> {
  $$RapportsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LogementsTable _logementIdTable(_$AppDatabase db) =>
      db.logements.createAlias('rapports__logement_id__logements__id');

  $$LogementsTableProcessedTableManager get logementId {
    final $_column = $_itemColumn<int>('logement_id')!;

    final manager = $$LogementsTableTableManager(
      $_db,
      $_db.logements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_logementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RapportsTableFilterComposer
    extends Composer<_$AppDatabase, $RapportsTable> {
  $$RapportsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HousingCondition?, HousingCondition, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get inspectionDone => $composableBuilder(
    column: $table.inspectionDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anomalies => $composableBuilder(
    column: $table.anomalies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get interventionsDone => $composableBuilder(
    column: $table.interventionsDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nextActions => $composableBuilder(
    column: $table.nextActions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$LogementsTableFilterComposer get logementId {
    final $$LogementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableFilterComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RapportsTableOrderingComposer
    extends Composer<_$AppDatabase, $RapportsTable> {
  $$RapportsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reference => $composableBuilder(
    column: $table.reference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inspectionDone => $composableBuilder(
    column: $table.inspectionDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anomalies => $composableBuilder(
    column: $table.anomalies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get interventionsDone => $composableBuilder(
    column: $table.interventionsDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nextActions => $composableBuilder(
    column: $table.nextActions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$LogementsTableOrderingComposer get logementId {
    final $$LogementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableOrderingComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RapportsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RapportsTable> {
  $$RapportsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get reference =>
      $composableBuilder(column: $table.reference, builder: (column) => column);

  GeneratedColumn<String> get periodMonth => $composableBuilder(
    column: $table.periodMonth,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HousingCondition?, String>
  get generalCondition => $composableBuilder(
    column: $table.generalCondition,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get inspectionDone => $composableBuilder(
    column: $table.inspectionDone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anomalies =>
      $composableBuilder(column: $table.anomalies, builder: (column) => column);

  GeneratedColumn<String> get interventionsDone => $composableBuilder(
    column: $table.interventionsDone,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalExpenses => $composableBuilder(
    column: $table.totalExpenses,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recommendations => $composableBuilder(
    column: $table.recommendations,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nextActions => $composableBuilder(
    column: $table.nextActions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pdfLocalPath => $composableBuilder(
    column: $table.pdfLocalPath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get generatedAt => $composableBuilder(
    column: $table.generatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$LogementsTableAnnotationComposer get logementId {
    final $$LogementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.logementId,
      referencedTable: $db.logements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogementsTableAnnotationComposer(
            $db: $db,
            $table: $db.logements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RapportsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RapportsTable,
          Rapport,
          $$RapportsTableFilterComposer,
          $$RapportsTableOrderingComposer,
          $$RapportsTableAnnotationComposer,
          $$RapportsTableCreateCompanionBuilder,
          $$RapportsTableUpdateCompanionBuilder,
          (Rapport, $$RapportsTableReferences),
          Rapport,
          PrefetchHooks Function({bool logementId})
        > {
  $$RapportsTableTableManager(_$AppDatabase db, $RapportsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RapportsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RapportsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RapportsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> reference = const Value.absent(),
                Value<int> logementId = const Value.absent(),
                Value<String> periodMonth = const Value.absent(),
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<bool> inspectionDone = const Value.absent(),
                Value<String?> anomalies = const Value.absent(),
                Value<String?> interventionsDone = const Value.absent(),
                Value<double?> totalExpenses = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<String?> nextActions = const Value.absent(),
                Value<String?> pdfLocalPath = const Value.absent(),
                Value<DateTime?> generatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => RapportsCompanion(
                id: id,
                reference: reference,
                logementId: logementId,
                periodMonth: periodMonth,
                generalCondition: generalCondition,
                inspectionDone: inspectionDone,
                anomalies: anomalies,
                interventionsDone: interventionsDone,
                totalExpenses: totalExpenses,
                recommendations: recommendations,
                nextActions: nextActions,
                pdfLocalPath: pdfLocalPath,
                generatedAt: generatedAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String reference,
                required int logementId,
                required String periodMonth,
                Value<HousingCondition?> generalCondition =
                    const Value.absent(),
                Value<bool> inspectionDone = const Value.absent(),
                Value<String?> anomalies = const Value.absent(),
                Value<String?> interventionsDone = const Value.absent(),
                Value<double?> totalExpenses = const Value.absent(),
                Value<String?> recommendations = const Value.absent(),
                Value<String?> nextActions = const Value.absent(),
                Value<String?> pdfLocalPath = const Value.absent(),
                Value<DateTime?> generatedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => RapportsCompanion.insert(
                id: id,
                reference: reference,
                logementId: logementId,
                periodMonth: periodMonth,
                generalCondition: generalCondition,
                inspectionDone: inspectionDone,
                anomalies: anomalies,
                interventionsDone: interventionsDone,
                totalExpenses: totalExpenses,
                recommendations: recommendations,
                nextActions: nextActions,
                pdfLocalPath: pdfLocalPath,
                generatedAt: generatedAt,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RapportsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({logementId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (logementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.logementId,
                                referencedTable: $$RapportsTableReferences
                                    ._logementIdTable(db),
                                referencedColumn: $$RapportsTableReferences
                                    ._logementIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RapportsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RapportsTable,
      Rapport,
      $$RapportsTableFilterComposer,
      $$RapportsTableOrderingComposer,
      $$RapportsTableAnnotationComposer,
      $$RapportsTableCreateCompanionBuilder,
      $$RapportsTableUpdateCompanionBuilder,
      (Rapport, $$RapportsTableReferences),
      Rapport,
      PrefetchHooks Function({bool logementId})
    >;
typedef $$ModelesDocumentsTableCreateCompanionBuilder =
    ModelesDocumentsCompanion Function({
      Value<int> id,
      required String name,
      required DocumentTemplateType documentType,
      required String contentTemplate,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$ModelesDocumentsTableUpdateCompanionBuilder =
    ModelesDocumentsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DocumentTemplateType> documentType,
      Value<String> contentTemplate,
      Value<bool> isActive,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

class $$ModelesDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $ModelesDocumentsTable> {
  $$ModelesDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    DocumentTemplateType,
    DocumentTemplateType,
    String
  >
  get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get contentTemplate => $composableBuilder(
    column: $table.contentTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ModelesDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ModelesDocumentsTable> {
  $$ModelesDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentTemplate => $composableBuilder(
    column: $table.contentTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ModelesDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ModelesDocumentsTable> {
  $$ModelesDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DocumentTemplateType, String>
  get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentTemplate => $composableBuilder(
    column: $table.contentTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$ModelesDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ModelesDocumentsTable,
          ModelesDocument,
          $$ModelesDocumentsTableFilterComposer,
          $$ModelesDocumentsTableOrderingComposer,
          $$ModelesDocumentsTableAnnotationComposer,
          $$ModelesDocumentsTableCreateCompanionBuilder,
          $$ModelesDocumentsTableUpdateCompanionBuilder,
          (
            ModelesDocument,
            BaseReferences<
              _$AppDatabase,
              $ModelesDocumentsTable,
              ModelesDocument
            >,
          ),
          ModelesDocument,
          PrefetchHooks Function()
        > {
  $$ModelesDocumentsTableTableManager(
    _$AppDatabase db,
    $ModelesDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ModelesDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ModelesDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ModelesDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DocumentTemplateType> documentType = const Value.absent(),
                Value<String> contentTemplate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ModelesDocumentsCompanion(
                id: id,
                name: name,
                documentType: documentType,
                contentTemplate: contentTemplate,
                isActive: isActive,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DocumentTemplateType documentType,
                required String contentTemplate,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => ModelesDocumentsCompanion.insert(
                id: id,
                name: name,
                documentType: documentType,
                contentTemplate: contentTemplate,
                isActive: isActive,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ModelesDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ModelesDocumentsTable,
      ModelesDocument,
      $$ModelesDocumentsTableFilterComposer,
      $$ModelesDocumentsTableOrderingComposer,
      $$ModelesDocumentsTableAnnotationComposer,
      $$ModelesDocumentsTableCreateCompanionBuilder,
      $$ModelesDocumentsTableUpdateCompanionBuilder,
      (
        ModelesDocument,
        BaseReferences<_$AppDatabase, $ModelesDocumentsTable, ModelesDocument>,
      ),
      ModelesDocument,
      PrefetchHooks Function()
    >;
typedef $$CalendrierEvenementsTableCreateCompanionBuilder =
    CalendrierEvenementsCompanion Function({
      Value<int> id,
      required CalendarEventType eventType,
      required String title,
      required DateTime eventDate,
      Value<String?> relatedReference,
      Value<int?> responsibleUserId,
      required CalendarEventStatus status,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });
typedef $$CalendrierEvenementsTableUpdateCompanionBuilder =
    CalendrierEvenementsCompanion Function({
      Value<int> id,
      Value<CalendarEventType> eventType,
      Value<String> title,
      Value<DateTime> eventDate,
      Value<String?> relatedReference,
      Value<int?> responsibleUserId,
      Value<CalendarEventStatus> status,
      Value<DateTime> updatedAt,
      Value<String?> updatedBy,
      Value<SyncStatus> syncStatus,
      Value<bool> isDeleted,
    });

class $$CalendrierEvenementsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendrierEvenementsTable> {
  $$CalendrierEvenementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<CalendarEventType, CalendarEventType, String>
  get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relatedReference => $composableBuilder(
    column: $table.relatedReference,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get responsibleUserId => $composableBuilder(
    column: $table.responsibleUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    CalendarEventStatus,
    CalendarEventStatus,
    String
  >
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CalendrierEvenementsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendrierEvenementsTable> {
  $$CalendrierEvenementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get eventDate => $composableBuilder(
    column: $table.eventDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relatedReference => $composableBuilder(
    column: $table.relatedReference,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get responsibleUserId => $composableBuilder(
    column: $table.responsibleUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedBy => $composableBuilder(
    column: $table.updatedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendrierEvenementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendrierEvenementsTable> {
  $$CalendrierEvenementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<CalendarEventType, String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get eventDate =>
      $composableBuilder(column: $table.eventDate, builder: (column) => column);

  GeneratedColumn<String> get relatedReference => $composableBuilder(
    column: $table.relatedReference,
    builder: (column) => column,
  );

  GeneratedColumn<int> get responsibleUserId => $composableBuilder(
    column: $table.responsibleUserId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<CalendarEventStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get updatedBy =>
      $composableBuilder(column: $table.updatedBy, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$CalendrierEvenementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendrierEvenementsTable,
          CalendrierEvenement,
          $$CalendrierEvenementsTableFilterComposer,
          $$CalendrierEvenementsTableOrderingComposer,
          $$CalendrierEvenementsTableAnnotationComposer,
          $$CalendrierEvenementsTableCreateCompanionBuilder,
          $$CalendrierEvenementsTableUpdateCompanionBuilder,
          (
            CalendrierEvenement,
            BaseReferences<
              _$AppDatabase,
              $CalendrierEvenementsTable,
              CalendrierEvenement
            >,
          ),
          CalendrierEvenement,
          PrefetchHooks Function()
        > {
  $$CalendrierEvenementsTableTableManager(
    _$AppDatabase db,
    $CalendrierEvenementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendrierEvenementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendrierEvenementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CalendrierEvenementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<CalendarEventType> eventType = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> eventDate = const Value.absent(),
                Value<String?> relatedReference = const Value.absent(),
                Value<int?> responsibleUserId = const Value.absent(),
                Value<CalendarEventStatus> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => CalendrierEvenementsCompanion(
                id: id,
                eventType: eventType,
                title: title,
                eventDate: eventDate,
                relatedReference: relatedReference,
                responsibleUserId: responsibleUserId,
                status: status,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required CalendarEventType eventType,
                required String title,
                required DateTime eventDate,
                Value<String?> relatedReference = const Value.absent(),
                Value<int?> responsibleUserId = const Value.absent(),
                required CalendarEventStatus status,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> updatedBy = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => CalendrierEvenementsCompanion.insert(
                id: id,
                eventType: eventType,
                title: title,
                eventDate: eventDate,
                relatedReference: relatedReference,
                responsibleUserId: responsibleUserId,
                status: status,
                updatedAt: updatedAt,
                updatedBy: updatedBy,
                syncStatus: syncStatus,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CalendrierEvenementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendrierEvenementsTable,
      CalendrierEvenement,
      $$CalendrierEvenementsTableFilterComposer,
      $$CalendrierEvenementsTableOrderingComposer,
      $$CalendrierEvenementsTableAnnotationComposer,
      $$CalendrierEvenementsTableCreateCompanionBuilder,
      $$CalendrierEvenementsTableUpdateCompanionBuilder,
      (
        CalendrierEvenement,
        BaseReferences<
          _$AppDatabase,
          $CalendrierEvenementsTable,
          CalendrierEvenement
        >,
      ),
      CalendrierEvenement,
      PrefetchHooks Function()
    >;
typedef $$SyncLogTableCreateCompanionBuilder =
    SyncLogCompanion Function({
      required String entityTable,
      Value<DateTime?> lastSyncedAt,
      Value<SyncLogStatus?> lastSyncStatus,
      Value<int> rowid,
    });
typedef $$SyncLogTableUpdateCompanionBuilder =
    SyncLogCompanion Function({
      Value<String> entityTable,
      Value<DateTime?> lastSyncedAt,
      Value<SyncLogStatus?> lastSyncStatus,
      Value<int> rowid,
    });

class $$SyncLogTableFilterComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncLogStatus?, SyncLogStatus, String>
  get lastSyncStatus => $composableBuilder(
    column: $table.lastSyncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$SyncLogTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncStatus => $composableBuilder(
    column: $table.lastSyncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncLogTable> {
  $$SyncLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get entityTable => $composableBuilder(
    column: $table.entityTable,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SyncLogStatus?, String> get lastSyncStatus =>
      $composableBuilder(
        column: $table.lastSyncStatus,
        builder: (column) => column,
      );
}

class $$SyncLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncLogTable,
          SyncLogData,
          $$SyncLogTableFilterComposer,
          $$SyncLogTableOrderingComposer,
          $$SyncLogTableAnnotationComposer,
          $$SyncLogTableCreateCompanionBuilder,
          $$SyncLogTableUpdateCompanionBuilder,
          (
            SyncLogData,
            BaseReferences<_$AppDatabase, $SyncLogTable, SyncLogData>,
          ),
          SyncLogData,
          PrefetchHooks Function()
        > {
  $$SyncLogTableTableManager(_$AppDatabase db, $SyncLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entityTable = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<SyncLogStatus?> lastSyncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLogCompanion(
                entityTable: entityTable,
                lastSyncedAt: lastSyncedAt,
                lastSyncStatus: lastSyncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entityTable,
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<SyncLogStatus?> lastSyncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncLogCompanion.insert(
                entityTable: entityTable,
                lastSyncedAt: lastSyncedAt,
                lastSyncStatus: lastSyncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncLogTable,
      SyncLogData,
      $$SyncLogTableFilterComposer,
      $$SyncLogTableOrderingComposer,
      $$SyncLogTableAnnotationComposer,
      $$SyncLogTableCreateCompanionBuilder,
      $$SyncLogTableUpdateCompanionBuilder,
      (SyncLogData, BaseReferences<_$AppDatabase, $SyncLogTable, SyncLogData>),
      SyncLogData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
  $$LogementsTableTableManager get logements =>
      $$LogementsTableTableManager(_db, _db.logements);
  $$AbonnementsTableTableManager get abonnements =>
      $$AbonnementsTableTableManager(_db, _db.abonnements);
  $$InspectionsTableTableManager get inspections =>
      $$InspectionsTableTableManager(_db, _db.inspections);
  $$InspectionItemsTableTableManager get inspectionItems =>
      $$InspectionItemsTableTableManager(_db, _db.inspectionItems);
  $$PrestatairesTableTableManager get prestataires =>
      $$PrestatairesTableTableManager(_db, _db.prestataires);
  $$InterventionsTableTableManager get interventions =>
      $$InterventionsTableTableManager(_db, _db.interventions);
  $$FinancesTableTableManager get finances =>
      $$FinancesTableTableManager(_db, _db.finances);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
  $$RapportsTableTableManager get rapports =>
      $$RapportsTableTableManager(_db, _db.rapports);
  $$ModelesDocumentsTableTableManager get modelesDocuments =>
      $$ModelesDocumentsTableTableManager(_db, _db.modelesDocuments);
  $$CalendrierEvenementsTableTableManager get calendrierEvenements =>
      $$CalendrierEvenementsTableTableManager(_db, _db.calendrierEvenements);
  $$SyncLogTableTableManager get syncLog =>
      $$SyncLogTableTableManager(_db, _db.syncLog);
}
