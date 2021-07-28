// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:latlong2/latlong.dart';
//
// class MapApp extends StatefulWidget {
//   const MapApp({Key? key}) : super(key: key);
//
//   @override
//   State<MapApp> createState() => _MapAppState();
// }
//
// class _MapAppState extends State<MapApp> {
//   List<Placemark> locations = [];
//   Position position = Position(
//     latitude: 49.5,
//     longitude: -0.09,
//     heading: 20.0,
//     accuracy: 20.0,
//     altitude: 1.0,
//     speed: 1.1,
//     speedAccuracy: 1.1,
//     timestamp: null,
//   );
//   LatLng point = LatLng(49.5, -0.09);
//   LatLng center = LatLng(49.5, -0.09);
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     Future.delayed(const Duration(milliseconds: 500));
//     _determinePosition().then(
//       (value) {
//         setState(
//           () {
//             point = LatLng(value.latitude, value.longitude);
//             position = value;
//             center = LatLng(value.latitude, value.longitude);
//             placemarkFromCoordinates(
//               value.latitude,
//               value.longitude,
//             ).then((value) => locations = value);
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         FlutterMap(
//           options: MapOptions(
//             onTap: (p) async {
//               locations =
//                   await placemarkFromCoordinates(p.latitude, p.longitude);
//               setState(() {
//                 point = LatLng(p.latitude, p.longitude);
//               });
//             },
//             center: center,
//             zoom: 10.0,
//           ),
//           layers: [
//             TileLayerOptions(
//               urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//               subdomains: ['a', 'b', 'c'],
//             ),
//             MarkerLayerOptions(
//               markers: [
//                 Marker(
//                   point: point,
//                   builder: (ctx) => const Icon(
//                     Icons.location_on,
//                     color: Colors.red,
//                     size: 50.0,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 34.0, horizontal: 16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Card(
//                 child: TextField(
//                   decoration: const InputDecoration(
//                     suffixIcon: Icon(Icons.location_on_outlined),
//                     hintText: "Search for Location",
//                     contentPadding: EdgeInsets.all(18.0),
//                   ),
//                   onSubmitted: (value) {
//                     if (value.trim().isNotEmpty) {}
//                   },
//                 ),
//               ),
//               Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     locations.isNotEmpty
//                         ? '${locations.first.country!}, ${locations.first.locality!} , ${locations.first.street!}'
//                         : 'not found',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
// }
