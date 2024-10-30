import 'package:flutter/material.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({super.key});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  String? selectedFloor;
  String? selectedType;
  String? selectedSeat;
  String? reservationMessage;

  final List<String> floors = ['1', '2', '3', '4'];
  final List<String> seatTypes = ['shared', 'individual'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xFF990000),),
      backgroundColor: const Color(0xFF990000),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '좌석 선택',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF990000),
                      ),
                    ),
                    SizedBox(height: 16),
                    // 층수 선택 드롭다운
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: '층수 선택',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      value: selectedFloor,
                      items: floors.map((String floor) {
                        return DropdownMenuItem<String>(
                          value: floor,
                          child: Text('$floor층'),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedFloor = value;
                        });
                      },
                    ),

                    SizedBox(height: 16),

                    // 좌석 유형 선택 드롭다운
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: '좌석 유형',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      value: selectedType,
                      items: seatTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          selectedType = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // 선택된 정보 표시
            if (selectedFloor != null || selectedType != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '선택 정보',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF990000),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (selectedFloor != null)
                        Text('선택된 층: $selectedFloor층'),
                      if (selectedType != null)
                        Text('선택된 유형: ${selectedType!.toUpperCase()}'),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // 좌석 선택 버튼
            if (selectedFloor != null && selectedType != null)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Color(0xFF990000), backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  final seatNumber = '${DateTime.now().millisecond % 100 + 1}';
                  setState(() {
                    selectedSeat = seatNumber;
                    reservationMessage = '$selectedFloor층 ${selectedType!.toUpperCase()} 좌석 $seatNumber번 예약 완료';
                  });
                },
                child: const Text(
                  '좌석 선택하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            SizedBox(height: 20),

            // 예약 완료 메시지
            if (reservationMessage != null)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        reservationMessage!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF990000),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}