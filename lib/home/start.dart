import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_app/google/home_location.dart';
import 'package:map_app/shared/ad_state.dart';
import 'package:map_app/shared/cubit/map_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.adState}) : super(key: key);

  final AdState adState;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MapCubit()..getCustomMarker(),
      // ..getAdState(adState),
      child: MaterialApp(
        title: 'MAP APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: HomeLocation(),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
