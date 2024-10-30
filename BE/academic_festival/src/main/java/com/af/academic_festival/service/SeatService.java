package com.af.academic_festival.service;

import com.af.academic_festival.dto.request.SeatAssignRequest;
import com.af.academic_festival.dto.response.SeatResponse;
import com.af.academic_festival.exception.CustomException;
import com.af.academic_festival.exception.ErrorCode;
import com.af.academic_festival.model.Seat;
import com.af.academic_festival.model.User;
import com.af.academic_festival.repository.SeatRepository;
import com.af.academic_festival.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.messaging.simp.SimpMessagingTemplate;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SeatService {
    private final SeatRepository seatRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public SeatResponse assignSeat(SeatAssignRequest request) {
        // 사용자 확인
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        // 이미 배정된 좌석이 있는지 확인
        if (user.getCurrentSeatId() != null) {
            throw new RuntimeException("이미 배정된 좌석이 있습니다.");
        }

        // 사용 가능한 좌석 찾기
        List<Seat> availableSeats = seatRepository.findAvailableSeats(
                request.getFloor(),
                request.getSeatType()
        );

        if (availableSeats.isEmpty()) {
            throw new RuntimeException("사용 가능한 좌석이 없습니다.");
        }

        // 첫 번째 가용 좌석 배정
        Seat selectedSeat = availableSeats.get(0);
        selectedSeat.occupy(user.getUserId());
        seatRepository.save(selectedSeat);

        // 사용자 정보 업데이트
        user.assignSeat(selectedSeat.getSeatId());
        userRepository.save(user);

        return convertToSeatResponse(selectedSeat);
    }

    public List<SeatResponse> getAllSeats() {
        return seatRepository.findAll().stream()
                .map(this::convertToSeatResponse)
                .collect(Collectors.toList());
    }

    public void releaseSeat(String seatId) {
        Seat seat = seatRepository.findById(seatId)
                .orElseThrow(() -> new RuntimeException("좌석을 찾을 수 없습니다."));

        if (seat.getCurrentUserId() != null) {
            User user = userRepository.findById(seat.getCurrentUserId())
                    .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));
            user.releaseSeat();
            userRepository.save(user);
        }

        seat.release();
        seatRepository.save(seat);
    }

    public void updateLocationStatus(String userId, boolean isPresent) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(ErrorCode.USER_NOT_FOUND));

        if (user.getCurrentSeatId() != null) {
            Seat seat = seatRepository.findById(user.getCurrentSeatId())
                    .orElseThrow(() -> new CustomException(ErrorCode.SEAT_NOT_FOUND));

            if (!isPresent) {
                // Flutter에서 자리 이탈을 감지하면 알림 전송
                messagingTemplate.convertAndSendToUser(
                        userId,
                        "/queue/notifications",
                        "자리를 이탈하셨습니다. 자리비움 설정을 하시겠습니까?"
                );
            }

            seat.updateLocationStatus(isPresent);
            seatRepository.save(seat);
        }
    }

    private SeatResponse convertToSeatResponse(Seat seat) {
        return SeatResponse.builder()
                .seatId(seat.getSeatId())
                .seatType(seat.getSeatType())
                .floor(seat.getFloor())
                .status(seat.getStatus())
                .currentUserId(seat.getCurrentUserId())
                .lastConnectedTime(seat.getLastConnectedTime())
                .isVacant(seat.getIsVacant())
                .build();
    }
}