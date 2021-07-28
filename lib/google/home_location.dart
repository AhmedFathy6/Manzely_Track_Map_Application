import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/shared/cubit/map_cubit.dart';
import 'package:map_app/shared/cubit/states.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'google_map.dart';

class HomeLocation extends StatefulWidget {
  const HomeLocation({Key? key}) : super(key: key);

  @override
  State<HomeLocation> createState() => _HomeLocationState();
}

class _HomeLocationState extends State<HomeLocation> {
  List<Marker> markers = [];
  @override
  void initState() {
    MapCubit.get(context).checkLocationPermition();
    super.initState();
    MapCubit.get(context).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'حدد مكان منزلك',
          style: GoogleFonts.cairo().copyWith(fontSize: 20.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GoogleMapScreen(),
                    ),
                  ),
              icon: const Icon(Icons.done))
        ],
      ),
      body: BlocConsumer<MapCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            MapCubit cubit = MapCubit.get(context);
            return Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: cubit.homeInitLocation,
                    onMapCreated: (GoogleMapController controller) {
                      cubit.homeController.complete(controller);
                    },
                    onTap: (value) {
                      setState(() {
                        markers.clear();
                        markers.add(
                          Marker(
                            markerId: const MarkerId('Home'),
                            position: value,
                            draggable: true,
                          ),
                        );
                      });
                      cubit.setHomePosition(value);
                    },
                    markers: markers.toSet(),
                  ),
                ),
                // if (cubit.adLoaded)
                //   Container(
                //     height: 50,
                //     child: AdWidget(
                //       ad: cubit.myBanner!,
                //     ),
                //   ),
              ],
            );
          }),
    );
  }
}
