import 'dart:developer';

import 'package:aqua_sense_mobile/page/analysis_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final CollectionReference historyCollection =
      FirebaseFirestore.instance.collection('HistoryEspData');

  List<SensorData> sensorDataList = [];
  Map<String, List<SensorData>> groupedData = {};

  @override
  void initState() {
    super.initState();
    getHistoryData();
  }

  void getHistoryData() async {
    QuerySnapshot querySnapshot = await historyCollection.get();

    List<Map<String, dynamic>> historyData = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String timeStamp = doc.id;
      log("tes : $timeStamp");
      log("tes : $data");
      historyData.add({
        "timestamp": timeStamp,
        "data": {
          "pH": data['pH'],
          "Turbidity": data['Turbidity'],
          "Humidity": data['Humidity'],
          "Water Level": data['WaterLevel'],
        }
      });
    }
    setState(() {
      sensorDataList = processData(historyData);
      for (var item in sensorDataList) {
        String formattedDate =
            DateFormat("MMMM dd, yyyy", "id_ID").format(item.timestamp);
        if (!groupedData.containsKey(formattedDate)) {
          groupedData[formattedDate] = [];
        }
        groupedData[formattedDate]!.add(item);
      }
    });
  }

  List<SensorData> processData(List<Map<String, dynamic>> logs) {
    return logs.map((log) {
      DateTime timestamp = DateTime.parse(log['timestamp']);
      Map<String, dynamic> data = Map<String, dynamic>.from(log['data']);
      return SensorData(timestamp: timestamp, data: data);
    }).toList();
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

  bool? isAnalytics = false;

  @override
  Widget build(BuildContext context) {
    return isAnalytics!
        ? const AnalysisPage()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: SizedBox(
                height: kToolbarHeight + 40.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isAnalytics = true;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width / 4.5).w,
                        ),
                        Text(
                          "History",
                          style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Review historical data from all sensors for comprehensive analysis.",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              children: groupedData.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Divider(),
                    Text(
                      entry.key,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Divider(),
                    ...entry.value.map((sensorData) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0.h, horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 12.w,
                                ),
                                Text(
                                  DateFormat("HH:mm a")
                                      .format(sensorData.timestamp),
                                  style: GoogleFonts.poppins(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Image.asset(
                                  "assets/images/img_card_content.png",
                                  width: MediaQuery.of(context).size.width,
                                  height: 110.h,
                                ),
                                SizedBox(
                                  height: 115.h,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        sensorData.data.entries.map((entry) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.0.w),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${entry.value}${checkUnit(value: entry.key)}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              entry.key,
                                              style: GoogleFonts.poppins(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            ));
  }
}

class SensorData {
  final DateTime timestamp;
  final Map<String, dynamic> data;

  SensorData({required this.timestamp, required this.data});
}
