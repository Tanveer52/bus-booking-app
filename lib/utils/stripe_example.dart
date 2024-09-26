import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bus_booking_app/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class StripeExample extends StatefulWidget {
  const StripeExample({super.key});

  @override
  StripeExampleState createState() => StripeExampleState();
}

class StripeExampleState extends State<StripeExample> {
  Map<String, dynamic> paymentIntent = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                child: const Text(
                  'Make Payment',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  // await createStripePrice();
                  await makePayment();
                  // StripeHelper().subscriptions();
                  // final id = await Server().createStripePrice();

                  // await Server().createCheckout(id).then((value) {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => PaymentPage(id: value)));
                  // });

                  // log(sessionId);

                  // await Server().createStripeCustomer();
                  // final id = await retriveSession();
                  // await retrieveSubscription(id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent[
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'EZPaper',
                  billingDetails: const BillingDetails(
                      email: 'hafizhamzaali265@gmail.com',
                      address: Address(
                          city: 'Okara',
                          country: 'Pakistan',
                          line1: '',
                          line2: '',
                          postalCode: ' 53600',
                          state: 'Punjab'))))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        log(value.toString());
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));

        paymentIntent = {};
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Error is:---> $e');
      }
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $devStripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log(json.decode(response.body).toString());
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }
}

///

class StripeHelper {
  Future<void> subscriptions() async {
    final customer = await _createCustomer();
    // final paymentMethod = await _createPaymentMethod(
    //     number: '4242424242424242', expMonth: '03', expYear: '27', cvc: '123');
    var paymentMethod = await _createPaymentIntents();
    const billingDetails = BillingDetails(
      name: 'mazhar',
      email: 'chmazharali67@gmail.com',
      phone: '03404436743',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: 'Texas',
        state: 'Texas',
        postalCode: '77063',
      ),
    );

    await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
      number: '4242424242424242',
      expirationMonth: 03,
      expirationYear: 27,
      cvc: '123',
    ));
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: paymentMethod["client_secret"] ?? "",
      data: const PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ),
      options: const PaymentMethodOptions(
        setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
      ),
    );
    await _attachPaymentMethod(paymentMethod['id'], customer['id']);
    await _updateCustomer(paymentMethod['id'], customer['id']);
    await _createSubscriptions(customer['id']);
  }

  //
  Future<void> payment() async {
    final customer = await _createCustomer();
    final paymentIntent = await _createPaymentIntents();
    await _createCreditCard(customer['id'], paymentIntent['client_secret']);
  }
  //

  Future<Map<String, dynamic>> _createCustomer() async {
    const String url = 'https://api.stripe.com/v1/customers';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization':
            'Bearer $devStripeSecretKey', // Replace with your secret key
        // 'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': 'hafizhamzaali265@gmail.com',
        'name': 'Jenny Rosen',
        "description": 'new customer'
      }),
    );
    if (response.statusCode == 200) {
      log(response.body.toString());
      return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw 'Failed to register as a customer.';
    }
  }

  Future<Map<String, dynamic>> _createPaymentIntents() async {
    const String url = 'https://api.stripe.com/v1/payment_intents';

    Map<String, dynamic> body = {
      'amount': '2000',
      'currency': 'jpy',
      'payment_method_types[]': 'card'
    };

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer sk_test_4eC39HqLyjWDarjtT1zdp7dc',
          // 'Content-Type': 'application/json',
        },
        body: body);
    if (response.statusCode == 200) {
      log(response.body);
      return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw 'Failed to create PaymentIntents.';
    }
  }

  Future<void> _createCreditCard(
      String customerId, String paymentIntentClientSecret) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      style: ThemeMode.dark,
      merchantDisplayName: 'Flutter Stripe Store Demo',
      customerId: customerId,
      paymentIntentClientSecret: paymentIntentClientSecret,
    ));
  }

  // Future<Map<String, dynamic>> _createPaymentMethod(
  //     {required String number,
  //     required String expMonth,
  //     required String expYear,
  //     required String cvc}) async {
  //   const String url = 'https://api.stripe.com/v1/payment_methods';
  //   var response = await http.post(
  //     Uri.parse(url),
  //     headers: {
  //       'Authorization': 'Bearer $stripeSecretKey',
  //       // 'Content-Type': 'application/json',
  //     },
  //     body: {
  //       'type': 'card',
  //       'card[number]': number,
  //       'card[exp_month]': expMonth,
  //       'card[exp_year]': expYear,
  //       'card[cvc]': cvc,
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     return json.decode(response.body);
  //   } else {
  //     if (kDebugMode) {
  //       print(json.decode(response.body));
  //     }
  //     throw 'Failed to create PaymentMethod.';
  //   }
  // }

  Future<Map<String, dynamic>> _attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $devStripeSecretKey',
        // 'Content-Type': 'application/json',
      },
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      log('>>> ${response.body} ');
      return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw 'Failed to attach PaymentMethod.';
    }
  }

  Future<Map<String, dynamic>> _updateCustomer(
      String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $devStripeSecretKey',
        // 'Content-Type': 'application/json',
      },
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      log('>>> ${response.body} ');
      return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw 'Failed to update Customer.';
    }
  }

  Future<Map<String, dynamic>> _createSubscriptions(String customerId) async {
    const String url = 'https://api.stripe.com/v1/subscriptions';

    Map<String, dynamic> body = {
      'customer': customerId,
      'items[0][price]': '100',
    };

    var response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $devStripeSecretKey',
          // 'Content-Type': 'application/json',
        },
        body: body);
    if (response.statusCode == 200) {
      log('Subscription >>>> ${response.body.toString()}');
      return json.decode(response.body);
    } else {
      if (kDebugMode) {
        print(json.decode(response.body));
      }
      throw 'Failed to register as a subscriber.';
    }
  }
}

