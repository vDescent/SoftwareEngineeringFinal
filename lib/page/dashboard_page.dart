import 'package:aqua_sense_mobile/page/analysis_page.dart';
import 'package:aqua_sense_mobile/page/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int? selectedIndex = 0;
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('EspData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                selectedIndex == 0
                    ? "assets/icons/ic_home_black.svg"
                    : "assets/icons/ic_home.svg",
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  selectedIndex == 1
                      ? "assets/icons/ic_analysis_black.svg"
                      : "assets/icons/ic_analysis.svg",
                ),
                label: "Analysis"),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  selectedIndex == 2
                      ? "assets/icons/ic_profile_black.svg"
                      : "assets/icons/ic_profile.svg",
                ),
                label: "Profile"),
          ],
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        body: contentWidget(index: selectedIndex));
  }

  Widget contentWidget({int? index}) {
    if (index == 0) {
      return const HomePage();
    }

    if (index == 1) {
      return const AnalysisPage();
    }

    if (index == 2) {
      return Container();
    }
    return const SizedBox();
  }
}
