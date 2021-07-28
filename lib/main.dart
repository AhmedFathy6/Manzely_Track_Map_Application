import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:map_app/shared/ad_state.dart';
import 'package:map_app/shared/cubit/bloc_observer.dart';
import 'home/start.dart';
import 'package:bloc/bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final adsInitialize = MobileAds.instance.initialize();
  final adState = AdState(initialization: adsInitialize);
  Bloc.observer = MyBlocObserver();
  runApp(MyApp(
    adState: adState,
  ));
}