/// Don't you dare do it in real apps!
class Server {
  Future<String> createCheckout(String priceId) async {
    final auth = 'Basic ${base64Encode(utf8.encode('$devStripeSecretKey:'))}';
    final body = {
      'payment_method_types[]': "card",
      'line_items': [
        {
          'price': priceId,
          'quantity': 1,
        }
      ],
      'mode': 'subscription',
      'success_url': 'http://localhost:8080/#/success',
      'cancel_url': 'http://localhost:8080/#/cancel',
    };

    try {
      final result = await Dio().post(
        "https://api.stripe.com/v1/checkout/sessions",
        data: body,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: auth},
          contentType: "application/x-www-form-urlencoded",
        ),
      );
      log(result.data.toString());
      return result.data['id'];
    } on DioException catch (e) {
      log(e.response.toString());
      rethrow;
    }
  }

  Future<String> createStripePrice() async {
    const String apiUrl = 'https://api.stripe.com/v1/prices';
    final auth =
        'Basic ${base64Encode(utf8.encode('sk_test_51OZeXADxmlJVJmKm8vT3NpvsbS4rLpCflPmMh7ByxzRRD4KsmI4nPIsltn8p6MViAo8bYirwUhrJGZ1gdpl3dTOY00y2YZJ2KY:'))}';

    Map<String, dynamic> requestData = {
      'currency': 'USD',
      'unit_amount': '1000',
      'recurring': {
        'interval': 'month',
      },
      'product_data': {
        'name': 'Gold Plan',
      },
    };

    log(requestData.toString());
    final result = await Dio().post(
      apiUrl,
      data: requestData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: auth},
        contentType: "application/x-www-form-urlencoded",
      ),
    );
    if (result.statusCode == 200) {
      // Success
      log('Stripe Price created successfully');
      log(result.data.toString());
      log(result.data['id'].toString());
      return result.data['id'].toString();
    } else {
      // Handle errors
      log('Failed to create Stripe Price. Status code: ${result.statusCode}');
      log('Response body: ${result.data}');
      return '';
    }
  }

  Future<void> createStripeCustomer() async {
    const String apiUrl = 'https://api.stripe.com/v1/customers';
    final auth = 'Basic ${base64Encode(utf8.encode('$devStripeSecretKey:'))}';

    Map<String, dynamic> requestData = {
      'name': 'Hamza Ali',
      'email': 'hafizhamzaali265@gmail.com',
    };

    log(requestData.toString());
    final result = await Dio().post(
      apiUrl,
      data: requestData,
      options: Options(
        headers: {HttpHeaders.authorizationHeader: auth},
        contentType: "application/x-www-form-urlencoded",
      ),
    );
    if (result.statusCode == 200) {
      // Success
      log('Stripe customer created successfully');
      log(result.data.toString());
    } else {
      // Handle errors
      log('Failed to create Stripe customer. Status code: ${result.statusCode}');
      log('Response body: ${result.data}');
    }
  }
}

