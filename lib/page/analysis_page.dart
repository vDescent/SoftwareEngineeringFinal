import 'dart:developer';

import 'package:aqua_sense_mobile/page/history_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  // final CollectionReference currentCollection =
  //     FirebaseFirestore.instance.collection('EspData');

  final CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('HistoryEspData');

  late List<_ChartData> dataPh = [];
  late List<_ChartData> dataTurbidity = [];
  late List<_ChartData> dataHumidity = [];
  late List<_ChartData> dataWaterLevel = [];
  late TooltipBehavior _tooltip;

  Future<void> collectDataPh() async {
    try {
      QuerySnapshot querySnapshot = await historyCollection.get();
      Map<String, List<double>> pHValuesByDay = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String timeStamp = doc.id;
        String dayOfWeek = getDayOfWeek(timeStamp);
        double pH = data['pH'].toDouble();
        if (!pHValuesByDay.containsKey(dayOfWeek)) {
          pHValuesByDay[dayOfWeek] = [pH];
        } else {
          pHValuesByDay[dayOfWeek]!.add(pH);
        }
      }

      List<_ChartData> chartDataList = [];
      pHValuesByDay.forEach((day, values) {
        double average = values.isNotEmpty
            ? values.reduce((a, b) => a + b) / values.length
            : 0.0;
        chartDataList.add(_ChartData(day, average));
      });

      setState(() {
        dataPh = chartDataList;
        log("data : ${dataPh[0].y}");
      });
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<void> collectDataTurbidity() async {
    try {
      QuerySnapshot querySnapshot = await historyCollection.get();
      Map<String, List<double>> turbidityByDay = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String timeStamp = doc.id;
        String dayOfWeek = getDayOfWeek(timeStamp);
        double turbidity = data['Turbidity'].toDouble();
        if (!turbidityByDay.containsKey(dayOfWeek)) {
          turbidityByDay[dayOfWeek] = [turbidity];
        } else {
          turbidityByDay[dayOfWeek]!.add(turbidity);
        }
      }

      List<_ChartData> chartDataList = [];
      turbidityByDay.forEach((day, values) {
        double average = values.isNotEmpty
            ? values.reduce((a, b) => a + b) / values.length
            : 0.0;
        chartDataList.add(_ChartData(day, average));
      });

      setState(() {
        dataTurbidity = chartDataList;
        log("data : ${dataTurbidity[0].y}");
      });
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<void> collectDataHumidity() async {
    try {
      QuerySnapshot querySnapshot = await historyCollection.get();
      Map<String, List<double>> humidityValueByDay = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String timeStamp = doc.id;
        String dayOfWeek = getDayOfWeek(timeStamp);
        double humidity = data['Humidity'].toDouble();
        if (!humidityValueByDay.containsKey(dayOfWeek)) {
          humidityValueByDay[dayOfWeek] = [humidity];
        } else {
          humidityValueByDay[dayOfWeek]!.add(humidity);
        }
      }

      List<_ChartData> chartDataList = [];
      humidityValueByDay.forEach((day, values) {
        double average = values.isNotEmpty
            ? values.reduce((a, b) => a + b) / values.length
            : 0.0;
        chartDataList.add(_ChartData(day, average));
      });

      setState(() {
        dataHumidity = chartDataList;
        log("data : ${dataHumidity[0].y}");
      });
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  Future<void> collectDataWaterLevel() async {
    try {
      QuerySnapshot querySnapshot = await historyCollection.get();
      Map<String, List<double>> waterLevelValueByDay = {};
      for (var doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String timeStamp = doc.id;
        String dayOfWeek = getDayOfWeek(timeStamp);
        double waterLevel = data['WaterLevel'].toDouble();
        if (!waterLevelValueByDay.containsKey(dayOfWeek)) {
          waterLevelValueByDay[dayOfWeek] = [waterLevel];
        } else {
          waterLevelValueByDay[dayOfWeek]!.add(waterLevel);
        }
      }

      List<_ChartData> chartDataList = [];
      waterLevelValueByDay.forEach((day, values) {
        double average = values.isNotEmpty
            ? values.reduce((a, b) => a + b) / values.length
            : 0.0;
        chartDataList.add(_ChartData(day, average));
      });

      setState(() {
        dataWaterLevel = chartDataList;
        log("data : ${dataHumidity[0].y}");
      });
    } catch (e) {
      log("Error fetching data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _tooltip = TooltipBehavior(enable: true);
    collectDataPh();
    collectDataTurbidity();
    collectDataHumidity();
    collectDataWaterLevel();
  }

  String checkUnit({String? value}) {
    if (value == 'Turbidity') {
      return ' NTU';
    }
    if (value == 'Humidity' || value == 'Water Level') {
      return '%';
    }
    return '';
  }

  bool? isHistory = false;

  @override
  Widget build(BuildContext context) {
    return isHistory!
        ? const HistoryPage()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Analysis",
                style: GoogleFonts.poppins(
                  fontSize: 30.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isHistory = true;
                    });
                  },
                  icon: const Icon(Icons.history),
                ),
                SizedBox(
                  width: 8.w,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(children: [
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xffFF7A00),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "ph Level",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Status : Normal",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: historyCollection.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }

                                    final data = snapshot.requireData;

                                    if (data.docs.isEmpty) {
                                      return const Center(child: Text('-'));
                                    }
                                    var item = data.docs[2];
                                    return Text(
                                      "Current : ${item['pH']}${checkUnit(value: 'pH')}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SfCartesianChart(
                          primaryXAxis: const CategoryAxis(
                            maximumLabels: 7,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            autoScrollingMode: AutoScrollingMode.start,
                            autoScrollingDelta:
                                7, // jumlah titik data yang akan terlihat pada awalnya
                            // enableAutoIntervalOnZooming: true,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 14,
                            interval: 2,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          tooltipBehavior: _tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            AreaSeries<_ChartData, String>(
                              dataSource: dataPh,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'phLevel',
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(1.0),
                                ],
                                stops: const [0.0, 1.0],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderWidth: 2,
                              borderColor: Colors.white,
                            )
                          ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xff03CF00),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Turbidity",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Status : Normal",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: historyCollection.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }

                                    final data = snapshot.requireData;

                                    if (data.docs.isEmpty) {
                                      return const Center(child: Text('-'));
                                    }
                                    var item = data.docs[2];
                                    log("item : ${item['Turbidity']}");
                                    return Text(
                                      "Current : ${item['Turbidity']}${checkUnit(value: 'Turbidity')}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SfCartesianChart(
                          primaryXAxis: const CategoryAxis(
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            maximumLabels: 7,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 25,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          tooltipBehavior: _tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            AreaSeries<_ChartData, String>(
                              dataSource: dataTurbidity,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'Turbidity',
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(1.0),
                                ],
                                stops: const [0.0, 1.0],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderWidth: 2,
                              borderColor: Colors.white,
                            )
                          ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xff00ABEE),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Humidity",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Status : Normal",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: historyCollection.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }

                                    final data = snapshot.requireData;

                                    if (data.docs.isEmpty) {
                                      return const Center(child: Text('-'));
                                    }
                                    var item = data.docs[2];
                                    return Text(
                                      "Current : ${item['Humidity']}${checkUnit(value: 'Humidity')}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SfCartesianChart(
                          primaryXAxis: const CategoryAxis(
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            maximumLabels: 7,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 50,
                            interval: 10,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          tooltipBehavior: _tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            AreaSeries<_ChartData, String>(
                              dataSource: dataHumidity,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'Humidity',
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(1.0),
                                ],
                                stops: const [0.0, 1.0],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderWidth: 2,
                              borderColor: Colors.white,
                            )
                          ]),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  padding: EdgeInsets.only(
                    top: 8.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: const Color(0xff7F00FF),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Water Level",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                "Status : Normal",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.h, horizontal: 8.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: historyCollection.snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ));
                                    }

                                    final data = snapshot.requireData;

                                    if (data.docs.isEmpty) {
                                      return const Center(child: Text('-'));
                                    }
                                    var item = data.docs[2];
                                    return Text(
                                      "Current : ${item['WaterLevel']}${checkUnit(value: 'Water Level')}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SfCartesianChart(
                          primaryXAxis: const CategoryAxis(
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            maximumLabels: 7,
                          ),
                          primaryYAxis: const NumericAxis(
                            minimum: 0,
                            maximum: 100,
                            interval: 25,
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          tooltipBehavior: _tooltip,
                          series: <CartesianSeries<_ChartData, String>>[
                            AreaSeries<_ChartData, String>(
                              dataSource: dataWaterLevel,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              name: 'Water Level',
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.0),
                                  Colors.white.withOpacity(1.0),
                                ],
                                stops: const [0.0, 1.0],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                              borderWidth: 2,
                              borderColor: Colors.white,
                            )
                          ]),
                    ],
                  ),
                ),
              ]),
            ),
          );
  }

  String getDayOfWeek(String timeStamp) {
    DateTime date = DateTime.parse(timeStamp);
    switch (date.weekday) {
      case DateTime.monday:
        return "Mon";
      case DateTime.tuesday:
        return "Tue";
      case DateTime.wednesday:
        return "Wed";
      case DateTime.thursday:
        return "Thu";
      case DateTime.friday:
        return "Fri";
      case DateTime.saturday:
        return "Sat";
      case DateTime.sunday:
        return "Sun";
      default:
        return "";
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
