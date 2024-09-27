// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:bus_booking_app/constants/asset_paths.dart';
import 'package:bus_booking_app/modules/home/models/bus_model.dart';
import 'package:bus_booking_app/modules/home/repository/home_repository.dart';
import 'package:bus_booking_app/modules/home/repository/receipt_repository.dart';
import 'package:bus_booking_app/utils/image_picker.dart';
import 'package:bus_booking_app/utils/stripe_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../logic/home_provider.dart';

class SeatSelectionScreen extends ConsumerStatefulWidget {
  const SeatSelectionScreen({super.key, required this.bus});

  final BusModel bus;

  @override
  SeatSelectionScreenState createState() => SeatSelectionScreenState();
}

class SeatSelectionScreenState extends ConsumerState<SeatSelectionScreen> {
  final ReceiptRepository receiptRepository = ReceiptRepository();
  final List<String> selectedSeats = [];
  bool isUploadingProof = false;

  int amountToDeduct = 0;

  final HomeRepository homeRepository = HomeRepository();

  List<String> generateSeatLabels(int totalSeats) {
    final List<String> seatLabels = [];
    const int seatsPerRow = 4;
    const List<String> rowLabels = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K'
    ];

    for (int i = 0; i < totalSeats; i++) {
      final row = rowLabels[i ~/ seatsPerRow];
      final seatNumber = (i % seatsPerRow) + 1;
      seatLabels.add('$row$seatNumber');
    }

    return seatLabels;
  }

  @override
  Widget build(BuildContext context) {
    final seatLabels = generateSeatLabels(widget.bus.totalSeats);
    ref.watch(stripeProvider);
    ref.watch(homeProvider);
    final stripeService = ref.watch(stripeProvider.notifier);
    final homeService = ref.watch(homeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Seat'),
        backgroundColor: Colors.blue[800],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Class: Business',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: seatLabels.length,
                  itemBuilder: (context, index) {
                    final seat = seatLabels[index];
                    final isSelected = selectedSeats.contains(seat);

                    final bool isAlreadyBooked = widget.bus.bookedSlots
                        .where(
                          (bookedSeat) => bookedSeat.seat == seat,
                        )
                        .isNotEmpty;

                    return GestureDetector(
                      onTap: isAlreadyBooked
                          ? null
                          : () {
                              setState(() {
                                if (isSelected) {
                                  selectedSeats.remove(seat);
                                } else {
                                  selectedSeats.add(seat);
                                }

                                setState(() {
                                  amountToDeduct = (selectedSeats.length *
                                          int.parse(widget.bus.price))
                                      .toInt();
                                });
                              });
                            },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange
                              : isAlreadyBooked
                                  ? Colors.orange[100]
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            seat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) {
                      return Consumer(
                        builder: (context, ref, child) {
                          final stripeService =
                              ref.watch(stripeProvider.notifier);
                          return Container(
                            padding: const EdgeInsets.all(20),
                            height: 250,
                            child: Column(
                              children: [
                                const Text(
                                  'Choose Payment Method',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 25),
                                GestureDetector(
                                  onTap: () async {
                                    if (amountToDeduct == 0) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'No Seat Selected',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            content: const Text(
                                              'Please select a seat.',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            actions: [
                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blue[800],
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text(
                                                  'Select',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      await stripeService
                                          .makePayment(amount: amountToDeduct)
                                          .then((result) async {
                                        if (result) {
                                          final reserveResult =
                                              await homeRepository.reserveBus(
                                            busId: widget.bus.id,
                                            userId: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString(),
                                            seats: selectedSeats,
                                            date: widget.bus.date,
                                          );
                                          if (reserveResult) {
                                            homeService.addSeatsToBus(
                                                widget.bus.id, selectedSeats);
                                          }
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.stripeSVG,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          'Stripe Payment',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                GestureDetector(
                                  onTap: () async {
                                    final File? pickedFile = await pickImage();

                                    if (pickedFile != null) {
                                      setState(() {
                                        isUploadingProof = true;
                                      });
                                      final String receiptUrl =
                                          await receiptRepository.uploadReceipt(
                                              receipt: pickedFile);
                                      await homeRepository.uploadPaymentProof(
                                          busId: widget.bus.id,
                                          userId: DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                          seats: selectedSeats,
                                          date: widget.bus.date,
                                          screenshotUrl: receiptUrl);
                                      homeService.addSeatsToBus(
                                          widget.bus.id, selectedSeats);
                                      setState(() {
                                        isUploadingProof = false;
                                      });

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.uploadSVG,
                                          height: 25,
                                        ),
                                        const SizedBox(width: 20),
                                        const Text(
                                          'Upload Receipt',
                                          style: TextStyle(color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'CHECKOUT \$${(selectedSeats.length * int.parse(widget.bus.price)).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          if (stripeService.isLoading)
            Positioned(
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ))),
            ),
          if (isUploadingProof)
            Positioned(
              child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: Colors.white,
                  ))),
            ),
        ],
      ),
    );
  }
}
