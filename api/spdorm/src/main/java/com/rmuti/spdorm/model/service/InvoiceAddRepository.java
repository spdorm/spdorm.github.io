package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.InvoiceAdd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface InvoiceAddRepository extends JpaRepository<InvoiceAdd, Integer> {

    // Check InvoiceId for Add
    InvoiceAdd findByInvoiceId(int invoiceId);

    // Check InvoiceId, DormId and RoomId for list
    @Query(value = "SELECT a.*,b.room_no,c.user_firstname,c.user_lastname FROM invoice_add a LEFT JOIN  room_profile b ON b.room_id = a.room_id LEFT JOIN user_profile c ON c.user_id = b.customer_id WHERE a.room_id = ?3 and a.dorm_id = ?1 and b.customer_id = ?2 ORDER BY a.invoice_id  DESC LIMIT 0,6", nativeQuery = true)
    List<Object[]> findByDormIdAndUserIdAndRoomId(int dormId,int userId, int roomId);

}
