import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MaterialApp(home: WebViewShow()));
}

class WebViewShow extends StatefulWidget {
  @override
  _WebViewShowState createState() => _WebViewShowState();
}

WebViewController controllerGlobal;
Future<bool> _exitApp(BuildContext context) async {
  if (await controllerGlobal.canGoBack()) {
    print("onwill goback");
    controllerGlobal.goBack();
  } else {
    Scaffold.of(context).showSnackBar(
      const SnackBar(content: Text("No back history item")),
    );
    return Future.value(false);
  }
}

class _WebViewShowState extends State<WebViewShow> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  num position = 1;

  final key = UniqueKey();

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A) {
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              NavigationControls(_controller.future),
            ],
          ),
          body: SafeArea(
              child: IndexedStack(index: position, children: <Widget>[
            Builder(builder: (BuildContext context) {
              return WebView(
                userAgent: "HouseOfJobs",
                initialMediaPlaybackPolicy:
                    AutoMediaPlaybackPolicy.always_allow,
                initialUrl: 'https://houseofjobss.com/',
                javascriptMode: JavascriptMode.unrestricted,
                key: key,
                onPageFinished: doneLoading,
                onPageStarted: startLoading,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              );
            }),
            Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          ]))),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        controllerGlobal = controller;

        return Row();
      },
    );
  }
}
