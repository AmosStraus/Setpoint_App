import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:set_point_attender/models/auth.dart';
// import 'package:set_point_attender/models/database.dart';
import 'package:set_point_attender/pages/all_done.dart';
import 'package:set_point_attender/pages/monthly_view_page.dart';
import 'package:set_point_attender/pages/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Database.pushEmployeePermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (_) => Wrapper(),
          '/finished': (_) => AllDone(),
          '/monthlyReports': (_) => MonthlyViewPage(),
        },
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [
          const Locale('en', 'US'), // American English
          const Locale('he', 'IL')
        ],
        title: "סט פוינט בע\"מ",
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: (BuildContext context, Widget child) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Builder(
              builder: (BuildContext context) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: child,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
