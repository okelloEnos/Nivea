// import 'package:britam/core/core_barrel.dart';
import 'dart:async';
import 'dart:io';

import 'package:dentsu_skin_scanner/responsive_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:nivea/responsive_widget.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class WebExternalDocument extends StatefulWidget {
  final String link;

  const WebExternalDocument({super.key, required this.link});

  @override
  State<WebExternalDocument> createState() => _WebExternalDocumentState();
}

class _WebExternalDocumentState extends State<WebExternalDocument> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
    disableHorizontalScroll: true,
    disableVerticalScroll: true,
    supportZoom: false,
    builtInZoomControls: false,
  );

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // pullToRefreshController = kIsWeb
    //     ? null
    //     : PullToRefreshController(
    //   settings: PullToRefreshSettings(
    //     color: Colors.blue,
    //   ),
    //   onRefresh: () async {
    //     if (defaultTargetPlatform == TargetPlatform.android) {
    //       webViewController?.reload();
    //     } else if (defaultTargetPlatform == TargetPlatform.iOS) {
    //       webViewController?.loadUrl(
    //           urlRequest:
    //           URLRequest(url: await webViewController?.getUrl()));
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    const Color hideColor = Colors.white;
    return ResponsiveWidget(
        mobile: Scaffold(
            body: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: Stack(
            children: [
              InAppWebView(
                key: webViewKey,
                initialUrlRequest: URLRequest(url: WebUri(widget.link)),
                initialSettings: settings,
                pullToRefreshController: pullToRefreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                      resources: request.resources,
                      action: PermissionResponseAction.GRANT);
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

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
                      await launchUrl(
                        uri,
                      );
                      return NavigationActionPolicy.CANCEL;
                    }
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onLoadStop: (controller, url) async {
                  pullToRefreshController?.endRefreshing();
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });

                  if (url.toString() ==
                      "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                    await controller.evaluateJavascript(source: """
                document.querySelector('button').click();
              """);
                  }
                },
                onReceivedError: (controller, request, error) {
                  pullToRefreshController?.endRefreshing();
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    pullToRefreshController?.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                    urlController.text = url;
                  });
                },
                onUpdateVisitedHistory: (controller, url, androidIsReload) {
                  setState(() {
                    this.url = url.toString();
                    urlController.text = this.url;
                  });
                },
                onConsoleMessage: (controller, consoleMessage) async {
                  if (kDebugMode) {
                    if (consoleMessage.message == "window-loaded") {
                      if (url.toString() ==
                          "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                        await controller.evaluateJavascript(source: """
                          var button = document.querySelector('a.pf-btn.pf-black-btn.pf-square-btn');
                          if (button) {
                            button.click();
                          }
                        """);
                      }
                    }
                  }
                },
              ),
              progress < 1.0
                  ? LinearProgressIndicator(value: progress)
                  : Container(),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 55,
                    decoration: const BoxDecoration(color: hideColor),
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: const BoxDecoration(color: hideColor),
                  ))
            ],
          ),
        )),
        desktop: ResponsiveLayoutWidget(
            small: Scaffold(
                body: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(widget.link)),
                    initialSettings: settings,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () =>
                            EagerGestureRecognizer(), // Disables all scrolling gestures
                      ),
                    },
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

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
                          await launchUrl(
                            uri,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      if (url.toString() ==
                          "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                        await controller.evaluateJavascript(source: """
                document.querySelector('button').click();
              """);
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) async {
                      if (consoleMessage.message == "window-loaded") {
                        if (url.toString() ==
                            "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                          await controller.evaluateJavascript(source: """
                          var button = document.querySelector('a.pf-btn.pf-black-btn.pf-square-btn');
                          if (button) {
                            button.click();
                          }
                        """);
                        }
                      }
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 8,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 87,
                        decoration: BoxDecoration(
                            color: hideColor,
                            border: Border.all(color: hideColor)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/images/logo.svg',
                                  width: 32.0, height: 32.0),
                              const Text(
                                "AI Skin Scanner",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "DM Sans",
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 152,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0XFFF4F4F4),
                                spreadRadius: 0,
                                blurRadius: 16,
                                offset: Offset(0, -6)
                            )
                          ],
                            color: hideColor,
                            border: Border.all(color: hideColor)),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 0.0, right: 16.0, left: 16.0),
                          child: Center(
                            child: Text(
                              "Please note: This product is solely for demo purposes and does not reflect actual requirements. Final specifications will be gathered to meet your specific needs.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: "DM Sans",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )),
            medium: Scaffold(
                body: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(widget.link)),
                    initialSettings: settings,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () =>
                            EagerGestureRecognizer(), // Disables all scrolling gestures
                      ),
                    },
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

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
                          await launchUrl(
                            uri,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      if (url.toString() ==
                          "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                        await controller.evaluateJavascript(source: """
                document.querySelector('button').click();
              """);
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) async {
                      if (kDebugMode) {
                        if (consoleMessage.message == "window-loaded") {
                          if (url.toString() ==
                              "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                            await controller.evaluateJavascript(source: """
                          var button = document.querySelector('a.pf-btn.pf-black-btn.pf-square-btn');
                          if (button) {
                            button.click();
                          }
                        """);
                          }
                        }
                      }
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 8,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: const BoxDecoration(color: hideColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/images/logo.svg',
                                  width: 32.0, height: 32.0),
                              const Text(
                                "AI Skin Scanner",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "DM Sans",
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 290,
                        decoration: const BoxDecoration(color: hideColor),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 0.0, right: 32.0, left: 32.0),
                          child: Center(
                            child: Text(
                              "Please note: This product is solely for demo purposes and does not reflect actual requirements. Final specifications will be gathered to meet your specific needs.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: "DM Sans",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            )),
            medium2: Scaffold(
                body: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(widget.link)),
                    initialSettings: settings,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () =>
                            EagerGestureRecognizer(), // Disables all scrolling gestures
                      ),
                    },
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

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
                          await launchUrl(
                            uri,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      if (url.toString() ==
                          "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                        await controller.evaluateJavascript(source: """
                document.querySelector('button').click();
              """);
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) async {
                      if (kDebugMode) {
                        if (consoleMessage.message == "window-loaded") {
                          if (url.toString() ==
                              "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                            await controller.evaluateJavascript(source: """
                          var button = document.querySelector('a.pf-btn.pf-black-btn.pf-square-btn');
                          if (button) {
                            button.click();
                          }
                        """);
                          }
                        }
                      }
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 8,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: const BoxDecoration(color: hideColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/images/logo.svg',
                                  width: 36.0, height: 36.0),
                              const Text(
                                "AI Skin Scanner",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "DM Sans",
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 210,
                        decoration: const BoxDecoration(color: hideColor),
                          child: const Padding(
                            padding: EdgeInsets.only(bottom: 0.0, right: 32.0, left: 32.0),
                            child: Center(
                              child: Text(
                                "Please note: This product is solely for demo purposes and does not reflect actual requirements. Final specifications will be gathered to meet your specific needs.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "DM Sans",
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                      )),
                ],
              ),
            )),
            large: Scaffold(
                body: ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: Stack(
                children: [
                  InAppWebView(
                    key: webViewKey,
                    initialUrlRequest: URLRequest(url: WebUri(widget.link)),
                    initialSettings: settings,
                    gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                      Factory<OneSequenceGestureRecognizer>(
                        () =>
                            EagerGestureRecognizer(), // Disables all scrolling gestures
                      ),
                    },
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      webViewController = controller;
                    },
                    onLoadStart: (controller, url) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onPermissionRequest: (controller, request) async {
                      return PermissionResponse(
                          resources: request.resources,
                          action: PermissionResponseAction.GRANT);
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      var uri = navigationAction.request.url!;

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
                          await launchUrl(
                            uri,
                          );
                          return NavigationActionPolicy.CANCEL;
                        }
                      }

                      return NavigationActionPolicy.ALLOW;
                    },
                    onLoadStop: (controller, url) async {
                      pullToRefreshController?.endRefreshing();
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });

                      if (url.toString() ==
                          "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                        await controller.evaluateJavascript(source: """
                document.querySelector('button').click();
              """);
                      }
                    },
                    onReceivedError: (controller, request, error) {
                      pullToRefreshController?.endRefreshing();
                    },
                    onProgressChanged: (controller, progress) {
                      if (progress == 100) {
                        pullToRefreshController?.endRefreshing();
                      }
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    },
                    onUpdateVisitedHistory: (controller, url, androidIsReload) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    },
                    onConsoleMessage: (controller, consoleMessage) async {
                      if (kDebugMode) {
                        if (consoleMessage.message == "window-loaded") {
                          if (url.toString() ==
                              "https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics") {
                            await controller.evaluateJavascript(source: """
                          var button = document.querySelector('a.pf-btn.pf-black-btn.pf-square-btn');
                          if (button) {
                            button.click();
                          }
                        """);
                          }
                        }
                      }
                    },
                  ),
                  progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container(),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 15,
                        height: double.infinity,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 100,
                        height: 10,
                        decoration: const BoxDecoration(color: hideColor),
                      )),
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: const BoxDecoration(color: hideColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SvgPicture.asset('assets/images/logo.svg',
                                  width: 40.0, height: 40.0),
                              const Text(
                                "AI Skin Scanner",
                                style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "DM Sans",
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        // child: Center(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        //         child: Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             SvgPicture.asset('assets/images/logo.svg',
                        //                 width: 40.0, height: 40.0),
                        //             const Text(
                        //               "AI Skin Scanner",
                        //               style: TextStyle(
                        //                   fontSize: 24.0,
                        //                   fontWeight: FontWeight.w700,
                        //                   fontFamily: "DM Sans",
                        //                   color: Colors.black),
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //       const SizedBox(height: 24.0,),
                        //       const Divider(
                        //         color: Color(0XFFF4F4F4),
                        //         thickness: 4.0,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      )),
                  Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.sizeOf(context).height * 0.26,
                        decoration: const BoxDecoration(color: hideColor),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 0.0, right: 32.0, left: 32.0),
                          child: Center(
                            child: Text(
                              "Please note: This product is solely for demo purposes and does not reflect actual requirements. Final specifications will be gathered to meet your specific needs.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: "DM Sans",
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ))));
  }
}

// class ExternalDocument extends StatefulWidget {
//   final String url;
//   const ExternalDocument({Key? key, required this.url}) : super(key: key);
//
//   @override
//   ExternalDocumentState createState() {
//     return ExternalDocumentState();
//   }
// }
//
// class ExternalDocumentState extends State<ExternalDocument> {
//
//   // final Completer<WebViewController> _controller = Completer<WebViewController>();
//   bool isLoading = true;
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // #docregion platform_features
//     late final PlatformWebViewControllerCreationParams params;
//
//     params = const PlatformWebViewControllerCreationParams();
//     final WebViewController controller =
//     WebViewController.fromPlatformCreationParams(params);
//     // #enddocregion platform_features
//
//     controller
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             debugPrint('WebView is loading (progress : $progress%)');
//             if(progress == 100){
//               // setState(() {
//               isLoading = false;
//               // });
//             }
//           },
//           onPageStarted: (String url) {
//             debugPrint('Page started loading: $url');
//           },
//           onPageFinished: (String url) {
//             debugPrint('Page finished loading: $url');
//             setState(() {
//               isLoading = false;
//             });
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//
//     _controller = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//         child:  SafeArea(
//           child: Stack(
//             children: [
//               WebViewWidget(controller: _controller),
//               isLoading ? const Center(child: PageLoader()) : const SizedBox.shrink()
//             ],
//           ),
//         ));
//   }
// }
//
// class PageLoader extends StatelessWidget {
//   const PageLoader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SpinKitRipple(
//       color: theme.colorScheme.primary,
//       size: 100.0,
//     );
//   }
// }
