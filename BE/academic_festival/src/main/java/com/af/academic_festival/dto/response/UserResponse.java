package com.af.academic_festival.dto.response;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserResponse {
    private String userId;
    private String studentId;
    private String name;
    private Integer checkOutCount;
    private String currentSeatId;
}