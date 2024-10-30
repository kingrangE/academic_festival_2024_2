package com.af.academic_festival.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@Builder
public class Seat {
    private String seatId;
    private String seatType;          // SINGLE, GROUP
    private Integer floor;            // 층 정보
    private String status;            // AVAILABLE, OCCUPIED, VACANT
    private String currentUserId;     // 현재 사용자 ID
    private LocalDateTime lastConnectedTime;  // 마지막 WiFi 연결 시간
    private Boolean isVacant;         // 자리비움 상태

    // 좌석 상태 enum
    public enum Status {
        AVAILABLE("사용 가능"),
        OCCUPIED("사용 중"),
        VACANT("자리비움");

        private final String description;

        Status(String description) {
            this.description = description;
        }

        public String getDescription() {
            return description;
        }
    }

    // 좌석 배정
    public void occupy(String userId) {
        this.currentUserId = userId;
        this.status = Status.OCCUPIED.name();
        this.lastConnectedTime = LocalDateTime.now();
        this.isVacant = false;
    }

    // 좌석 반환
    public void release() {
        this.currentUserId = null;
        this.status = Status.AVAILABLE.name();
        this.lastConnectedTime = null;
        this.isVacant = false;
    }

    public void updateLocationStatus(boolean isPresent) {
        if (isPresent) {
            this.lastConnectedTime = LocalDateTime.now();
        }
    }

    // 자리비움 설정
    public void setVacant(boolean vacant) {
        this.isVacant = vacant;
        this.status = vacant ? Status.VACANT.name() : Status.OCCUPIED.name();
    }
}