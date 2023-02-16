import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading/indicator/ball_spin_fade_loader_indicator.dart';
import 'package:loading/loading.dart';
import 'package:tomas/helpers/colors_custom.dart';
import 'package:tomas/screens/home/home.dart';
import 'package:tomas/screens/payment_webview/controller/payment_webview_controller.dart';
import 'package:tomas/screens/success_payment/screen/success_payment.dart';
import 'package:tomas/widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebView extends StatefulWidget {
  final String url, orderId;
  const PaymentWebView({Key key, this.url, this.orderId}) : super(key: key);

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();
  var controller = Get.put(PaymentWebVIewController());
  PullToRefreshController pullToRefreshController;
  double progress = 0;
  String url2 = '';
  Timer timer;
  bool isLoading = true;

  void toggleLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

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
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (controller.status == "00") {
        controller.updateStatusPay(widget.orderId, 'SUCCESS');
        timer.cancel();
      } else if (controller.status == "02") {
        controller.updateStatusPay(widget.orderId, 'FAILED');
        timer.cancel();
      }

      {
        controller.getStatusTransaction(widget.orderId);
        // timer.cancel();
      }
    });

    super.initState();
  }

  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: TextButton(
          //   style: TextButton.styleFrom(),
          //   onPressed: () => Navigator.pop(context),
          //   child: SvgPicture.asset(
          //     'assets/images/back_icon.svg',
          //   ),
          // ),
          title: CustomText(
            "Payment",
            color: ColorsCustom.black,
          ),
        ),
        body: SizedBox(
          child: Stack(
            children: <Widget>[
              Column(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: InAppWebView(
                        key: webViewKey,
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(widget.url)),
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            this.url2 = url.toString();
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
                            toggleLoading(false);
                            pullToRefreshController?.endRefreshing();

                            print('object');
                          }

                          setState(() {
                            this.progress = progress / 100;
                            // urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url2 = url.toString();
                            // urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {},
                      ),
                    ),
                  ),
                ],
              ),
              isLoading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.white70,
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: Loading(
                          color: ColorsCustom.primary,
                          indicator: BallSpinFadeLoaderIndicator(),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
