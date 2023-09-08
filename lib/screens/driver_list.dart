import 'package:driver_data_preview/Models/driver.dart';
import 'package:driver_data_preview/Models/performance_data.dart';
import 'package:driver_data_preview/services/yandex_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DriverList extends StatefulWidget {
  final List<Driver> driverList;

  late List<PerformanceData> performanceDataList;


  DriverList({super.key, required this.driverList}) {

    performanceDataList = List.generate(driverList.length, (index) => PerformanceData());

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
                    YandexApi api = YandexApi();
                    DateTime now = DateTime.now();
                    DateTime startDateTime =  DateTime(now.year, now.month, now.day);
                    DateTime nextDay = startDateTime.add(const Duration(days: 1)) ;


                      api.fetchDriverHandCash(
                            widget.driverList[index].id,
                            '${startDateTime.toIso8601String()}+04:00',
                            '${now.toIso8601String()}+04:00')
                        .then((value) {
                      setState(() {
                        widget.performanceDataList[index].handCash = value;
                      });
                    });

                   //  api.fetchDriverWorkingHours(widget.driverList[index].id, '${startDateTime.toIso8601String()}+04:00', '${nextDay.toIso8601String()}+04:00').then((value) {

                    // });

                  } else {
                    setState(() {
                      widget.performanceDataList[index].handCash = null;
                    });
                  }





                },
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                children: [
                  const Row(
                    children: [
                      Text(
                        'Working Hours : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.black45,
                        size: 20,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Hand Cash : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      widget.performanceDataList[index].handCash == null
                          ? const SpinKitThreeBounce(
                              color: Colors.black45,
                              size: 20,
                            )
                          : Text(
                              '${widget.performanceDataList[index].handCash}',
                              style: TextStyle(color: Colors.black45),
                            ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Orders : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.black45,
                        size: 20,
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Distance(KM) : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      SpinKitThreeBounce(
                        color: Colors.black45,
                        size: 20,
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
