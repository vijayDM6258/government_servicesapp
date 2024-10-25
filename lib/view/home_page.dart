import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:government_services_app/providers/home_provider.dart';
import 'package:government_services_app/utils.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((res) {
      print("onConnectivityChanged ${res}");
      bool noInternet = res.contains(ConnectivityResult.none);

      Provider.of<HomeProvider>(context, listen: false)
          .changeConnectionStatus(noInternet);
      if (noInternet) {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 300,
              width: double.infinity,
              child: Text(
                "Please Check internet Connection",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.green),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: StreamBuilder<List<ConnectivityResult>>(
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, snapshot) {
                    List<ConnectivityResult> res = snapshot.data ?? [];
                    if (res.contains(ConnectivityResult.none)) {
                      return Text(
                        "Please Check internet Connection",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.green),
                      );
                    } else {
                      return Text(
                        "Connected",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.green),
                      );
                    }
                  }),
            ),
            Consumer<HomeProvider>(
              builder: (context, homeProvider, child) {
                return Text(
                  "Connected = ${!homeProvider.noInternet}",
                  style: Theme.of(context).textTheme.headlineMedium,
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                String url = "https://www.google.com/";
                Navigator.pushNamed(context, "myWebPage", arguments: url);
              },
              child: Text("Google"),
            ),
            ElevatedButton(
              onPressed: () {
                String url = "https://www.facebook.com/";
                Navigator.pushNamed(context, "myWebPage", arguments: url);
              },
              child: Text("Facebook"),
            ),
            ElevatedButton(
                onPressed: () {
                  String url = "https://flutter.dev/";
                  Navigator.pushNamed(context, "myWebPage", arguments: url);
                },
                child: Text("flutter"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<ConnectivityResult> res =
              await Connectivity().checkConnectivity();
          if (res.contains(ConnectivityResult.none)) {
            Utils().showMessage(context, "Please Check internet Connection");
          } else {
            Utils().showMessage(context, "Connected");
          }

          print("res $res");
        },
      ),
    );
  }
}
