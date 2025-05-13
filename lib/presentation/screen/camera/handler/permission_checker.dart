abstract interface class PermissionChecker<T> {
  Future<void> check(T permission);
}
