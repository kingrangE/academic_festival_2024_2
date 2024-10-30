class User {
  final String id;
  final int grade;
  bool hasReservation;
  String? floor;
  String? roomType;
  String? seatNumber;
  int awayMinutes; // 자리 비움 누적 시간 (분)
  Duration? customAwayDuration; // 사용자 설정 자리 비움 시간

  User({
    required this.id,
    required this.grade,
    this.hasReservation = false,
    this.floor,
    this.roomType,
    this.seatNumber,
    this.awayMinutes = 0,
    this.customAwayDuration,
  });

  bool checkAndUpdateAwayStatus() {
    // 설정된 자리 비움 시간이 있는 경우
    if (customAwayDuration != null) {
      if (awayMinutes >= customAwayDuration!.inMinutes) {
        return true; // 반납 필요
      }
    }
    // 기본 30분 초과 체크
    else if (awayMinutes >= 30) {
      return true; // 반납 필요
    }
    return false;
  }

  void incrementAwayTime() {
    awayMinutes++;
  }

  void resetAwayTime() {
    awayMinutes = 0;
  }

  void setCustomAwayDuration(Duration duration) {
    customAwayDuration = duration;
  }

  void reserveSeat({
    required String floor,
    required String roomType,
    required String seatNumber,
  }) {
    this.floor = floor;
    this.roomType = roomType;
    this.seatNumber = seatNumber;
    hasReservation = true;
  }

  void cancelReservation() {
    floor = null;
    roomType = null;
    seatNumber = null;
    hasReservation = false;
    awayMinutes = 0;
    customAwayDuration = null;
  }
}