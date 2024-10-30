package com.af.academic_festival.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class LocationUtil {

    /**
     * 위치 상태 변경 로깅
     */
    public void logLocationStatus(String userId, boolean isPresent) {
        log.info("Location Status Changed - User: {}, Present: {}", userId, isPresent);

        if (!isPresent) {
            log.warn("User {} is not present at their seat", userId);
        }
    }

    /**
     * 자리 이탈 시간 계산 (밀리초 단위)
     */
    public long calculateAwayDuration(long lastPresentTime) {
        return System.currentTimeMillis() - lastPresentTime;
    }
}