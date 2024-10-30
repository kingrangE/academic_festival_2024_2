package com.af.academic_festival.repository;

import com.af.academic_festival.model.Seat;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class SeatRepository {
    private final InMemoryDatabase database;

    public Optional<Seat> findById(String seatId) {
        return Optional.ofNullable(database.getSeats().get(seatId));
    }

    public Seat save(Seat seat) {
        database.getSeats().put(seat.getSeatId(), seat);
        return seat;
    }

    public List<Seat> findAll() {
        return new ArrayList<>(database.getSeats().values());
    }

    public List<Seat> findByFloor(Integer floor) {
        return database.getSeats().values().stream()
                .filter(seat -> seat.getFloor().equals(floor))
                .collect(Collectors.toList());
    }

    public Optional<Seat> findByCurrentUserId(String userId) {
        return database.getSeats().values().stream()
                .filter(seat -> userId.equals(seat.getCurrentUserId()))
                .findFirst();
    }

    public List<Seat> findAvailableSeats(Integer floor, String seatType) {
        return database.getSeats().values().stream()
                .filter(seat -> seat.getStatus().equals(Seat.Status.AVAILABLE.name()))
                .filter(seat -> floor == null || seat.getFloor().equals(floor))
                .filter(seat -> seatType == null || seat.getSeatType().equals(seatType))
                .collect(Collectors.toList());
    }
}