import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebView extends StatefulWidget {
  const PaymentWebView({Key key}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();

  PullToRefreshController pullToRefreshController;
  String url = "";
  double progress = 0;
  @override
  void initState() {
    // TODO: implement initState
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: TextButton(
            style: TextButton.styleFrom(),
            onPressed: () => Navigator.pop(context),
            child: SvgPicture.asset(
              'assets/images/back_icon.svg',
            ),
          ),
          title: CustomText(
            "Payment",
            color: ColorsCustom.black,
          ),
        ),
        body: SizedBox(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  child: InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(
                        url: Uri.parse(
                            "https://passport.duitku.com/TopUp/v2/TopUpVAPage.aspx?ref=BTKT7FLDBJ7J0VEFR")),
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url;

                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        if (await canLaunchUrl(uri)) {
                          // Launch the App
                          await launchUrl(
                            uri,
                          );
                          // and cancel the request
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        // urlController.text = this.url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        // urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) {
                      print(consoleMessage);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
