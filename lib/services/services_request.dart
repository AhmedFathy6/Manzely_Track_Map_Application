import 'package:flutter/services.dart';
import 'package:location/location.dart';

class RequestService {
  static Future<void> checkLocationPermition(bool _serviceEnabled) async {
    Location location = Location();
    PermissionStatus _permissionStatus;
    //LocationData _location;
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        SystemNavigator.pop(animated: true);
        return;
      } else {
        _permissionStatus = await location.hasPermission();
        if (_permissionStatus != PermissionStatus.granted) {
          _permissionStatus = await location.requestPermission();
          if (_permissionStatus != PermissionStatus.granted) {
            SystemNavigator.pop(animated: true);
            return;
          }
        }
      }
    } else {
      _permissionStatus = await location.hasPermission();

      if (_permissionStatus != PermissionStatus.granted) {
        _permissionStatus = await location.requestPermission();
        if (_permissionStatus != PermissionStatus.granted) {
          SystemNavigator.pop(animated: true);
          return;
        }
      }
    }

    if (_permissionStatus == PermissionStatus.granted) {
      // _location = await location.getLocation();
    }
  }
}
