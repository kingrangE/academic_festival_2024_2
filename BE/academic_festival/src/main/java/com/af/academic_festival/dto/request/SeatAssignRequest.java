package com.af.academic_festival.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class SeatAssignRequest {
    @NotNull(message = "사용자 ID는 필수입니다")
    private String userId;

    @NotNull(message = "좌석 유형은 필수입니다")
    private String seatType;  // "SINGLE", "GROUP"

    @NotNull(message = "층 정보는 필수입니다")
    private Integer floor;
}