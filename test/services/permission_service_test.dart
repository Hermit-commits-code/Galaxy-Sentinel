import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart'; // Add this import
import 'package:permission_handler/permission_handler.dart';
import 'package:galaxy_sentinel/services/permission_service.dart';

void main() {
  // Initialize test binding
  WidgetsFlutterBinding.ensureInitialized();

  test('PermissionService API exists', () async {
    final svc = const PermissionService();
    expect(svc.check(Permission.location), isA<Future<PermissionStatus>>());
    expect(svc.request(Permission.location), isA<Future<PermissionStatus>>());
    expect(
      svc.ensureAll([Permission.location]),
      isA<Future<Map<Permission, PermissionStatus>>>(),
    );
  });
}
