package com.af.academic_festival.controller;

import com.af.academic_festival.dto.request.SeatAssignRequest;
import com.af.academic_festival.dto.response.ApiResponse;
import com.af.academic_festival.dto.response.SeatResponse;
import com.af.academic_festival.service.SeatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/seats")
@RequiredArgsConstructor
public class SeatController {

    private final SeatService seatService;

    @PostMapping("/assign")
    public ResponseEntity<ApiResponse<SeatResponse>> assignSeat(
            @Valid @RequestBody SeatAssignRequest request) {
        SeatResponse seat = seatService.assignSeat(request);
        return ResponseEntity.ok(new ApiResponse<>(true, "좌석이 성공적으로 배정되었습니다.", seat));
    }

    @GetMapping
    public ResponseEntity<ApiResponse<List<SeatResponse>>> getAllSeats() {
        List<SeatResponse> seats = seatService.getAllSeats();
        return ResponseEntity.ok(new ApiResponse<>(true, "전체 좌석 조회 성공", seats));
    }

    @PostMapping("/{seatId}/release")
    public ResponseEntity<ApiResponse<Void>> releaseSeat(@PathVariable String seatId) {
        seatService.releaseSeat(seatId);
        return ResponseEntity.ok(new ApiResponse<>(true, "좌석이 성공적으로 반환되었습니다.", null));
    }

    @PostMapping("/update-status")
    public ResponseEntity<ApiResponse<Void>> updateWifiStatus(
            @RequestParam String userId,
            @RequestParam boolean isConnected) {
        seatService.updateLocationStatus(userId, isConnected);
        return ResponseEntity.ok(new ApiResponse<>(true, "WiFi 상태가 업데이트되었습니다.", null));
    }
}