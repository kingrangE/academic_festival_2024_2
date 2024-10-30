// lib/widgets/reservation_card.dart
import 'package:flutter/material.dart';

class ReservationCard extends StatelessWidget {
  final String floor;
  final String roomName;
  final String seatNumber;
  final Duration awayTime;
  final bool hasActiveReservation;

  const ReservationCard({
    super.key,
    this.floor = '3',
    this.roomName = '제1열람실',
    this.seatNumber = '12',
    this.awayTime = const Duration(minutes: 30),
    this.hasActiveReservation = true,
  });

  @override
  Widget build(BuildContext context) {
    print(seatNumber);
    if (!hasActiveReservation) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '현재 예약',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC31632),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFC31632).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '자리 비움: ${awayTime.inMinutes}분',
                  style: const TextStyle(
                    color: Color(0xFFC31632),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoColumn('층', floor),
              const SizedBox(width: 24),
              _buildInfoColumn('열람실', roomName),
              const SizedBox(width: 24),
              _buildInfoColumn('좌석 번호', seatNumber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}