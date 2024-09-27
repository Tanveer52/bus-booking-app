import 'package:bus_booking_app/modules/home/models/bus_model.dart';
import 'package:bus_booking_app/modules/home/screens/seat_selection_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BusCard extends StatelessWidget {
  final BusModel bus;
  const BusCard({
    super.key,
    required this.bus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SeatSelectionScreen(
                  bus: bus,
                )));
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpId-2bkjAQmP-pTAjsipLj_mAHkPNrDmtbg&s',
                  width: 100,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Colors.blue[800],
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ticket Price: \$${bus.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Available Seats: ${bus.totalSeats}',
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Departure: ${bus.time}',
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Date: ${bus.date}',
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
