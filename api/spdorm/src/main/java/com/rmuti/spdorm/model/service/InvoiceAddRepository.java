package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.InvoiceAdd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

import javax.transaction.Transactional;

public interface InvoiceAddRepository extends JpaRepository<InvoiceAdd, Integer> {

    // Check InvoiceId for Add
    InvoiceAdd findByInvoiceId(int invoiceId);

    InvoiceAdd findByRoomId(int roomId);

    // Check InvoiceId, DormId and RoomId for list
    @Query(value = "SELECT a.*,b.room_no,c.user_firstname,c.user_lastname FROM invoice_add a LEFT JOIN  room_profile b ON b.room_id = a.room_id LEFT JOIN user_profile c ON c.user_id = b.customer_id WHERE a.room_id = ?3 and a.dorm_id = ?1 and b.customer_id = ?2 ORDER BY a.invoice_id  DESC LIMIT 0,6", nativeQuery = true)
    List<Object[]> findByDormIdAndUserIdAndRoomId(int dormId,int userId, int roomId);

    @Modifying
    @Transactional
    @Query(value = "update invoice_add a set a.invoice_status = ?2 where a.invoice_id = ?1",nativeQuery = true)
    void updateInvoice(int invoiceId,String status);
}
