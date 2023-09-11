import 'package:driver_data_preview/Models/driver.dart';
import 'package:driver_data_preview/services/yandex_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class DriverList extends StatefulWidget {
  final List<Driver> driverList;

  const DriverList({super.key, required this.driverList});

  @override
  State<DriverList> createState() => _DriverListState();
}

class _DriverListState extends State<DriverList> {
  DateTime? selectedDate;
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
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: ElevatedButton(
                onPressed: ()  async {
                  DateTime now =  DateTime.now();
                  DateTime firstDate = now.add(const Duration(days:-2));
                  DateTime lastDate = now;

                    final pickedDate =    await showDatePicker(
                                context: context,
                                initialDate: now,
                                firstDate: firstDate,
                                lastDate: lastDate);


                    setState(() {
                      selectedDate = pickedDate;
                    });

                  
                },
                style: ButtonStyle(
                    elevation: const MaterialStatePropertyAll(0),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue[100])),
                child: const Icon(
                  Icons.date_range,
                  color: Colors.black45,
                ),
              ),
            ),
          ],
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
                    DateTime nowDate = DateTime(now.year,now.month,now.day);
                    DateTime startDate =  selectedDate != null ? DateTime(selectedDate!.year,selectedDate!.month,selectedDate!.day) : nowDate;
                    DateTime nextDay =    nowDate.add(const Duration(days: 1));

                    api
                        .fetchDriverHandCash(
                            widget.driverList[index].id,
                            '${startDate.toIso8601String()}+04:00',
                            '${now.toIso8601String()}+04:00')
                        .then((value) {
                      setState(() {
                        widget.driverList[index].handCash = value;
                      });
                    });

                    api
                        .fetchDriverWorkingHours(
                            widget.driverList[index].id,
                            '${startDate.toIso8601String()}+04:00',
                            '${nextDay.toIso8601String()}+04:00')
                        .then((value) {
                      setState(() {
                        widget.driverList[index].workingHours = value;
                      });
                    });

                    api
                        .fetchDriverOrders(
                            widget.driverList[index].id,
                            '${startDate.toIso8601String()}+04:00',
                            '${now.toIso8601String()}+04:00')
                        .then((orders) {
                      setState(() {
                        widget.driverList[index].ordersCount = orders
                            .where((order) => order.status == 'complete')
                            .length;
                      });

                      api.fetchOrdersDistance(orders).then((value) {
                        setState(() {
                          widget.driverList[index].distance = value;
                        });
                      });
                    });
                  } else {
                    setState(() {
                      widget.driverList[index].handCash = null;
                      widget.driverList[index].workingHours = null;
                      widget.driverList[index].ordersCount = null;
                      widget.driverList[index].distance = null;
                    });
                  }
                },
                childrenPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                children: [
                  Row(
                    children: [
                      const Text(
                        'Working Hours : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      widget.driverList[index].workingHours == null
                          ? const SpinKitThreeBounce(
                              color: Colors.black45,
                              size: 15,
                            )
                          : Text(
                              '${widget.driverList[index].workingHours}',
                              style: const TextStyle(color: Colors.black45),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Hand Cash : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      widget.driverList[index].handCash == null
                          ? const SpinKitThreeBounce(
                              color: Colors.black45,
                              size: 15,
                            )
                          : Text(
                              '${widget.driverList[index].handCash}',
                              style: const TextStyle(color: Colors.black45),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Orders : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      widget.driverList[index].ordersCount == null
                          ? const SpinKitThreeBounce(
                              color: Colors.black45,
                              size: 15,
                            )
                          : Text(
                              '${widget.driverList[index].ordersCount}',
                              style: const TextStyle(color: Colors.black45),
                            ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Distance(KM) : ',
                        style: TextStyle(color: Colors.black45),
                      ),
                      widget.driverList[index].distance == null
                          ? const SpinKitThreeBounce(
                              color: Colors.black45,
                              size: 15,
                            )
                          : Text(
                              '${widget.driverList[index].distance}',
                              style: const TextStyle(color: Colors.black45),
                            ),
                    ],
                  ),
                ],
              ),
            );
          },
        ));
  }
}
