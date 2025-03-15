enum UserRole {
  carOwner,
  carRenter,
}

extension UserRoleExtension on UserRole {
  String get value {
    switch (this) {
      case UserRole.carOwner:
        return 'carOwner';
      case UserRole.carRenter:
        return 'carRenter';
      default:
        throw Exception('Invalid JobStatus');
    }
  }
}
