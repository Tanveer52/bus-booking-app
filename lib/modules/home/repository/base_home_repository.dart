import 'package:bus_booking_app/modules/home/models/bus_model.dart';

abstract class BaseHomeRepository {
  Future<List<BusModel>> getAllBuses();
  Future<bool> reserveBus({
    required String busId,
    required String userId,
    required List<String> seats,
    required String date,
  });
  Future<bool> uploadPaymentProof({
    required String busId,
    required String userId,
    required List<String> seats,
    required String date,
    required String screenshotUrl,
  });
}
