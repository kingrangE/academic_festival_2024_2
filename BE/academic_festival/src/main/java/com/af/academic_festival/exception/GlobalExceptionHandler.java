package com.af.academic_festival.exception;

import com.af.academic_festival.dto.response.ApiResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(CustomException.class)
    public ResponseEntity<ApiResponse<Object>> handleCustomException(CustomException e) {
        log.error("CustomException: {}", e.getMessage());
        return ResponseEntity
                .status(e.getErrorCode().getHttpStatus())
                .body(new ApiResponse<>(false, e.getMessage(), null));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<Object>> handleValidationException(MethodArgumentNotValidException e) {
        BindingResult bindingResult = e.getBindingResult();
        List<String> errors = bindingResult.getFieldErrors()
                .stream()
                .map(this::getValidationErrorMessage)
                .collect(Collectors.toList());

        String errorMessage = String.join(", ", errors);
        log.error("Validation Error: {}", errorMessage);

        return ResponseEntity
                .badRequest()
                .body(new ApiResponse<>(false, errorMessage, null));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Object>> handleException(Exception e) {
        log.error("Unhandled Exception:", e);
        return ResponseEntity
                .internalServerError()
                .body(new ApiResponse<>(false, "서버 내부 오류가 발생했습니다.", null));
    }

    private String getValidationErrorMessage(FieldError error) {
        return error.getField() + ": " + error.getDefaultMessage();
    }
}