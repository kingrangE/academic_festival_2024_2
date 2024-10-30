package com.af.academic_festival.controller;

import com.af.academic_festival.dto.request.UserLoginRequest;
import com.af.academic_festival.dto.response.ApiResponse;
import com.af.academic_festival.dto.response.SeatResponse;
import com.af.academic_festival.dto.response.UserResponse;
import com.af.academic_festival.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<UserResponse>> login(
            @Valid @RequestBody UserLoginRequest request) {
        UserResponse user = userService.login(request);
        return ResponseEntity.ok(new ApiResponse<>(true, "로그인 성공", user));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<ApiResponse<UserResponse>> getUserInfo(
            @PathVariable String userId) {
        UserResponse user = userService.getUserInfo(userId);
        return ResponseEntity.ok(new ApiResponse<>(true, "사용자 정보 조회 성공", user));
    }

    @GetMapping("/{userId}/current-seat")
    public ResponseEntity<ApiResponse<SeatResponse>> getCurrentSeat(
            @PathVariable String userId) {
        SeatResponse seat = userService.getCurrentSeat(userId);
        return ResponseEntity.ok(new ApiResponse<>(true, "현재 좌석 조회 성공", seat));
    }
}