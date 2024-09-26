import 'dart:convert';

class BusModel {
  final String image;
  final double price;
  final String seats;
  final String departureTime;
  final String date;

  BusModel({
    required this.image,
    required this.price,
    required this.seats,
    required this.departureTime,
    required this.date,
  });

  BusModel copyWith({
    String? image,
    double? price,
    String? seats,
    String? departureTime,
    String? date,
  }) {
    return BusModel(
      image: image ?? this.image,
      price: price ?? this.price,
      seats: seats ?? this.seats,
      departureTime: departureTime ?? this.departureTime,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'image': image,
      'price': price,
      'seats': seats,
      'departureTime': departureTime,
      'date': date,
    };
  }

  factory BusModel.fromMap(Map<String, dynamic> map) {
    return BusModel(
      image: map['image'] as String,
      price: map['price'] as double,
      seats: map['seats'] as String,
      departureTime: map['departureTime'] as String,
      date: map['date'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory BusModel.fromJson(String source) =>
      BusModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BusModel(image: $image, price: $price, seats: $seats, departureTime: $departureTime, date: $date)';
  }

  @override
  bool operator ==(covariant BusModel other) {
    if (identical(this, other)) return true;

    return other.image == image &&
        other.price == price &&
        other.seats == seats &&
        other.departureTime == departureTime &&
        other.date == date;
  }

  @override
  int get hashCode {
    return image.hashCode ^
        price.hashCode ^
        seats.hashCode ^
        departureTime.hashCode ^
        date.hashCode;
  }
}
