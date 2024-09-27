import 'dart:developer';
import 'package:bus_booking_app/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create a ChangeNotifierProvider for StripeNotifier
final stripeProvider = ChangeNotifierProvider<StripeNotifier>((ref) {
  return StripeNotifier();
});

// ChangeNotifier for Stripe Payment Logic
class StripeNotifier extends ChangeNotifier {
  bool isLoading = false;
  String? _paymentIntentClientSecret;

  String? get paymentIntentClientSecret => _paymentIntentClientSecret;

  // Method to start the payment process
  Future<bool> makePayment({required int amount}) async {
    try {
      _setLoading(true);

      _paymentIntentClientSecret = await _createPaymentIntent(amount, "usd");
      if (_paymentIntentClientSecret == null) {
        _setLoading(false);
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: _paymentIntentClientSecret!,
          merchantDisplayName: "Tanveer Ahmad",
        ),
      );
      final result = await _processPayment();

      log('------------------------------------');

      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      log(e.toString());
      return false;
    }
  }

  // Private method to create Payment Intent via Stripe API
  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $devStripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  // Private method to process the payment
  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet().whenComplete(() {
        _setLoading(false);
        log('Payment Successfull');
      });
      return true;
    } catch (e) {
      log(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Private method to calculate the amount in cents
  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }

  // Private method to manage loading state
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners(); // Notify listeners of state change
    log('is loading: $isLoading');
  }
}
