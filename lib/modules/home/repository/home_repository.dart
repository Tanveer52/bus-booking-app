import 'dart:convert';
import 'dart:developer';

import 'package:bus_booking_app/modules/home/models/bus_model.dart';
import 'package:bus_booking_app/modules/home/repository/base_home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../../../config/app_router.dart';

class HomeRepository extends BaseHomeRepository {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  @override
  Future<List<BusModel>> getAllBuses() async {
    try {
      List<BusModel> buses = [];
      final response = await http.get(Uri.parse(
          'https://us-central1-galiileo.cloudfunctions.net/getAllBuses'));

      // log('-> Response is : ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final List<dynamic> data = json.decode(response.body);

        // Map the parsed data to BusModel instances and add them to the list
        buses = data.map((busData) => BusModel.fromJson(busData)).toList();
      } else {
        AppRouter.showAlertWithTitle('Error', 'Something went wrong');
      }

      // log('Returning buses: $buses');

      return buses;
    } catch (e) {
      log('>>>> ${e.toString()}');
      AppRouter.showAlertWithTitle('Error', e.toString());
      return [];
    }
  }

  @override
  Future<bool> reserveBus(
      {required String busId,
      required String userId,
      required List<String> seats,
      required String date}) async {
    try {
      bool result = false;

      // Construct the request body as a JSON payload
      final Map<String, dynamic> body = {
        'busId': busId,
        'userId': userId,
        'seats':
            seats, // Ensure seats are passed as List<String>, not as String
        'date': date,
      };

      final response = await http.post(
        Uri.parse(
            'https://us-central1-galiileo.cloudfunctions.net/reserveSeat'),
        headers: {
          'Content-Type':
              'application/json', // Specify that the body is in JSON format
        },
        body: jsonEncode(body), // Encode the body as a JSON payload
      );

      log('-> Response is : ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        log(response.body);
        result = true;
      } else {
        AppRouter.showAlertWithTitle('Error', 'Something went wrong');
        result = false;
      }

      return result;
    } catch (e) {
      log('>>>> ${e.toString()}');
      AppRouter.showAlertWithTitle('Error', e.toString());
      return false;
    }
  }

  @override
  Future<bool> uploadPaymentProof(
      {required String busId,
      required String userId,
      required List<String> seats,
      required String date,
      required String screenshotUrl}) async {
    try {
      bool result = false;

      // Construct the request body as a JSON payload
      final Map<String, dynamic> body = {
        'busId': busId,
        'userId': userId,
        'seats':
            seats, // Ensure seats are passed as List<String>, not as String
        'date': date,
        'screenshotUrl': screenshotUrl,
      };

      final response = await http.post(
        Uri.parse(
            'https://us-central1-galiileo.cloudfunctions.net/uploadPaymentProof'),
        headers: {
          'Content-Type':
              'application/json', // Specify that the body is in JSON format
        },
        body: jsonEncode(body), // Encode the body as a JSON payload
      );

      log('-> Response is : ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        log(response.body);
        result = true;
      } else {
        AppRouter.showAlertWithTitle('Error', 'Something went wrong');
        result = false;
      }

      return result;
    } catch (e) {
      log('>>>> ${e.toString()}');
      AppRouter.showAlertWithTitle('Error', e.toString());
      return false;
    }
  }
}
