import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  WebViewScreen({this.title, this.url});
  String? title;
  String? url;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title!,
          style: const TextStyle(
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      body: SizedBox(
        height: _hight,
        width: _width,
        child:  WebView(
          initialUrl: widget.url!,   //"http://guard.tbmslive.org/GuardDocuments.php?company=sms&guard_id=436"
          gestureNavigationEnabled: true,
          allowsInlineMediaPlayback: true,
          zoomEnabled: true,
        ),
      ),
    ));
  }
}
