package com.af.academic_festival.dto.response;

import lombok.Builder;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
@Builder
public class SeatResponse {
    private String seatId;
    private String seatType;
    private Integer floor;
    private String status;
    private String currentUserId;
    private LocalDateTime lastConnectedTime;
    private Boolean isVacant;
}