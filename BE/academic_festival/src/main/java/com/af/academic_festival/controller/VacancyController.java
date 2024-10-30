package com.af.academic_festival.controller;

import com.af.academic_festival.dto.request.VacancySettingRequest;
import com.af.academic_festival.dto.response.ApiResponse;
import com.af.academic_festival.service.VacancyService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/vacancy")
@RequiredArgsConstructor
public class VacancyController {

    private final VacancyService vacancyService;

    @PostMapping("/set")
    public ResponseEntity<ApiResponse<Void>> setVacancy(
            @Valid @RequestBody VacancySettingRequest request) {
        vacancyService.setVacancy(request);
        return ResponseEntity.ok(new ApiResponse<>(true, "자리비움이 설정되었습니다.", null));
    }

    @DeleteMapping("/{userId}/cancel")
    public ResponseEntity<ApiResponse<Void>> cancelVacancy(
            @PathVariable String userId) {
        vacancyService.cancelVacancy(userId);
        return ResponseEntity.ok(new ApiResponse<>(true, "자리비움이 취소되었습니다.", null));
    }

    @GetMapping("/{userId}")
    public ResponseEntity<ApiResponse<Integer>> getRemainingVacancyTime(
            @PathVariable String userId) {
        int remainingMinutes = vacancyService.getRemainingVacancyTime(userId);
        return ResponseEntity.ok(new ApiResponse<>(true, "남은 자리비움 시간 조회 성공", remainingMinutes));
    }
}