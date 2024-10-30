package com.af.academic_festival.repository;

import com.af.academic_festival.model.VacancySetting;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Optional;
import java.util.List;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class VacancyRepository {
    private final InMemoryDatabase database;

    public Optional<VacancySetting> findById(String id) {
        return Optional.ofNullable(database.getVacancySettings().get(id));
    }

    public Optional<VacancySetting> findByUserId(String userId) {
        return database.getVacancySettings().values().stream()
                .filter(vacancy -> vacancy.getUserId().equals(userId))
                .findFirst();
    }

    public VacancySetting save(VacancySetting vacancySetting) {
        database.getVacancySettings().put(vacancySetting.getId(), vacancySetting);
        return vacancySetting;
    }

    public void delete(String id) {
        database.getVacancySettings().remove(id);
    }

    public List<VacancySetting> findAll() {
        return new ArrayList<>(database.getVacancySettings().values());
    }

    public void deleteByUserId(String userId) {
        database.getVacancySettings().values().removeIf(
                vacancy -> vacancy.getUserId().equals(userId)
        );
    }
}