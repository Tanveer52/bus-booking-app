class BusModel {
  final String date;
  final List<SeatModel> bookedSlots;
  final int createdAt;
  final String price;
  final String busName;
  final String destination;
  final String from;
  final String id;
  final String time;
  final int totalSeats;
  final String status;
  final int updatedAt;

  BusModel({
    required this.date,
    required this.bookedSlots,
    required this.createdAt,
    required this.price,
    required this.busName,
    required this.destination,
    required this.from,
    required this.id,
    required this.time,
    required this.totalSeats,
    required this.status,
    required this.updatedAt,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      date: json['date'],
      bookedSlots: (json['bookedSlots'] as List<dynamic>)
          .map((slot) => SeatModel.fromJson(slot))
          .toList(),
      createdAt: json['createdAt'],
      price: json['price'],
      busName: json['busName'],
      destination: json['destination'],
      from: json['from'],
      id: json['id'],
      time: json['time'],
      totalSeats: json['totalSeats'],
      status: json['status'],
      updatedAt: json['updatedAt'],
    );
  }

  @override
  String toString() {
    return 'BusModel(date: $date, bookedSlots: $bookedSlots, createdAt: $createdAt, price: $price, busName: $busName, destination: $destination, from: $from, id: $id, time: $time, totalSeats: $totalSeats, status: $status, updatedAt: $updatedAt)';
  }

  static BusModel empty = BusModel(
    date: '',
    bookedSlots: [],
    createdAt: 0,
    price: '',
    busName: '',
    destination: '',
    from: '',
    id: '',
    time: '',
    totalSeats: 0,
    status: '',
    updatedAt: 0,
  );
}

class SeatModel {
  final String seat;
  final String userId;
  final String date;

  SeatModel({
    required this.seat,
    required this.userId,
    required this.date,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) {
    return SeatModel(
      seat: json['seat'],
      userId: json['userId'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seat': seat,
      'userId': userId,
      'date': date,
    };
  }

  @override
  String toString() => 'SeatModel(seat: $seat, userId: $userId, date: $date)';
}
