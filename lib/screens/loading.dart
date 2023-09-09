import 'package:driver_data_preview/screens/driver_list.dart';
import 'package:driver_data_preview/services/yandex_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '/Models/driver.dart';



class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<Driver> driverList = [];

  Future<void> getDriverProfiles() async {

    final response = await YandexApi().fetchDriverProfiles();
    final driverProfiles = response['driver_profiles'];

    for (final profile in driverProfiles) {
      final firstName = profile['driver_profile']['first_name'];
      final lastName = profile['driver_profile']['last_name'];
      final driverId = profile['driver_profile']['id'];
      final phoneNumber = profile['driver_profile']['phones'][0];

      final driver = Driver(
        name: '$firstName $lastName',
        id: driverId,
        phone: phoneNumber,
      );

      await driver.assignPhotoPath();
      driverList.add(driver);
    }
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DriverList(driverList: driverList),
      ),
    );

  }

  @override
  void initState() {
    super.initState();
    getDriverProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitSpinningCircle(
          color: Colors.yellow,
          size:50
        )
      ),
    );
  }
}
