import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart' show rootBundle;

// import '../constants/app_constants.dart';
import '../constants/app_language.dart';

class AppMethods {
  static Future<List<Map<String, dynamic>>> loadCurrencies() async {
    String jsonString = await rootBundle.loadString('assets/currencies.json');
    List<dynamic> jsonResponse = json.decode(jsonString);

    return jsonResponse.cast<Map<String, dynamic>>();
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
    return true;
  }

  static Future<bool> isAndroid10OrAbove() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt >= 29;
    }
    return false;
  }

  static bool isNumeric(String s) {
    return RegExp(r'^[0-9]+$').hasMatch(s);
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }

  static bool isNegative(String value) {
    double number = double.tryParse(value) ?? 0;
    if (number < 0) return true;
    return false;
  }

  static void shouldPopDialog(BuildContext context) async {
    bool shouldPop = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Data will be lost, if you leave !!",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(AppLanguage.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(AppLanguage.exit),
            ),
          ],
        );
      },
    );
    if (shouldPop == true) {
      Navigator.of(context).pop();
    }
  }
}
