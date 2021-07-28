import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/shared/ad_state.dart';
import 'package:map_app/shared/cubit/states.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MapCubit extends Cubit<AppStates> {
  MapCubit() : super(MapInitialState());

  static MapCubit get(context) => BlocProvider.of(context);
  bool _serviceEnabled = false;
  LocationData? locationData;
  Completer<GoogleMapController> locationController = Completer();
  Completer<GoogleMapController> homeController = Completer();
  CameraPosition kGooglePlex = const CameraPosition(
    target: LatLng(26.8206, 30.8025),
    zoom: 18,
  );
  CameraPosition homeInitLocation = const CameraPosition(
    target: LatLng(26.8206, 30.8025),
    zoom: 7,
  );
  LatLng initPosition = const LatLng(26.8206, 30.8025);
  List<Marker> markers = [];
  List<Circle> circles = [];
  BitmapDescriptor? carIcon;
  BitmapDescriptor? homeIcon;
  LatLng userHome = const LatLng(30.004536, 31.151645);
  int distance = 0;
  bool isMetar = false;
  GeoPoint? currentLocation;
  AdState? adState;
  bool adLoaded = false;
  BannerAd? myBanner;

  Future<void> getAdState(AdState state) async {
    adState = state;
    await adState!.initialization;
    myBanner = BannerAd(
      size: AdSize.banner,
      adUnitId: adState!.bannerAdUnitId,
      listener: adState!.adListener,
      request: const AdRequest(),
    );
    await myBanner!.load();
    adLoaded = true;
    emit(MapGetAdState());
  }

  void setHomePosition(LatLng home) {
    userHome = home;
    emit(MapSetHomePositionState());
  }

  Future<void> getCustomMarker() async {
    carIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(.5, .5)),
        'assets/images/car'
        '.png');
    homeIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(.5, .5)),
        'assets/images/home'
        '.png');
    emit(MapGetCustomIconState());
  }

  Future<void> checkLocationPermition() async {
    Location _location = Location();
    PermissionStatus _permissionStatus;

    _serviceEnabled = await _location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        SystemNavigator.pop(animated: true);
        return;
      } else {
        _permissionStatus = await _location.hasPermission();
        if (_permissionStatus != PermissionStatus.granted) {
          _permissionStatus = await _location.requestPermission();
          if (_permissionStatus != PermissionStatus.granted) {
            SystemNavigator.pop(animated: true);
            return;
          }
        }
      }
    } else {
      _permissionStatus = await _location.hasPermission();

      if (_permissionStatus != PermissionStatus.granted) {
        _permissionStatus = await _location.requestPermission();
        if (_permissionStatus != PermissionStatus.granted) {
          SystemNavigator.pop(animated: true);
          return;
        }
      }
    }

    if (_permissionStatus == PermissionStatus.granted) {
      _location.onLocationChanged.listen(
        (LocationData currentLocation) {
          locationData = currentLocation;
          FirebaseFirestore.instance
              .collection('users')
              .doc('AhAFyUnJrnZ6eudFoK94')
              .set(
            {
              'name': 'Ahmed Fathy',
              'location':
                  GeoPoint(locationData!.latitude!, locationData!.longitude!),
            },
          );
        },
      );
    }
  }

  void getCurrentLocation() {
    FirebaseFirestore.instance
        .collection('users')
        .doc('AhAFyUnJrnZ6eudFoK94')
        .snapshots()
        .listen(
      (event) async {
        var data = event.data();
        currentLocation = data!['location'];
        markers.clear();
        circles.clear();
        markers.add(Marker(
          markerId: MarkerId(data['name']),
          infoWindow: InfoWindow(title: data['name']),
          rotation: locationData == null ? 0 : locationData!.heading!,
          anchor: const Offset(0.5, 0.5),
          draggable: false,
          flat: true,
          position:
              LatLng(currentLocation!.latitude, currentLocation!.longitude),
          icon: carIcon!,
        ));
        markers.add(Marker(
          markerId: const MarkerId('My Home'),
          infoWindow: const InfoWindow(title: 'منزلي'),
          rotation: 0,
          anchor: const Offset(0.5, 0.5),
          draggable: false,
          flat: true,
          position: userHome,
          icon: homeIcon!,
        ));
        circles.add(Circle(
          circleId: const CircleId("1"),
          center: LatLng(currentLocation!.latitude, currentLocation!.longitude),
          radius: locationData == null ? 0 : locationData!.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          fillColor: Colors.blue.withAlpha(70),
        ));

        GoogleMapController mapController = await locationController.future;
        double zoom = await mapController.getZoomLevel();
        CameraUpdate update = CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude, currentLocation!.longitude),
            zoom: zoom,
          ),
        );
        mapController.animateCamera(update);
        var resualt = (calculateDistance(currentLocation!.latitude,
            currentLocation!.longitude, userHome.latitude, userHome.longitude));
        if (resualt < 1) {
          distance = (resualt * 1000).toInt();
          isMetar = true;
        } else {
          distance = resualt.toInt();
          isMetar = false;
        }

        emit(MapGetCurrentLocationSuccessState());
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
