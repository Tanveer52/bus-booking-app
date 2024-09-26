import 'dart:developer';
import 'dart:io';

import 'package:bus_booking_app/constants/asset_paths.dart';
import 'package:bus_booking_app/utils/image_picker.dart';
import 'package:bus_booking_app/utils/stripe_example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/constants.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key, required this.ticketPrice});

  final double ticketPrice;

  @override
  SeatSelectionScreenState createState() => SeatSelectionScreenState();
}

class SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Seat'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
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

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedSeats.remove(seat);
                      } else {
                        selectedSeats.add(seat);
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orange : Colors.grey[300],
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
            onTap: _showPaymentBottomSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'CHECKOUT \$${(selectedSeats.length * widget.ticketPrice).toStringAsFixed(2)}',
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
    );
  }

  void _showPaymentBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
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
              _buildPaymentButton(
                label: 'Stripe Payment',
                image: AppAssets.stripeSVG,
                onTap: () {
                  log('Stripe Payment selected');

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StripeExample()));

                  // Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              _buildPaymentButton(
                label: 'Upload Receipt',
                image: AppAssets.uploadSVG,
                onTap: () async {
                  final File? pickedFile = await pickImage();

                  if (pickedFile != null) {
                    log('Receipt uploaded');
                  }

                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentButton(
      {required String label,
      required String image,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              image,
              height: 25,
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
