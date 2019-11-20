package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {
    List<Payment> findByDormIdAndUserId(int dormId, int userId);

    @Query(value = "SELECT SUM(payment_amount) FROM payment WHERE dorm_id = ?1 AND user_id = ?2", nativeQuery = true)
    Object sumAmount(int dormId, int userId);
}
