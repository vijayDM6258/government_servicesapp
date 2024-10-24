import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:government_services_app/providers/home_provider.dart';
import 'package:government_services_app/view/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      builder: (context, child) {
        return MaterialApp(
          initialRoute: "/",
          routes: {"/": (context) => HomePage()},
        );
      },
    );
  }
}
