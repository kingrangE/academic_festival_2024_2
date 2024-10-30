package com.af.academic_festival.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UserLoginRequest {
    @NotBlank(message = "학번은 필수입니다")
    private String studentId;

    @NotBlank(message = "비밀번호는 필수입니다")
    private String password;
}