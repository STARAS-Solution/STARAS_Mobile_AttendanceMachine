// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lottie/lottie.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:staras_checkin/common/toast.dart';

import 'package:staras_checkin/components/button_global.dart';
import 'package:staras_checkin/constants/constant.dart';
import 'package:staras_checkin/controllers/location_controller.dart';
import 'package:staras_checkin/controllers/network_controller.dart';
import 'package:staras_checkin/models/store.info.response.model.dart';
import 'package:staras_checkin/view/device_infor.dart';
import 'package:staras_checkin/view/store_infor_response.dart';

class VerifyMachinePage extends StatefulWidget {
  const VerifyMachinePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerifyMachinePageState createState() => _VerifyMachinePageState();
}

class _VerifyMachinePageState extends State<VerifyMachinePage> {
  final NetworkController _networkController = NetworkController();
  final LocationController _locationController = LocationController();
  final deviceInfoPlugin = DeviceInfoPlugin();

  String deviceId = "Not Found";

  @override
  void initState() {
    super.initState();
    _initControllers();
    _getDeviceInfo();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        deviceId = info.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await deviceInfoPlugin.iosInfo;
        deviceId = info.identifierForVendor!;
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
  }

  Future<void> _initControllers() async {
    await _networkController.init();
    await _locationController.getCurrentLocation();

    // Get device ID

    // Print the results
    print('BSSID: ${_networkController.wifiBSSID}');
    print('Latitude: ${_locationController.currentPosition?.latitude}');
    print('Longitude: ${_locationController.currentPosition?.longitude}');
    print('Device ID: $deviceId');
  }

  Future<void> verifyMachine() async {
    var apiUrl =
        'https://staras-api.smjle.vn/api/attendancemachine/machine-get-store-infor';

    // Request body
    final Map<String, dynamic> requestBody = {
      'machineCode': deviceId,
      'latitude': _locationController.currentPosition?.latitude,
      'longitude': _locationController.currentPosition?.longitude,
      'bssid': _networkController.wifiBSSID,
    };

    print('RequestBody: ${requestBody}');

    try {
      // Making the API POST request
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Data response : ${response.body}');

        final Map<String, dynamic> responseData = json.decode(response.body);
        final StoreInfoResponseModel storeInfoResponse =
            StoreInfoResponseModel.fromJson(responseData['data']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                StoreInfoResponsePage(storeInfoResponse: storeInfoResponse),
          ),
        );
        // print('Store ID: ${storeInfoResponse.storeResponseModel?.id}');
        // print('Store Name: ${storeInfoResponse.storeResponseModel?.storeName}');
        // print(
        //     'Employee ID: ${storeInfoResponse.employeeInStoreResponseModels?[0].employeeId}');

        showToast(
          context: context,
          msg: "Machine verification Successful",
          color: Color.fromARGB(255, 128, 249, 16),
          icon: const Icon(Icons.done),
        );

        print('Machine verification successful');
      } else if (response.statusCode == 400) {
        print('Error: ${response.statusCode} - ${response.body}');

        final Map<String, dynamic> errorResponse = json.decode(response.body);
        final String errorMessage = errorResponse['message'] ?? 'Unknown error';

        showToast(
          context: context,
          msg: errorMessage,
          color: Colors.red,
          icon: const Icon(Icons.error),
        );
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      // Handle exceptions
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Attendance Machine',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: context.height() / 2.5,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                color: kMainColor,
              ),
              child: Column(
                children: [
                  Container(
                    height: context.height() / 4,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          const CircleAvatar(
                            radius: 60.0,
                            backgroundColor: kMainColor,
                            backgroundImage: AssetImage(
                              'assets/images/passio.png',
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            'Store',
                            style: kTextStyle.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Hoa Lac Hi-tech Park',
                            style: kTextStyle.copyWith(color: kGreyTextColor),
                          ),
                        ],
                      ).onTap(() {
                        // const ProfileScreen().launch(context);
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '22',
                                  style: kTextStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'days',
                                  style:
                                      kTextStyle.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            'Present',
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '3',
                                  style: kTextStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'days',
                                  style:
                                      kTextStyle.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            'Late',
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 15.0,
                                right: 15.0,
                                top: 10.0,
                                bottom: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              border: Border.all(color: Colors.white),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withOpacity(0.6),
                                  Colors.white.withOpacity(0.0),
                                ],
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '5',
                                  style: kTextStyle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'days',
                                  style:
                                      kTextStyle.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 2.0,
                          ),
                          Text(
                            'Absent',
                            style: kTextStyle.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () => DeviceInformation().launch(context),
              title: Text(
                'Device Information',
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              leading: const Icon(
                FeatherIcons.phone,
                color: kMainColor,
              ),
            ),
            ListTile(
              title: Text(
                'Instructions Check-In',
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              leading: const Icon(
                FeatherIcons.file,
                color: kMainColor,
              ),
            ),
            ListTile(
              title: Text(
                'Notification',
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              leading: const Icon(
                FeatherIcons.bell,
                color: kMainColor,
              ),
            ),
            ListTile(
              title: Text(
                'Terms & Conditions',
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              leading: const Icon(
                Icons.info_outline,
                color: kMainColor,
              ),
            ),
            ListTile(
              title: Text(
                'Privacy Policy',
                style: kTextStyle.copyWith(color: kTitleColor),
              ),
              leading: const Icon(
                FeatherIcons.alertTriangle,
                color: kMainColor,
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Please Verify Machine',
              style: kTextStyle.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 730,
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 280.0, // Adjust the height as needed
                  child: Lottie.asset(
                    "assets/lottiefiles/verification.json",
                    fit: BoxFit.contain, // Adjust the fit as needed
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ButtonGlobal(
                  buttontext: 'Verify Machine',
                  buttonDecoration:
                      kButtonDecoration.copyWith(color: kMainColor),
                  onPressed: () async {
                    verifyMachine();
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
