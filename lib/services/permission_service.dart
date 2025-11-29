import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService();

  Future<PermissionStatus> check(Permission permission) async {
    return permission.status;
  }

  Future<PermissionStatus> request(Permission permission) async {
    return permission.request();
  }

  /// Ensure a list of permissions are granted; returns map of results.
  Future<Map<Permission, PermissionStatus>> ensureAll(
    List<Permission> permissions,
  ) async {
    final results = <Permission, PermissionStatus>{};
    for (final p in permissions) {
      final status = await p.status;
      if (!status.isGranted) {
        results[p] = await p.request();
      } else {
        results[p] = status;
      }
    }
    return results;
  }

  /// Helper: common battery/thermal-related permissions (android example)
  List<Permission> recommendedForBattery() {
    // Note: many battery/thermal accesses don't require runtime permissions;
    // keep this list extendable (e.g., location if you track geo-tagging)
    return <Permission>[];
  }
}
