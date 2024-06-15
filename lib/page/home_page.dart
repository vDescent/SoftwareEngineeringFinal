import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int? selectedIndex = 0;
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('EspData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Hey, ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                      ),
                    ),
                    Text(
                      "Lorenzo! ",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                    Text(
                      "👋",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2.h,
                ),
                Text(
                  "Welcome to AquaSense",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              child: Stack(
                children: [
                  Image.asset("assets/images/img_header.png"),
                  Positioned(
                    right: 10,
                    top: 18,
                    child: Stack(
                      children: [
                        Image.asset(
                          "assets/images/img_temperature_frame.png",
                          width: 145.w,
                          height: 145.h,
                        ),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StreamBuilder<QuerySnapshot>(
                                      stream: itemsCollection.snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasError) {
                                          return const Center(child: Text('X'));
                                        }
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        final data = snapshot.requireData;

                                        if (data.docs.isEmpty) {
                                          return const Center(
                                              child: Text('??'));
                                        }

                                        var item = data.docs[2];
                                        Color waterQualityColor;

                                        if (item['WaterQuality'] ==
                                            'Very Poor') {
                                          waterQualityColor = Colors.red;
                                        } else if (item['WaterQuality'] ==
                                            'Poor') {
                                          waterQualityColor =
                                              const Color(0xffFF7A00);
                                        } else if (item['WaterQuality'] ==
                                            'Fair') {
                                          waterQualityColor = Colors.yellow;
                                        } else if (item['WaterQuality'] ==
                                            'Good') {
                                          waterQualityColor =
                                              const Color(0xff03CF00);
                                        } else if (item['WaterQuality'] ==
                                            'Excellent') {
                                          waterQualityColor =
                                              const Color(0xff00C2FF);
                                        } else {
                                          waterQualityColor =
                                              const Color(0xff00C2FF);
                                        }
                                        return Text(
                                          item['WaterQuality'],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16.sp,
                                            color: waterQualityColor,
                                          ),
                                        );
                                      }),
                                  Text(
                                    "Updated Just Now",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 9.sp,
                                      color: const Color(0xff757575),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 14.h,
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 2.w),
                              margin: EdgeInsets.symmetric(
                                horizontal: 14.w,
                              ),
                              decoration: BoxDecoration(
                                  color: const Color(0xffEBEBEB),
                                  borderRadius: BorderRadius.circular(20.r)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                      "assets/icons/ic_temperature.svg"),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Air Temp",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 9.sp,
                                          color: const Color(0xff757575),
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: itemsCollection.snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Center(
                                                child: Text('X'));
                                          }
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }

                                          final data = snapshot.requireData;

                                          if (data.docs.isEmpty) {
                                            return const Center(
                                                child: Text('??'));
                                          }

                                          var item = data.docs[2];
                                          return Text(
                                            "${item['Temperature'] ?? '-'}ºC",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16.sp,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Sensors",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: itemsCollection.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.requireData;

                  if (data.docs.isEmpty) {
                    return const Center(child: Text('No items found.'));
                  }

                  var item = data.docs[2];
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            content(
                              pathBackground:
                                  "assets/images/img_orange_card.png",
                              titleIcon: "assets/icons/img_ph.png",
                              title: "pH Level",
                              value: "${(item['pH'])}",
                            ),
                            content(
                              pathBackground:
                                  "assets/images/img_green_card.png",
                              titleIcon: "assets/icons/img_turbidity.png",
                              title: "Turbidity",
                              value: "${(item['Turbidity']).toInt()} NTU",
                              fontSize: 27.sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            content(
                              pathBackground: "assets/images/img_blue_card.png",
                              titleIcon: "assets/icons/img_humidity.png",
                              title: "Humidity",
                              value: "${(item['Humidity']).toInt()}%",
                            ),
                            content(
                              pathBackground:
                                  "assets/images/img_purple_card.png",
                              titleIcon: "assets/icons/img_water_level.png",
                              title: "Water Level",
                              value: "${(item['WaterLevel']).toInt()}%",
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget content({
    String? pathBackground,
    String? titleIcon,
    String? title,
    String? value,
    double? fontSize,
  }) {
    return SizedBox(
      width: 150.w,
      height: 150.h,
      child: Stack(
        children: [
          Image.asset(
            pathBackground!,
            width: 150.w,
            height: 150.h,
          ),
          Column(
            children: [
              SizedBox(
                height: 12.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      width: 38.w,
                      height: 26.h,
                      child: Image.asset(titleIcon!)),
                  Text(
                    title!,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                        color: Colors.white),
                  ),
                ],
              ),
              SizedBox(
                // height: (fontSize != null) ? 18.h : 10.h,
                height: 10.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.topRight,
                child: Text(
                  value!,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 27.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                // height: (fontSize != null) ? 12.h : 2.h,
                height: 12.h,
              ),
              Divider(
                height: 0.3.h,
                color: Colors.white.withOpacity(0.6),
              ),
              SizedBox(
                height: 9.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                alignment: Alignment.center,
                child: Text(
                  "Details",
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
