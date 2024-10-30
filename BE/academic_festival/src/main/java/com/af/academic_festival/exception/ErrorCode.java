package com.af.academic_festival.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
public enum ErrorCode {
    // 사용자 관련 오류
    USER_NOT_FOUND(HttpStatus.NOT_FOUND, "사용자를 찾을 수 없습니다."),
    INVALID_PASSWORD(HttpStatus.UNAUTHORIZED, "비밀번호가 일치하지 않습니다."),
    DUPLICATE_USER(HttpStatus.CONFLICT, "이미 존재하는 사용자입니다."),

    // 좌석 관련 오류
    SEAT_NOT_FOUND(HttpStatus.NOT_FOUND, "좌석을 찾을 수 없습니다."),
    SEAT_ALREADY_OCCUPIED(HttpStatus.CONFLICT, "이미 사용 중인 좌석입니다."),
    NO_AVAILABLE_SEATS(HttpStatus.NOT_FOUND, "사용 가능한 좌석이 없습니다."),
    USER_ALREADY_HAS_SEAT(HttpStatus.CONFLICT, "이미 배정된 좌석이 있습니다."),

    // 자리비움 관련 오류
    VACANCY_NOT_FOUND(HttpStatus.NOT_FOUND, "자리비움 설정을 찾을 수 없습니다."),
    INVALID_VACANCY_DURATION(HttpStatus.BAD_REQUEST, "잘못된 자리비움 시간입니다."),
    VACANCY_ALREADY_EXISTS(HttpStatus.CONFLICT, "이미 자리비움이 설정되어 있습니다."),

    // WiFi 관련 오류
    WIFI_CONNECTION_ERROR(HttpStatus.BAD_REQUEST, "WiFi 연결 상태 업데이트에 실패했습니다."),

    // 서버 오류
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "서버 내부 오류가 발생했습니다.");

    private final HttpStatus httpStatus;
    private final String message;

    ErrorCode(HttpStatus httpStatus, String message) {
        this.httpStatus = httpStatus;
        this.message = message;
    }
}