Future<String> retriveSession() async {
  String apiKey = devStripeSecretKey;
  String endpoint =
      'https://api.stripe.com/v1/checkout/sessions/cs_test_a12dmf6R0pLeyqZKboaO5ruP3ttChTAiaeP1vNeNyvQFPSalIkw6fW8rnM';

  try {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful response
      Map<String, dynamic> sessionData = json.decode(response.body);
      // log('Checkout Session Data: $sessionData');
      return sessionData['subscription'].toString();
      // Now you can use sessionData as needed
    } else {
      // Handle error
      log('Error retrieving checkout session. Status code: ${response.statusCode}');
      // log('Response body: ${response.body}');
      return '';
    }
  } catch (error) {
    // Handle network or other errors
    log('Error: $error');
    return '';
  }
}

Future<void> retrieveSubscription(String subscriptionId) async {
  String apiKey = devStripeSecretKey;
  String endpoint = 'https://api.stripe.com/v1/subscriptions/$subscriptionId';

  try {
    final response = await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Successful response
      Map<String, dynamic> subscriptionData = json.decode(response.body);
      log('Subscription Data: $subscriptionData');
      // Now you can use subscriptionData as needed
    } else {
      // Handle error
      log('Error retrieving subscription. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  } catch (error) {
    // Handle network or other errors
    log('Error: $error');
  }
}

class PaymentPage extends StatefulWidget {
  final String id;

  const PaymentPage({super.key, required this.id});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  WebViewController? controller;
  bool isPageLoading = false;
  @override
  void initState() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            setState(() {
              isPageLoading = true;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            if (url == 'https://marcinusx.github.io/test1/index.html') {
              _redirectToStripe(widget.id);
            }
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) async {
            // if (request.url.contains('finish')) {
            //   // Handle successful payment
            //   // await controller!
            //   //     .runJavaScriptReturningResult("self.find('successful!')")
            //   //     .then((value) => log("result: $value"));
            // } else if (request.url.contains('payment_failure')) {
            //   // Handle payment failure
            //   log('payment_failure');
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://marcinusx.github.io/test1/index.html'),
      );

    super.initState();
  }

  @override
  void dispose() {
    controller = null;
    super.dispose();
  }

  Future<void> _redirectToStripe(String sessionId) async {
    final redirectToCheckoutJs = '''
var stripe = Stripe('$devPublishableKey');
    
stripe.redirectToCheckout({
  sessionId: '$sessionId'
}).then(function (result) {
  result.error.message = 'Error'
});
''';

    try {
      await controller!.runJavaScript(redirectToCheckoutJs);
    } on PlatformException catch (e) {
      if (!e.details.contains(
          'JavaScript execution returned a result of an unsupported type')) {
        rethrow;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PayFast Payment'),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: controller!),
          ],
        ));
  }
}

Future<String> createStripePrice() async {
  const String cloudFunctionUrl =
      'https://us-central1-ezpaper-8ef2a.cloudfunctions.net/createStripePrice'; // Replace with your actual Cloud Function URL

  Map<String, dynamic> requestData = {
    'currency': 'USD',
    'unit_amount': '1000',
    'recurring': {
      'interval': 'month',
    },
    'product_data': {
      'name': 'Gold Plan',
    },
  };

  log(requestData.toString());

  try {
    final response = await http.post(
      Uri.parse(cloudFunctionUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      // Success
      log('Stripe Price created successfully');
      log(response.body);
      return response.body;
    } else {
      // Handle errors
      log('Failed to create Stripe Price. Status code: ${response.statusCode}');
      log('Response body: ${response.body}');
      return '';
    }
  } catch (error) {
    // Handle exceptions
    log('Error: $error');
    return '';
  }
}
