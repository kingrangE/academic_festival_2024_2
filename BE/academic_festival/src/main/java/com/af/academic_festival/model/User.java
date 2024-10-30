package com.af.academic_festival.model;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class User {
    private String userId;
    private String studentId;
    private String password;
    private String name;
    private Integer checkOutCount;    // 체크아웃 누락 횟수
    private String currentSeatId;     // 현재 배정된 좌석 ID

    // 체크아웃 누락 카운트 증가
    public void incrementCheckOutCount() {
        this.checkOutCount = (this.checkOutCount == null) ? 1 : this.checkOutCount + 1;
    }

    // 좌석 배정
    public void assignSeat(String seatId) {
        this.currentSeatId = seatId;
    }

    // 좌석 반환
    public void releaseSeat() {
        this.currentSeatId = null;
    }
}