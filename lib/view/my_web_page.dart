import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:government_services_app/providers/web_provider.dart';
import 'package:provider/provider.dart';

class MyWebPage extends StatefulWidget {
  const MyWebPage({super.key});

  @override
  State<MyWebPage> createState() => _MyWebPageState();
}

class _MyWebPageState extends State<MyWebPage> {
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        WebUri? webUri = await inAppWebViewController?.getUrl();
        inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: webUri));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String url = "${ModalRoute.of(context)?.settings.arguments}";
    print("url $url");
    return Scaffold(
      appBar: AppBar(
        // leading: SizedBox(),
        title: Text("web"),
      ),
      body: Column(
        children: [
          Consumer<WebProvider>(
            builder: (context, value, child) {
              if (value.progress >= 1) {
                return SizedBox.shrink();
              }
              return LinearProgressIndicator(
                value: value.progress,
              );
            },
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(url)),
              onWebViewCreated: (controller) {
                inAppWebViewController = controller;
              },
              onLoadStop: (controller, url) {
                print("onLoadStop $url");
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                print("onProgressChanged $progress");
                if (progress >= 100) {
                  pullToRefreshController?.endRefreshing();
                }
                Provider.of<WebProvider>(context).onChangeProgress(progress);
              },
              pullToRefreshController: pullToRefreshController,
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(
            onPressed: () {
              inAppWebViewController?.goBack();
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          Expanded(child: TextFormField(
            onFieldSubmitted: (value) {
              String loadData = "https://www.google.com/search?q=$value";
              inAppWebViewController?.loadUrl(
                  urlRequest: URLRequest(url: WebUri(loadData)));
              print("value $value");
            },
          )),
          IconButton(
            onPressed: () {
              inAppWebViewController?.goForward();
            },
            icon: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}
