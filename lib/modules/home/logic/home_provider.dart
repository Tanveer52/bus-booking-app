import 'dart:developer';

import 'package:bus_booking_app/modules/home/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bus_model.dart';

final homeProvider = ChangeNotifierProvider<HomeNotifier>((ref) {
  return HomeNotifier();
});

class HomeNotifier extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();

  List<BusModel> buses = [];
  bool isLoading = false;

  Future<void> getAllBuses() async {
    isLoading = true;
    notifyListeners();
    buses = await homeRepository.getAllBuses();
    log(buses.toString());

    isLoading = false;
    notifyListeners();
  }

  void addSeatsToBus(String busId, List<String> seatList) {
    final BusModel bus = buses.firstWhere(
      (bus) => bus.id == busId,
      orElse: () => BusModel.empty,
    );

    if (bus != BusModel.empty) {
      List<SeatModel> newSeats = seatList.map((seat) {
        return SeatModel(
          seat: seat,
          userId: DateTime.now().microsecondsSinceEpoch.toString(),
          date: DateTime.now().toString(),
        );
      }).toList();

      bus.bookedSlots.addAll(newSeats);

      notifyListeners();
    } else {
      log('Bus with id $busId not found');
    }
  }
}
