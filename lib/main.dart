import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:todo_shared/view/screens/maps.dart';
import 'package:todo_shared/view/screens/splash/splash_screen.dart';
import 'package:todo_shared/view_model/bloc/news_cubit/news_cubit.dart';
import 'package:todo_shared/view_model/servises/local/shared_preference.dart';
import 'package:todo_shared/view_model/servises/network/DioHelper.dart';
import 'firebase_options.dart';
import 'view_model/bloc/observer.dart';
import 'view_model/bloc/task_cubit/task_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreference.sharedInit();
  await DioHelper.initialize();
  Bloc.observer = MyBlocObserver();
  // Test if location services are enabled.
  LocationPermission? permission;
  var serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
  // Location services are not enabled don't continue
  // accessing the position and request users of the
  // App to enable the location services.
  return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TaskCubit(),),
        BlocProvider(create: (context) => NewsCubit()..getSportsNews(),),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MapsScreen(),
          );
        },
      ),
    );
  }
}