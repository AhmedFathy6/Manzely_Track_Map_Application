import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/shared/cubit/map_cubit.dart';
import 'package:map_app/shared/cubit/states.dart';
import 'package:google_fonts/google_fonts.dart';

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  @override
  void initState() {
    // MapCubit.get(context).checkLocationPermition();
    super.initState();
    //  MapCubit.get(context).getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        dispose();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<MapCubit, AppStates>(
            listener: (context, state) {},
            builder: (context, state) {
              MapCubit cubit = MapCubit.get(context);
              return Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: cubit.kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      cubit.locationController.complete(controller);
                    },
                    markers: cubit.markers.toSet(),
                    circles: cubit.circles.toSet(),
                  ),
                  Container(
                    height: size.height * .10,
                    color: Colors.white.withOpacity(0.4),
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      cubit.isMetar
                          ? 'متبقي للمنزل ${cubit.distance}  متر'
                          : 'متبقي للمنزل ${cubit.distance}  كــم',
                      style: GoogleFonts.cairo().copyWith(fontSize: 20.0),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    MapCubit.get(context).close();
    // TODO: implement dispose
    super.dispose();
  }
}
