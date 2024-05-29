import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../widget/safe_area.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({Key? key, required this.url}) : super(key: key);
  final webViewController = Get.put(ControllerWebView());

  @override
  Widget build(BuildContext context) {
    return SAFE_AREA(
      useNotification: false,
      bottomPadding: 0,
      context: context,
      child: GetBuilder<ControllerWebView>(
        initState: (_) {
          webViewController.setUrl(url);
          if (Platform.isAndroid) WebView.platform = AndroidWebView();
        },
        builder: (_) {
          return WebView(
            initialUrl: _.url,
            javascriptMode: JavascriptMode.unrestricted,
          );
        },
      ),
    );
  }
}

class ControllerWebView extends GetxController {
  String? url;

  setUrl(String urlOpen) {
    url = "https://$urlOpen";
    update();
  }
}
