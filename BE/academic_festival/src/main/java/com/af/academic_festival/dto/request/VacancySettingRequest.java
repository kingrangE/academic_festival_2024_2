package com.af.academic_festival.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class VacancySettingRequest {
    @NotNull(message = "사용자 ID는 필수입니다")
    private String userId;

    @NotNull(message = "자리비움 시간은 필수입니다")
    @Min(value = 1, message = "최소 1분 이상 설정해야 합니다")
    @Max(value = 120, message = "최대 120분까지 설정 가능합니다")
    private Integer minutes;
}