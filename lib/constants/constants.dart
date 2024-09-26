import 'package:bus_booking_app/modules/home/models/bus_model.dart';

final List<BusModel> buses = [
  BusModel(
    image:
        'https://media.gettyimages.com/id/135327019/photo/white-passenger-bus.jpg?s=612x612&w=gi&k=20&c=oOnC5CrZI23rf4fy3EvKzL0LsJ3nBkDXJfEmrSN0qPo=',
    price: 20.0,
    seats: '5',
    departureTime: '12:00 PM',
    date: 'Sept 30, 2024',
  ),
  BusModel(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpId-2bkjAQmP-pTAjsipLj_mAHkPNrDmtbg&s',
    price: 18.0,
    seats: '8',
    departureTime: '03:00 PM',
    date: 'Sept 30, 2024',
  ),
  BusModel(
    image:
        'https://upload.wikimedia.org/wikipedia/commons/thumb/6/63/LT_471_%28LTZ_1471%29_Arriva_London_New_Routemaster_%2819522859218%29.jpg/1200px-LT_471_%28LTZ_1471%29_Arriva_London_New_Routemaster_%2819522859218%29.jpg',
    price: 25.0,
    seats: '3',
    departureTime: '05:30 PM',
    date: 'Sept 30, 2024',
  ),
  BusModel(
    image:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFttp4rZbqTRvHMLVU13JHKouuM39KZnxCSg&s',
    price: 22.0,
    seats: '12',
    departureTime: '07:00 PM',
    date: 'Sept 30, 2024',
  ),
];

final List<String> seatLabels = [
  'A1',
  'A2',
  'A3',
  'A4',
  'A5',
  'A6',
  'B1',
  'B2',
  'B3',
  'B4',
  'B5',
  'B6',
  'C1',
  'C2',
  'C3',
  'C4',
  'C5',
  'C6',
  'D1',
  'D2',
  'D3',
  'D4',
  'D5',
  'D6'
];

const String devStripeSecretKey =
    'sk_test_51OZeXADxmlJVJmKm8vT3NpvsbS4rLpCflPmMh7ByxzRRD4KsmI4nPIsltn8p6MViAo8bYirwUhrJGZ1gdpl3dTOY00y2YZJ2KY';
const String devPublishableKey =
    'pk_test_51OZeXADxmlJVJmKmEFVBQvVYxvpWTXte1leMMk5u4GEOpV7Cgt2H0fuPJ2bQBPB91Odj0nC4B36wwkSRJV5dnR1600yvHX7wzy';
