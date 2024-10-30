package com.af.academic_festival.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class WifiStatusRequest {
    @NotNull(message = "사용자 ID는 필수입니다")
    private String userId;

    @NotNull(message = "WiFi 연결 상태는 필수입니다")
    private Boolean isConnected;
}