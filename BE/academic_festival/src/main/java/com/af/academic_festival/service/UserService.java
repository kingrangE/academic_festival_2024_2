package com.af.academic_festival.service;

import com.af.academic_festival.dto.request.UserLoginRequest;
import com.af.academic_festival.dto.response.SeatResponse;
import com.af.academic_festival.dto.response.UserResponse;
import com.af.academic_festival.model.Seat;
import com.af.academic_festival.model.User;
import com.af.academic_festival.repository.SeatRepository;
import com.af.academic_festival.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserService {
    private final UserRepository userRepository;
    private final SeatRepository seatRepository;

    public UserResponse login(UserLoginRequest request) {
        User user = userRepository.findByStudentId(request.getStudentId())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        if (!user.getPassword().equals(request.getPassword())) {
            throw new RuntimeException("비밀번호가 일치하지 않습니다.");
        }

        return convertToUserResponse(user);
    }

    public UserResponse getUserInfo(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        return convertToUserResponse(user);
    }

    public SeatResponse getCurrentSeat(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        if (user.getCurrentSeatId() == null) {
            throw new RuntimeException("배정된 좌석이 없습니다.");
        }

        Seat seat = seatRepository.findById(user.getCurrentSeatId())
                .orElseThrow(() -> new RuntimeException("좌석을 찾을 수 없습니다."));

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

    private UserResponse convertToUserResponse(User user) {
        return UserResponse.builder()
                .userId(user.getUserId())
                .studentId(user.getStudentId())
                .name(user.getName())
                .checkOutCount(user.getCheckOutCount())
                .currentSeatId(user.getCurrentSeatId())
                .build();
    }
}