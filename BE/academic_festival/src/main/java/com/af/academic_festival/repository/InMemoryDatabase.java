package com.af.academic_festival.repository;

import lombok.Getter;
import org.springframework.stereotype.Component;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import com.af.academic_festival.model.User;
import com.af.academic_festival.model.Seat;
import com.af.academic_festival.model.VacancySetting;

@Getter
@Component
public class InMemoryDatabase {
    // Getter methods
    private final Map<String, User> users = new ConcurrentHashMap<>();
    private final Map<String, Seat> seats = new ConcurrentHashMap<>();
    private final Map<String, VacancySetting> vacancySettings = new ConcurrentHashMap<>();

    // 초기 데이터 설정 (테스트용)
    public void initializeTestData() {
        // 좌석 초기화 (각 층별 10개씩)
        for (int floor = 1; floor <= 2; floor++) {
            for (int i = 1; i <= 10; i++) {
                String seatId = String.format("%d-%03d", floor, i);
                seats.put(seatId, Seat.builder()
                        .seatId(seatId)
                        .seatType(i <= 5 ? "SINGLE" : "GROUP")
                        .floor(floor)
                        .status(Seat.Status.AVAILABLE.name())
                        .isVacant(false)
                        .build());
            }
        }

        // 테스트용 사용자
        users.put("test1", User.builder()
                .userId("test1")
                .studentId("20240001")
                .password("password")
                .name("테스트유저1")
                .checkOutCount(0)
                .build());
    }

}