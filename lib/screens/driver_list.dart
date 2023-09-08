import 'package:driver_data_preview/Models/driver.dart';
import 'package:driver_data_preview/services/yandex_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DriverList extends StatefulWidget {
  final List<Driver> driverList;
  late List<double?> handCashList;

  DriverList({super.key, required this.driverList}) {
    handCashList = List.generate(driverList.length, (index) => null);
  }

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Drivers',
            style: TextStyle(
                color: Colors.black45,
                fontSize: 25,
                fontFamily: 'RobotoMono',
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue[100],
        ),
        body: ListView.builder(
          itemCount: widget.driverList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: ExpansionTile(
                leading: ClipOval(
                  child: widget.driverList[index].photoPath != null
                      ? Image(
                          image:
                              AssetImage(widget.driverList[index].photoPath!),
                        )
                      : const Icon(
                          Icons.person_rounded,
                          size: 40,
                        ),
                ),
                title: Text(
                  widget.driverList[index].name,
                  style: const TextStyle(
                      color: Colors.black45, fontWeight: FontWeight.w500),
                ),
                onExpansionChanged: (val) {
                  if (val) {
                    DateTime now = DateTime.now();
                    DateTime startDateTime =
                        DateTime(now.year, now.month, now.day);

                    YandexApi()
                        .fetchDriverHandCash(
                            widget.driverList[index].id,
                            '${startDateTime.toIso8601String()}+04:00',
                            '${now.toIso8601String()}+04:00')
                        .then((value) {
                      setState(() {
                        widget.handCashList[index] = value;
                      });
                    });
                  } else {

                    setState(() {
                      widget.handCashList[index] = null;
                    });
                  }
                },
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      child: widget.handCashList[index] == null
                          ? const SpinKitSpinningCircle(
                              color: Colors.yellow, size: 30)
                          : Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 0),
                              child: Text(
                                'Hand Cash :  ${widget.handCashList[index]}',
                                style: const TextStyle(color: Colors.black45),
                              ),
                            ))
                ],
              ),
            );
          },
        ));
  }
}
