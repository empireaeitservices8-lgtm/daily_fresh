enum UserRole {
  staff,
  storeManager,
  generalManager,
}

class UserModel {
  final String name;
  final String username;
  final String phone;
  final String role;
  final String storeBranch;
  final String employeeId;
  final UserRole userRole;
  final String? avatarUrl;

  const UserModel({
    required this.name,
    this.username = 'staff',
    required this.phone,
    required this.role,
    required this.storeBranch,
    required this.employeeId,
    this.userRole = UserRole.staff,
    this.avatarUrl,
  });

  bool get isStaff => userRole == UserRole.staff;
  bool get isStoreManager => userRole == UserRole.storeManager;
  bool get isGeneralManager => userRole == UserRole.generalManager;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return 'DF';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  UserModel copyWith({
    String? name,
    String? username,
    String? phone,
    String? role,
    String? storeBranch,
    String? employeeId,
    UserRole? userRole,
    String? avatarUrl,
  }) {
    return UserModel(
      name: name ?? this.name,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      storeBranch: storeBranch ?? this.storeBranch,
      employeeId: employeeId ?? this.employeeId,
      userRole: userRole ?? this.userRole,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // Pre-configured Staff user (Juan Dela Cruz)
  static const UserModel defaultStaff = UserModel(
    name: 'Juan Dela Cruz',
    username: 'staff',
    phone: '+91 98765 43210',
    role: 'Store Operations Supervisor',
    storeBranch: 'DayFresh Hypermarket #104 - City Center',
    employeeId: 'DF-STF-104',
    userRole: UserRole.staff,
  );

  // Pre-configured Store Manager user (Marcus Vance)
  static const UserModel defaultSM = UserModel(
    name: 'Marcus Vance',
    username: 'sm',
    phone: '+91 98450 67890',
    role: 'Store Manager (SM)',
    storeBranch: 'DayFresh Hypermarket #104 - City Center',
    employeeId: 'DF-SM-104',
    userRole: UserRole.storeManager,
  );

  // Pre-configured General Manager user (Alexander Wright)
  static const UserModel defaultGM = UserModel(
    name: 'Alexander Wright',
    username: 'gm',
    phone: '+91 98950 12345',
    role: 'General Manager (GM)',
    storeBranch: 'DayFresh Regional HQ - Kochi',
    employeeId: 'DF-GM-001',
    userRole: UserRole.generalManager,
  );
}
