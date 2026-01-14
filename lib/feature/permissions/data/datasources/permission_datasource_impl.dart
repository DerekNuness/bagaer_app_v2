import 'package:permission_handler/permission_handler.dart' as ph;

import '../../domain/entities/permission_status.dart';
import 'permission_datasource.dart';

class PermissionDataSourceImpl implements PermissionDataSource {
  @override
  Future<PermissionStatus> ensureCamera() async {
    final status = await ph.Permission.camera.status;

    if (status.isGranted) return PermissionStatus.granted;

    final before = await ph.Permission.camera.status;
    final requested = await ph.Permission.camera.request();
    print('before=$before requested=$requested');
    return _map(requested);
  }

  @override
  Future<PermissionStatus> ensureMicrophone() async {
    final status = await ph.Permission.microphone.status;

    if (status.isGranted) return PermissionStatus.granted;

    final requested = await ph.Permission.microphone.request();
    return _map(requested);
  }

  PermissionStatus _map(ph.PermissionStatus status) {
    if (status.isGranted) return PermissionStatus.granted;
    if (status.isPermanentlyDenied) return PermissionStatus.permanentlyDenied;
    if (status.isRestricted) return PermissionStatus.restricted;
    return PermissionStatus.denied;
  }
}