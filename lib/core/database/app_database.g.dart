// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _profilePicturePathMeta =
      const VerificationMeta('profilePicturePath');
  @override
  late final GeneratedColumn<String> profilePicturePath =
      GeneratedColumn<String>(
        'profile_picture_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dateOfBirthMeta = const VerificationMeta(
    'dateOfBirth',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfBirth = GeneratedColumn<DateTime>(
    'date_of_birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    fullName,
    email,
    password,
    profilePicturePath,
    dateOfBirth,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
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
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('profile_picture_path')) {
      context.handle(
        _profilePicturePathMeta,
        profilePicturePath.isAcceptableOrUnknown(
          data['profile_picture_path']!,
          _profilePicturePathMeta,
        ),
      );
    }
    if (data.containsKey('date_of_birth')) {
      context.handle(
        _dateOfBirthMeta,
        dateOfBirth.isAcceptableOrUnknown(
          data['date_of_birth']!,
          _dateOfBirthMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      profilePicturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_picture_path'],
      ),
      dateOfBirth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_of_birth'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String username;
  final String fullName;
  final String email;
  final String password;
  final String? profilePicturePath;
  final DateTime? dateOfBirth;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.username,
    required this.fullName,
    required this.email,
    required this.password,
    this.profilePicturePath,
    this.dateOfBirth,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || profilePicturePath != null) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath);
    }
    if (!nullToAbsent || dateOfBirth != null) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      username: Value(username),
      fullName: Value(fullName),
      email: Value(email),
      password: Value(password),
      profilePicturePath: profilePicturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicturePath),
      dateOfBirth: dateOfBirth == null && nullToAbsent
          ? const Value.absent()
          : Value(dateOfBirth),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      profilePicturePath: serializer.fromJson<String?>(
        json['profilePicturePath'],
      ),
      dateOfBirth: serializer.fromJson<DateTime?>(json['dateOfBirth']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'profilePicturePath': serializer.toJson<String?>(profilePicturePath),
      'dateOfBirth': serializer.toJson<DateTime?>(dateOfBirth),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? username,
    String? fullName,
    String? email,
    String? password,
    Value<String?> profilePicturePath = const Value.absent(),
    Value<DateTime?> dateOfBirth = const Value.absent(),
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    username: username ?? this.username,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    password: password ?? this.password,
    profilePicturePath: profilePicturePath.present
        ? profilePicturePath.value
        : this.profilePicturePath,
    dateOfBirth: dateOfBirth.present ? dateOfBirth.value : this.dateOfBirth,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      profilePicturePath: data.profilePicturePath.present
          ? data.profilePicturePath.value
          : this.profilePicturePath,
      dateOfBirth: data.dateOfBirth.present
          ? data.dateOfBirth.value
          : this.dateOfBirth,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    fullName,
    email,
    password,
    profilePicturePath,
    dateOfBirth,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.username == this.username &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.password == this.password &&
          other.profilePicturePath == this.profilePicturePath &&
          other.dateOfBirth == this.dateOfBirth &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> fullName;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> profilePicturePath;
  final Value<DateTime?> dateOfBirth;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.profilePicturePath = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String fullName,
    required String email,
    required String password,
    this.profilePicturePath = const Value.absent(),
    this.dateOfBirth = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : username = Value(username),
       fullName = Value(fullName),
       email = Value(email),
       password = Value(password);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? profilePicturePath,
    Expression<DateTime>? dateOfBirth,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (profilePicturePath != null)
        'profile_picture_path': profilePicturePath,
      if (dateOfBirth != null) 'date_of_birth': dateOfBirth,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? fullName,
    Value<String>? email,
    Value<String>? password,
    Value<String?>? profilePicturePath,
    Value<DateTime?>? dateOfBirth,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (profilePicturePath.present) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath.value);
    }
    if (dateOfBirth.present) {
      map['date_of_birth'] = Variable<DateTime>(dateOfBirth.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('dateOfBirth: $dateOfBirth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TodoTableTable extends TodoTable
    with TableInfo<$TodoTableTable, TodoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TodoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _completedMeta = const VerificationMeta(
    'completed',
  );
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>(
    'completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, completed, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'todo_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TodoTableData> instance, {
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
    if (data.containsKey('completed')) {
      context.handle(
        _completedMeta,
        completed.isAcceptableOrUnknown(data['completed']!, _completedMeta),
      );
    } else if (isInserting) {
      context.missing(_completedMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TodoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TodoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      completed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completed'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
    );
  }

  @override
  $TodoTableTable createAlias(String alias) {
    return $TodoTableTable(attachedDatabase, alias);
  }
}

class TodoTableData extends DataClass implements Insertable<TodoTableData> {
  final int id;
  final String title;
  final bool completed;
  final bool isFavorite;
  const TodoTableData({
    required this.id,
    required this.title,
    required this.completed,
    required this.isFavorite,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['completed'] = Variable<bool>(completed);
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  TodoTableCompanion toCompanion(bool nullToAbsent) {
    return TodoTableCompanion(
      id: Value(id),
      title: Value(title),
      completed: Value(completed),
      isFavorite: Value(isFavorite),
    );
  }

  factory TodoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TodoTableData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      completed: serializer.fromJson<bool>(json['completed']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'completed': serializer.toJson<bool>(completed),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  TodoTableData copyWith({
    int? id,
    String? title,
    bool? completed,
    bool? isFavorite,
  }) => TodoTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    completed: completed ?? this.completed,
    isFavorite: isFavorite ?? this.isFavorite,
  );
  TodoTableData copyWithCompanion(TodoTableCompanion data) {
    return TodoTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      completed: data.completed.present ? data.completed.value : this.completed,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TodoTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, completed, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TodoTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.completed == this.completed &&
          other.isFavorite == this.isFavorite);
}

class TodoTableCompanion extends UpdateCompanion<TodoTableData> {
  final Value<int> id;
  final Value<String> title;
  final Value<bool> completed;
  final Value<bool> isFavorite;
  const TodoTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.completed = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  TodoTableCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required bool completed,
    this.isFavorite = const Value.absent(),
  }) : title = Value(title),
       completed = Value(completed);
  static Insertable<TodoTableData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<bool>? completed,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (completed != null) 'completed': completed,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  TodoTableCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<bool>? completed,
    Value<bool>? isFavorite,
  }) {
    return TodoTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (completed.present) {
      map['completed'] = Variable<bool>(completed.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TodoTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('completed: $completed, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $SavedAccountsTable extends SavedAccounts
    with TableInfo<$SavedAccountsTable, SavedAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedAccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 5,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 6,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profilePicturePathMeta =
      const VerificationMeta('profilePicturePath');
  @override
  late final GeneratedColumn<String> profilePicturePath =
      GeneratedColumn<String>(
        'profile_picture_path',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastLoginAtMeta = const VerificationMeta(
    'lastLoginAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
    'last_login_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    password,
    username,
    fullName,
    profilePicturePath,
    lastLoginAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    }
    if (data.containsKey('profile_picture_path')) {
      context.handle(
        _profilePicturePathMeta,
        profilePicturePath.isAcceptableOrUnknown(
          data['profile_picture_path']!,
          _profilePicturePathMeta,
        ),
      );
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
        _lastLoginAtMeta,
        lastLoginAt.isAcceptableOrUnknown(
          data['last_login_at']!,
          _lastLoginAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedAccount(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      ),
      profilePicturePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_picture_path'],
      ),
      lastLoginAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_login_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavedAccountsTable createAlias(String alias) {
    return $SavedAccountsTable(attachedDatabase, alias);
  }
}

class SavedAccount extends DataClass implements Insertable<SavedAccount> {
  final int id;
  final String email;
  final String password;
  final String? username;
  final String? fullName;
  final String? profilePicturePath;
  final DateTime lastLoginAt;
  final DateTime createdAt;
  const SavedAccount({
    required this.id,
    required this.email,
    required this.password,
    this.username,
    this.fullName,
    this.profilePicturePath,
    required this.lastLoginAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['password'] = Variable<String>(password);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || fullName != null) {
      map['full_name'] = Variable<String>(fullName);
    }
    if (!nullToAbsent || profilePicturePath != null) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath);
    }
    map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavedAccountsCompanion toCompanion(bool nullToAbsent) {
    return SavedAccountsCompanion(
      id: Value(id),
      email: Value(email),
      password: Value(password),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      fullName: fullName == null && nullToAbsent
          ? const Value.absent()
          : Value(fullName),
      profilePicturePath: profilePicturePath == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicturePath),
      lastLoginAt: Value(lastLoginAt),
      createdAt: Value(createdAt),
    );
  }

  factory SavedAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedAccount(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      password: serializer.fromJson<String>(json['password']),
      username: serializer.fromJson<String?>(json['username']),
      fullName: serializer.fromJson<String?>(json['fullName']),
      profilePicturePath: serializer.fromJson<String?>(
        json['profilePicturePath'],
      ),
      lastLoginAt: serializer.fromJson<DateTime>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'password': serializer.toJson<String>(password),
      'username': serializer.toJson<String?>(username),
      'fullName': serializer.toJson<String?>(fullName),
      'profilePicturePath': serializer.toJson<String?>(profilePicturePath),
      'lastLoginAt': serializer.toJson<DateTime>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SavedAccount copyWith({
    int? id,
    String? email,
    String? password,
    Value<String?> username = const Value.absent(),
    Value<String?> fullName = const Value.absent(),
    Value<String?> profilePicturePath = const Value.absent(),
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) => SavedAccount(
    id: id ?? this.id,
    email: email ?? this.email,
    password: password ?? this.password,
    username: username.present ? username.value : this.username,
    fullName: fullName.present ? fullName.value : this.fullName,
    profilePicturePath: profilePicturePath.present
        ? profilePicturePath.value
        : this.profilePicturePath,
    lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SavedAccount copyWithCompanion(SavedAccountsCompanion data) {
    return SavedAccount(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      password: data.password.present ? data.password.value : this.password,
      username: data.username.present ? data.username.value : this.username,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      profilePicturePath: data.profilePicturePath.present
          ? data.profilePicturePath.value
          : this.profilePicturePath,
      lastLoginAt: data.lastLoginAt.present
          ? data.lastLoginAt.value
          : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedAccount(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    password,
    username,
    fullName,
    profilePicturePath,
    lastLoginAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedAccount &&
          other.id == this.id &&
          other.email == this.email &&
          other.password == this.password &&
          other.username == this.username &&
          other.fullName == this.fullName &&
          other.profilePicturePath == this.profilePicturePath &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt);
}

class SavedAccountsCompanion extends UpdateCompanion<SavedAccount> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> password;
  final Value<String?> username;
  final Value<String?> fullName;
  final Value<String?> profilePicturePath;
  final Value<DateTime> lastLoginAt;
  final Value<DateTime> createdAt;
  const SavedAccountsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.password = const Value.absent(),
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.profilePicturePath = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavedAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String password,
    this.username = const Value.absent(),
    this.fullName = const Value.absent(),
    this.profilePicturePath = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : email = Value(email),
       password = Value(password);
  static Insertable<SavedAccount> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? password,
    Expression<String>? username,
    Expression<String>? fullName,
    Expression<String>? profilePicturePath,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
      if (username != null) 'username': username,
      if (fullName != null) 'full_name': fullName,
      if (profilePicturePath != null)
        'profile_picture_path': profilePicturePath,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavedAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? password,
    Value<String?>? username,
    Value<String?>? fullName,
    Value<String?>? profilePicturePath,
    Value<DateTime>? lastLoginAt,
    Value<DateTime>? createdAt,
  }) {
    return SavedAccountsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (profilePicturePath.present) {
      map['profile_picture_path'] = Variable<String>(profilePicturePath.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedAccountsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('password: $password, ')
          ..write('username: $username, ')
          ..write('fullName: $fullName, ')
          ..write('profilePicturePath: $profilePicturePath, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $TodoTableTable todoTable = $TodoTableTable(this);
  late final $SavedAccountsTable savedAccounts = $SavedAccountsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    todoTable,
    savedAccounts,
  ];
}

typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      required String username,
      required String fullName,
      required String email,
      required String password,
      Value<String?> profilePicturePath,
      Value<DateTime?> dateOfBirth,
      Value<DateTime> createdAt,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> fullName,
      Value<String> email,
      Value<String> password,
      Value<String?> profilePicturePath,
      Value<DateTime?> dateOfBirth,
      Value<DateTime> createdAt,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
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

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
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

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateOfBirth => $composableBuilder(
    column: $table.dateOfBirth,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> profilePicturePath = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                username: username,
                fullName: fullName,
                email: email,
                password: password,
                profilePicturePath: profilePicturePath,
                dateOfBirth: dateOfBirth,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String fullName,
                required String email,
                required String password,
                Value<String?> profilePicturePath = const Value.absent(),
                Value<DateTime?> dateOfBirth = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                username: username,
                fullName: fullName,
                email: email,
                password: password,
                profilePicturePath: profilePicturePath,
                dateOfBirth: dateOfBirth,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$TodoTableTableCreateCompanionBuilder =
    TodoTableCompanion Function({
      Value<int> id,
      required String title,
      required bool completed,
      Value<bool> isFavorite,
    });
typedef $$TodoTableTableUpdateCompanionBuilder =
    TodoTableCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<bool> completed,
      Value<bool> isFavorite,
    });

class $$TodoTableTableFilterComposer
    extends Composer<_$AppDatabase, $TodoTableTable> {
  $$TodoTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TodoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TodoTableTable> {
  $$TodoTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TodoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TodoTableTable> {
  $$TodoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );
}

class $$TodoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TodoTableTable,
          TodoTableData,
          $$TodoTableTableFilterComposer,
          $$TodoTableTableOrderingComposer,
          $$TodoTableTableAnnotationComposer,
          $$TodoTableTableCreateCompanionBuilder,
          $$TodoTableTableUpdateCompanionBuilder,
          (
            TodoTableData,
            BaseReferences<_$AppDatabase, $TodoTableTable, TodoTableData>,
          ),
          TodoTableData,
          PrefetchHooks Function()
        > {
  $$TodoTableTableTableManager(_$AppDatabase db, $TodoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TodoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TodoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TodoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
              }) => TodoTableCompanion(
                id: id,
                title: title,
                completed: completed,
                isFavorite: isFavorite,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required bool completed,
                Value<bool> isFavorite = const Value.absent(),
              }) => TodoTableCompanion.insert(
                id: id,
                title: title,
                completed: completed,
                isFavorite: isFavorite,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TodoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TodoTableTable,
      TodoTableData,
      $$TodoTableTableFilterComposer,
      $$TodoTableTableOrderingComposer,
      $$TodoTableTableAnnotationComposer,
      $$TodoTableTableCreateCompanionBuilder,
      $$TodoTableTableUpdateCompanionBuilder,
      (
        TodoTableData,
        BaseReferences<_$AppDatabase, $TodoTableTable, TodoTableData>,
      ),
      TodoTableData,
      PrefetchHooks Function()
    >;
typedef $$SavedAccountsTableCreateCompanionBuilder =
    SavedAccountsCompanion Function({
      Value<int> id,
      required String email,
      required String password,
      Value<String?> username,
      Value<String?> fullName,
      Value<String?> profilePicturePath,
      Value<DateTime> lastLoginAt,
      Value<DateTime> createdAt,
    });
typedef $$SavedAccountsTableUpdateCompanionBuilder =
    SavedAccountsCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> password,
      Value<String?> username,
      Value<String?> fullName,
      Value<String?> profilePicturePath,
      Value<DateTime> lastLoginAt,
      Value<DateTime> createdAt,
    });

class $$SavedAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $SavedAccountsTable> {
  $$SavedAccountsTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedAccountsTable> {
  $$SavedAccountsTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedAccountsTable> {
  $$SavedAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get profilePicturePath => $composableBuilder(
    column: $table.profilePicturePath,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
    column: $table.lastLoginAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavedAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedAccountsTable,
          SavedAccount,
          $$SavedAccountsTableFilterComposer,
          $$SavedAccountsTableOrderingComposer,
          $$SavedAccountsTableAnnotationComposer,
          $$SavedAccountsTableCreateCompanionBuilder,
          $$SavedAccountsTableUpdateCompanionBuilder,
          (
            SavedAccount,
            BaseReferences<_$AppDatabase, $SavedAccountsTable, SavedAccount>,
          ),
          SavedAccount,
          PrefetchHooks Function()
        > {
  $$SavedAccountsTableTableManager(_$AppDatabase db, $SavedAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> profilePicturePath = const Value.absent(),
                Value<DateTime> lastLoginAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavedAccountsCompanion(
                id: id,
                email: email,
                password: password,
                username: username,
                fullName: fullName,
                profilePicturePath: profilePicturePath,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String password,
                Value<String?> username = const Value.absent(),
                Value<String?> fullName = const Value.absent(),
                Value<String?> profilePicturePath = const Value.absent(),
                Value<DateTime> lastLoginAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavedAccountsCompanion.insert(
                id: id,
                email: email,
                password: password,
                username: username,
                fullName: fullName,
                profilePicturePath: profilePicturePath,
                lastLoginAt: lastLoginAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedAccountsTable,
      SavedAccount,
      $$SavedAccountsTableFilterComposer,
      $$SavedAccountsTableOrderingComposer,
      $$SavedAccountsTableAnnotationComposer,
      $$SavedAccountsTableCreateCompanionBuilder,
      $$SavedAccountsTableUpdateCompanionBuilder,
      (
        SavedAccount,
        BaseReferences<_$AppDatabase, $SavedAccountsTable, SavedAccount>,
      ),
      SavedAccount,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$TodoTableTableTableManager get todoTable =>
      $$TodoTableTableTableManager(_db, _db.todoTable);
  $$SavedAccountsTableTableManager get savedAccounts =>
      $$SavedAccountsTableTableManager(_db, _db.savedAccounts);
}
