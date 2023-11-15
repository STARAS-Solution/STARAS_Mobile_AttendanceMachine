import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:staras_checkin/constants/constant.dart';

class DeviceInformation extends StatelessWidget {
  DeviceInformation({super.key});

  final deviceInfoPlugin = DeviceInfoPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Device Info"),
        centerTitle: true,
        backgroundColor: kMainColor,
      ),
      body: Platform.isAndroid
          ? showDeviceInfoCard(showAndroidInfo())
          : Platform.isIOS
              ? showDeviceInfoCard(showIOSInfo())
              : Container(),
    );
  }

  Widget showDeviceInfoCard(Widget infoWidget) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: infoWidget,
      ),
    );
  }

  Widget showAndroidInfo() {
    return FutureBuilder(
      future: deviceInfoPlugin.androidInfo,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          AndroidDeviceInfo info = snapshot.data!;
          return Column(
            children: [
              // item('Android ID', info.id),
              item('IMEI', info.id),
              item('Android Model', info.model),
              item('Android Brand', info.brand),
              item('Android Device', info.device),
              item('Android Hardware', info.hardware),
              item('Android SDK Int', info.version.sdkInt.toString()),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget showIOSInfo() {
    return FutureBuilder(
      future: deviceInfoPlugin.iosInfo,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          IosDeviceInfo info = snapshot.data!;
          return Column(
            children: [
              item('Device Model', info.model),
              item('Device Name', info.name),
              item('System Name', info.systemName),
              item('System Version', info.systemVersion),
              item('Device Is Physical', info.isPhysicalDevice.toString()),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Widget item(String name, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}