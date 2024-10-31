class ReadingRoom {
  final String name;
  final List<SeatRange> seatRanges;
  final String floor;

  ReadingRoom({
    required this.name,
    required this.seatRanges,
    required this.floor,
  });
}

class SeatRange {
  final int start;
  final int end;

  SeatRange(this.start, this.end);
}