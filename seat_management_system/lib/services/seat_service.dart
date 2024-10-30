import '../models/seat.dart';

class SeatService {
  // 좌석 목록 (예시 데이터)
  final List<Seat> seats = List.generate(
    10,
        (index) => Seat(
      seatNumber: index + 1,
      isOccupied: false,
      location: 'Library Section A',
    ),
  );

  // 좌석 선택 기능
  void selectSeat(int seatNumber) {
    final seat = seats.firstWhere((seat) => seat.seatNumber == seatNumber);
    if (!seat.isOccupied) {
      seat.isOccupied = true;
      print('Seat $seatNumber has been selected.');
    } else {
      print('Seat $seatNumber is already occupied.');
    }
  }

  // 좌석 상태 확인 기능
  void checkSeatStatus(int seatNumber) {
    final seat = seats.firstWhere((seat) => seat.seatNumber == seatNumber);
    if (seat.isOccupied) {
      print('Seat $seatNumber is currently occupied.');
    } else {
      print('Seat $seatNumber is available.');
    }
  }
}
