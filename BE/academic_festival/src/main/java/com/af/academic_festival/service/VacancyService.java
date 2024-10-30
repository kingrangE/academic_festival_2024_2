package com.af.academic_festival.service;

import com.af.academic_festival.dto.request.VacancySettingRequest;
import com.af.academic_festival.model.Seat;
import com.af.academic_festival.model.User;
import com.af.academic_festival.model.VacancySetting;
import com.af.academic_festival.repository.SeatRepository;
import com.af.academic_festival.repository.UserRepository;
import com.af.academic_festival.repository.VacancyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class VacancyService {
    private final VacancyRepository vacancyRepository;
    private final UserRepository userRepository;
    private final SeatRepository seatRepository;

    public void setVacancy(VacancySettingRequest request) {
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        if (user.getCurrentSeatId() == null) {
            throw new RuntimeException("배정된 좌석이 없습니다.");
        }

        Seat seat = seatRepository.findById(user.getCurrentSeatId())
                .orElseThrow(() -> new RuntimeException("좌석을 찾을 수 없습니다."));

        // 기존 자리비움 설정이 있다면 삭제
        vacancyRepository.deleteByUserId(user.getUserId());

        // 새로운 자리비움 설정 생성
        VacancySetting vacancySetting = VacancySetting.create(
                user.getUserId(),
                request.getMinutes()
        );
        vacancyRepository.save(vacancySetting);

        // 좌석 상태 업데이트
        seat.setVacant(true);
        seatRepository.save(seat);
    }

    public void cancelVacancy(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다."));

        if (user.getCurrentSeatId() != null) {
            Seat seat = seatRepository.findById(user.getCurrentSeatId())
                    .orElseThrow(() -> new RuntimeException("좌석을 찾을 수 없습니다."));
            seat.setVacant(false);
            seatRepository.save(seat);
        }

        vacancyRepository.deleteByUserId(userId);
    }

    public int getRemainingVacancyTime(String userId) {
        return vacancyRepository.findByUserId(userId)
                .map(VacancySetting::getRemainingMinutes)
                .orElse(0);
    }

    @Scheduled(fixedRate = 60000) // 1분마다 실행
    public void checkVacancyExpirations() {
        vacancyRepository.findAll().forEach(vacancy -> {
            if (vacancy.isExpired()) {
                String userId = vacancy.getUserId();
                User user = userRepository.findById(userId).orElse(null);

                if (user != null && user.getCurrentSeatId() != null) {
                    Seat seat = seatRepository.findById(user.getCurrentSeatId()).orElse(null);
                    if (seat != null) {
                        seat.setVacant(false);
                        seatRepository.save(seat);
                    }
                }

                vacancyRepository.delete(vacancy.getId());
            }
        });
    }
}