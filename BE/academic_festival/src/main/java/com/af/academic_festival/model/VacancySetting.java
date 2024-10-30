package com.af.academic_festival.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
public class VacancySetting {
    private String id;
    private String userId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Integer durationMinutes;

    // 자리비움 시간이 만료되었는지 확인
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(endTime);
    }

    // 남은 시간 계산 (분 단위)
    public int getRemainingMinutes() {
        if (isExpired()) {
            return 0;
        }
        LocalDateTime now = LocalDateTime.now();
        return (int) java.time.Duration.between(now, endTime).toMinutes();
    }

    // 새로운 자리비움 설정 생성
    public static VacancySetting create(String userId, int minutes) {
        LocalDateTime now = LocalDateTime.now();
        return VacancySetting.builder()
                .id(java.util.UUID.randomUUID().toString())
                .userId(userId)
                .startTime(now)
                .endTime(now.plusMinutes(minutes))
                .durationMinutes(minutes)
                .build();
    }
}