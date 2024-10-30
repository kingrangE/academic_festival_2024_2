class Seat {
  final int seatNumber;
  bool isOccupied; // 수정된 부분
  final String location;

  Seat({
    required this.seatNumber,
    required this.isOccupied,
    required this.location,
  });
}
