// import 'package:britam/core/core_barrel.dart';
// import 'package:britam/core/presentation/bloc/card/card_payment_bloc.dart';
// import 'package:britam/features/test/card_part.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as in_app_web_view;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_webview_pro/webview_flutter.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
// import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';

// class PaymentForm extends StatefulWidget {
//   const PaymentForm({super.key});
//
//   @override
//   PaymentFormState createState() => PaymentFormState();
// }
//
// class PaymentFormState extends State<PaymentForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _transactionTypeController = TextEditingController();
//   final _referenceNumberController = TextEditingController();
//   final _amountController = TextEditingController();
//   final _currencyController = TextEditingController();
//
//
//
//   Future<void> submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       final params = {
//         'access_key': 'e4cf6194dee23af78961bec3a1f304c3',
//         'profile_id': '988DE63F-F903-41A2-9C77-21ADAB010561',
//         'transaction_uuid': "${DateTime.now().millisecondsSinceEpoch}",
//         'signed_field_names': 'access_key,bill_to_forename,bill_to_surname,bill_to_email,bill_to_phone,bill_to_address_line1,bill_to_address_city,bill_to_address_country,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,card_number,card_cvn,card_type,card_expiry_date',
//         'unsigned_field_names': '',
//         'signed_date_time': DateTimeUtils.convertedDate(DateTime.now()),
//         'locale': 'en',
//         'transaction_type': "sale",
//         'reference_number': "406-1121",
//         'amount': _amountController.text.trim(),
//         'currency': "KES",
//         'bill_to_forename': 'Wilfred',
//         'bill_to_surname': 'Kaptugen',
//         'bill_to_email': 'wkaptugen@gmail.com',
//         'bill_to_phone': '254723733083',
//         'bill_to_address_line1': '',
//         'bill_to_address_city': '',
//         'bill_to_address_country': 'KE',
//         'card_type': '001',
//         'card_number': '4111111111111111',
//         'card_cvn': "005",
//         'card_expiry_date': "12-2029",
//         'payment_method': 'card'
//       };
//       final signature = sign(params);
//
//
//       final requestBody = {...params, 'signature': signature};
//       ///
//       final client = http.Client();
//
//       try {
//         final response = await client.post(Uri.parse('https://secureacceptance.cybersource.com/pay'), body: requestBody,);
//         if (response.statusCode == 302 || response.statusCode == 301) {
//           final location = response.headers['location'];
//           final cookie = response.headers['set-cookie'];
//           final connection = response.headers['connection'];
//           final cacheControl = response.headers['cache-control'];
//           final transferEncoding = response.headers['transfer-encoding'];
//           final date = response.headers['date'];
//           final strictTransportSecurity = response.headers['strict-transport-security'];
//           final referrerPolicy = response.headers['referrer-policy'];
//           final cfCacheStatus = response.headers['cf-cache-status'];
//           final xPermittedCrossDomainPolicies = response.headers['x-permitted-cross-domain-policies'];
//           final contentType = response.headers['content-type'];
//           final pragma = response.headers['pragma'];
//           final xXssProtection = response.headers['x-xss-protection'];
//           final saPrefix = response.headers['sa-prefix'];
//           final server = response.headers['server'];
//           final xRequestId = response.headers['x-request-id'];
//           final xDownloadOptions = response.headers['x-download-options'];
//           final cfRay = response.headers['cf-ray'];
//           final xRuntime = response.headers['x-runtime'];
//           final xContentTypeOptions = response.headers['x-content-type-options'];
//           final expires = response.headers['expires'];
//           if (location != null) {
//             final Map<String, String> headers = {
//               'connection': "$connection",
//               'cache-control': "$cacheControl",
//               'set-cookie': "$cookie",
//               'transfer-encoding': "$transferEncoding",
//               'date': "$date",
//               'strict-transport-security': "$strictTransportSecurity",
//               'referrer-policy': "$referrerPolicy",
//               'cf-cache-status': "$cfCacheStatus",
//               'x-permitted-cross-domain-policies': "$xPermittedCrossDomainPolicies",
//               'content-type': "$contentType",
//               'pragma': "$pragma",
//               'x-xss-protection': "$xXssProtection",
//               'sa-prefix': "$saPrefix",
//               'server': "$server",
//               'x-request-id': "$xRequestId",
//               'location': location,
//               'x-download-options': "$xDownloadOptions",
//               'cf-ray': "$cfRay",
//               'x-runtime': "$xRuntime",
//               'x-content-type-options': "$xContentTypeOptions",
//               'expires': "$expires",
//             };
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => ResponsiveWidget(
//                 mobile: MobileCardPayment(cookie: cookie ?? "", location: location,),
//                 desktop: MobileCardPayment(cookie: cookie ?? "", location: location,),
//               )),
//             );
//           }
//         }
//       }
//       catch(e){
//       }
//     }
//   }
//
//   // Future<void> submitRecurringForm() async {
//   //   if (_formKey.currentState!.validate()) {
//   //     final params = {
//   //       'access_key': 'e4cf6194dee23af78961bec3a1f304c3',
//   //       'profile_id': '988DE63F-F903-41A2-9C77-21ADAB010561',
//   //       'transaction_uuid': "${DateTime.now().millisecondsSinceEpoch}",
//   //       'signed_field_names': 'access_key,bill_to_forename,bill_to_surname,bill_to_email,bill_to_phone,bill_to_address_line1,bill_to_address_city,bill_to_address_country,profile_id,transaction_uuid,signed_field_names,unsigned_field_names,signed_date_time,locale,transaction_type,reference_number,amount,currency,card_number,card_cvn,card_type,card_expiry_date',
//   //       'unsigned_field_names': '',
//   //       'signed_date_time': DateTimeUtils.convertedDate(DateTime.now()),
//   //       'locale': 'en',
//   //       'transaction_type': "sale",
//   //       'reference_number': _referenceNumberController.text.trim(),
//   //       'amount': _amountController.text.trim(),
//   //       'currency': "KES",
//   //       'bill_to_forename': 'Wilfred',
//   //       'bill_to_surname': 'Kaptugen',
//   //       'bill_to_email': 'wkaptugen@gmail.com',
//   //       'bill_to_phone': '254723733083',
//   //       'bill_to_address_line1': '',
//   //       'bill_to_address_city': '',
//   //       'bill_to_address_country': 'KE',
//   //       'card_type': '001',
//   //       'card_number': '4111111111111111',
//   //       'card_cvn': "005",
//   //       'card_expiry_date': "12-2029",
//   //       'payment_method': 'card',
//   //       'recurring_frequency': 'monthly',
//   //       'recurring_start_date': '20240921',
//   //       'recurring_amount': _amountController.text.trim(),
//   //     };
//   //     final signature = sign(params);
//   //
//   //
//   //     final requestBody = {...params, 'signature': signature};
//   //     ///
//   //     final client = http.Client();
//   //
//   //     try {
//   //       final response = await client.post(Uri.parse('https://secureacceptance.cybersource.com/pay'), body: requestBody,);
//   //       if (response.statusCode == 302 || response.statusCode == 301) {
//   //         final location = response.headers['location'];
//   //         final cookie = response.headers['set-cookie'];
//   //         final connection = response.headers['connection'];
//   //         final cacheControl = response.headers['cache-control'];
//   //         final transferEncoding = response.headers['transfer-encoding'];
//   //         final date = response.headers['date'];
//   //         final strictTransportSecurity = response.headers['strict-transport-security'];
//   //         final referrerPolicy = response.headers['referrer-policy'];
//   //         final cfCacheStatus = response.headers['cf-cache-status'];
//   //         final xPermittedCrossDomainPolicies = response.headers['x-permitted-cross-domain-policies'];
//   //         final contentType = response.headers['content-type'];
//   //         final pragma = response.headers['pragma'];
//   //         final xXssProtection = response.headers['x-xss-protection'];
//   //         final saPrefix = response.headers['sa-prefix'];
//   //         final server = response.headers['server'];
//   //         final xRequestId = response.headers['x-request-id'];
//   //         final xDownloadOptions = response.headers['x-download-options'];
//   //         final cfRay = response.headers['cf-ray'];
//   //         final xRuntime = response.headers['x-runtime'];
//   //         final xContentTypeOptions = response.headers['x-content-type-options'];
//   //         final expires = response.headers['expires'];
//   //         if (location != null) {
//   //           final Map<String, String> headers = {
//   //             'connection': "$connection",
//   //             'cache-control': "$cacheControl",
//   //             'set-cookie': "$cookie",
//   //             'transfer-encoding': "$transferEncoding",
//   //             'date': "$date",
//   //             'strict-transport-security': "$strictTransportSecurity",
//   //             'referrer-policy': "$referrerPolicy",
//   //             'cf-cache-status': "$cfCacheStatus",
//   //             'x-permitted-cross-domain-policies': "$xPermittedCrossDomainPolicies",
//   //             'content-type': "$contentType",
//   //             'pragma': "$pragma",
//   //             'x-xss-protection': "$xXssProtection",
//   //             'sa-prefix': "$saPrefix",
//   //             'server': "$server",
//   //             'x-request-id': "$xRequestId",
//   //             'location': location,
//   //             'x-download-options': "$xDownloadOptions",
//   //             'cf-ray': "$cfRay",
//   //             'x-runtime': "$xRuntime",
//   //             'x-content-type-options': "$xContentTypeOptions",
//   //             'expires': "$expires",
//   //           };
//   //           Navigator.push(
//   //             context,
//   //             MaterialPageRoute(builder: (context) => ResponsiveWidget(
//   //               mobile: MobileCardPayment(cookie: cookie ?? "", location: location,),
//   //               desktop: MobileCardPayment(cookie: cookie ?? "", location: location,),
//   //             )),
//   //           );
//   //         }
//   //       }
//   //     }
//   //     catch(e){
//   //     }
//   //   }
//   // }
//
//   @override
//   void dispose() {
//     _transactionTypeController.dispose();
//     _referenceNumberController.dispose();
//     _amountController.dispose();
//     _currencyController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Payment Form')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _transactionTypeController,
//                 decoration: InputDecoration(labelText: 'Transaction Type'),
//                 validator: (value) => value!.isEmpty ? 'Please enter transaction type' : null,
//               ),
//               TextFormField(
//                 controller: _referenceNumberController,
//                 decoration: InputDecoration(labelText: 'Reference Number'),
//                 validator: (value) => value!.isEmpty ? 'Please enter reference number' : null,
//               ),
//               // TextFormField(
//               //   controller: _amountController,
//               //   decoration: InputDecoration(labelText: 'Amount'),
//               //   validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
//               // ),
//               // TextFormField(
//               //   controller: _currencyController,
//               //   decoration: InputDecoration(labelText: 'Currency'),
//               //   validator: (value) => value!.isEmpty ? 'Please enter currency' : null,
//               // ),
//               // SizedBox(height: 20),
//               // ElevatedButton(
//               //   onPressed: submitForm,
//               //   child: Text('Submit'),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // String sign(Map<String, String> params) {
//   //   final secretKey = 'b6fce4e1927644758355436b1d0446a7ed5e184dd1314975a49eccc5e30883dd558d6377bc53427fae3ccdb97189bdbdb33882cf366a40ffb478110467792bb38def5de98c504a05833c1b8899f86942c6cd348d4d654e2e9b65d4712b8f3d7489a1fc95763f457eb92d5f9438af6239bb937ae5001b4f1db438d8c500a88176';
//   //
//   //   final dataToSign = buildDataToSign(params);
//   //   final hmacSha256 = Hmac(sha256, utf8.encode(secretKey));
//   //   final digest = hmacSha256.convert(utf8.encode(dataToSign));
//   //   return base64Encode(digest.bytes);
//   // }
//   //
//   // String buildDataToSign(Map<String, String> params) {
//   //   final signedFieldNames = params['signed_field_names']!.split(',');
//   //   final dataToSign = signedFieldNames.map((field) => '$field=${params[field]}').toList();
//   //   return dataToSign.join(',');
//   // }
// }

class WebCardPayment extends StatelessWidget {
  final Uri url;

  WebCardPayment({super.key, required this.url});

  in_app_web_view.InAppWebViewController? webViewController;
  @override
  Widget build(BuildContext context) {
    return in_app_web_view.InAppWebView(
            initialUrlRequest: in_app_web_view.URLRequest(
              url: in_app_web_view.WebUri("https://www.perfectcorp.com/business/showcase/skincare/hd-diagnostics"),
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStop: (controller, url) async {
              // Verify cookies
              var cookies = await in_app_web_view.CookieManager().getCookies(url: url!);
              for (var cookie in cookies) {
              }
            },
            onLoadError: (controller, url, code, message) {
            },
            onTitleChanged: (controller, value){
              if(value?.toLowerCase() == "payment success"){
                // context.read<CardPaymentBloc>().add(CardPaymentOnSuccessEvent());
              }
              if(value?.toLowerCase() == "session timeout"){
                // context.read<CardPaymentBloc>().add(CardPaymentOnFailureEvent());
              }
            },
          )
    // ,))
    ;
  }
}

// class MobileCardPayment extends StatefulWidget {
//   final String cookie;
//   final String location;
//
//
//
//   const MobileCardPayment({super.key, required this.cookie, required this.location});
//
//   @override
//   MobileCardPaymentState createState() => MobileCardPaymentState();
// }
//
// class MobileCardPaymentState extends State<MobileCardPayment> {
//   in_app_web_view.InAppWebViewController? webViewController;
//
//   @override
//   void initState() {
//     super.initState();
//     // Set cookies before loading the URL
//     var session = widget.cookie.split(";");
//     var sessionName = session.first.split("=");
//     var sessionValue = sessionName[1];
//     in_app_web_view.CookieManager().setCookie(
//       url: in_app_web_view.WebUri("https://secureacceptance.cybersource.com/checkout"),
//       name: "JSESSIONID",
//       value: "$sessionValue",
//       path: "/",
//       domain: ".secureacceptance.cybersource.com",
//       isHttpOnly: true,
//       isSecure: true,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return in_app_web_view.InAppWebView(
//       initialUrlRequest: in_app_web_view.URLRequest(
//         url: in_app_web_view.WebUri("https://secureacceptance.cybersource.com/checkout"),
//       ),
//       onWebViewCreated: (controller) {
//         webViewController = controller;
//       },
//       onLoadStop: (controller, url) async {
//         // Verify cookies
//         var cookies = await in_app_web_view.CookieManager().getCookies(url: url!);
//         for (var cookie in cookies) {
//         }
//       },
//       onLoadError: (controller, url, code, message) {
//       },
//       onTitleChanged: (controller, value){
//         // secureacceptance.cybersource.com/payer_authentication/hybrid
//         if(value?.toLowerCase() == "secureacceptance.cybersource.com/payer_authentication/hybrid"){
//           context.read<CardPaymentBloc>().add(CardPaymentOnSuccessEvent());
//         }
//         if(value?.toLowerCase() == "session timeout"){
//           context.read<CardPaymentBloc>().add(CardPaymentOnFailureEvent());
//         }
//       },
//     );
//     // return Scaffold(
//     //   appBar: AppBar(title: const Text("Card Payment")),
//     //   body: in_app_web_view.InAppWebView(
//     //     initialUrlRequest: in_app_web_view.URLRequest(
//     //       url: in_app_web_view.WebUri("https://secureacceptance.cybersource.com/checkout"),
//     //     ),
//     //     onWebViewCreated: (controller) {
//     //       webViewController = controller;
//     //     },
//     //     onLoadStop: (controller, url) async {
//     //       // Verify cookies
//     //       var cookies = await in_app_web_view.CookieManager().getCookies(url: url!);
//     //       for (var cookie in cookies) {
//     //       }
//     //     },
//     //     onLoadError: (controller, url, code, message) {
//     //     },
//     //     onTitleChanged: (controller, value){
//     //     },
//     //   ),
//     // );
//   }
// }




