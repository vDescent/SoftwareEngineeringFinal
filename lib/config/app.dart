import 'package:aqua_sense_mobile/config/routes.dart';
import 'package:aqua_sense_mobile/page/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
       designSize: const Size(360, 690),
       builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Aquasense",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // navigatorKey: AppConstant.navigatorKey(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case Routes.dashboard:
              return CupertinoPageRoute(
                builder: (context) => const DashboardPage(),
              );
      
            default:
              return CupertinoPageRoute(
                builder: (context) => const DashboardPage(),
              );
          }
        },
      ),
    );
  }
}
