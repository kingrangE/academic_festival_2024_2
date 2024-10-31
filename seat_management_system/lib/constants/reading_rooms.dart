import '../models/reading_room.dart';

final List<ReadingRoom> readingRooms = [
  // B1층
  ReadingRoom(
    name: '제1열람실A',
    floor: 'B1',
    seatRanges: [
      SeatRange(1, 78),
      SeatRange(65, 172),
      SeatRange(189, 189),
    ],
  ),
  ReadingRoom(
    name: '제1열람실B',
    floor: 'B1',
    seatRanges: [
      SeatRange(79, 164),
      SeatRange(173, 188),
    ],
  ),
  // 1층
  ReadingRoom(
    name: '제2열람실',
    floor: '1',
    seatRanges: [SeatRange(1, 111)],
  ),
  ReadingRoom(
    name: '제3열람실',
    floor: '1',
    seatRanges: [SeatRange(1, 107)],
  ),
  // 3층
  ReadingRoom(
    name: '제4열람실A',
    floor: '3',
    seatRanges: [SeatRange(1, 146)],
  ),
  ReadingRoom(
    name: '제4열람실B',
    floor: '3',
    seatRanges: [SeatRange(147, 292)],
  ),
  ReadingRoom(
    name: '제5열람실',
    floor: '3',
    seatRanges: [SeatRange(1, 94)],
  ),
  // 4층
  ReadingRoom(
    name: '제6열람실',
    floor: '4',
    seatRanges: [SeatRange(1, 165)],
  ),
];