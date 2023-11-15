import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:staras_checkin/controllers/location_controller.dart';
import 'dependency_injection.dart';
import 'package:face_camera/face_camera.dart';
import 'package:staras_checkin/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Add this
  DependencyInjection.init();
  await FaceCamera.initialize(); //Add this

  LocationController locationController = LocationController();

  // Get the current location when the app starts
  try {
    await locationController.getCurrentLocation();
  } catch (e) {
    print("Error getting location: $e");
    // Handle the error as needed
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STARAS',
      home: const SplashScreen(),
    );
  }
}
