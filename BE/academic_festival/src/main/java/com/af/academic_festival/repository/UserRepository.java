package com.af.academic_festival.repository;

import com.af.academic_festival.model.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.Optional;
import java.util.List;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class UserRepository {
    private final InMemoryDatabase database;

    public Optional<User> findById(String userId) {
        return Optional.ofNullable(database.getUsers().get(userId));
    }

    public Optional<User> findByStudentId(String studentId) {
        return database.getUsers().values().stream()
                .filter(user -> user.getStudentId().equals(studentId))
                .findFirst();
    }

    public User save(User user) {
        database.getUsers().put(user.getUserId(), user);
        return user;
    }

    public void delete(String userId) {
        database.getUsers().remove(userId);
    }

    public List<User> findAll() {
        return new ArrayList<>(database.getUsers().values());
    }
}