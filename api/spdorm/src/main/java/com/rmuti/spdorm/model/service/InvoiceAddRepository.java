package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.InvoiceAdd;
import org.springframework.data.jpa.repository.JpaRepository;

public interface InvoiceAddRepository extends JpaRepository<InvoiceAdd, Integer> {

    // Check InvoiceId for Add
    InvoiceAdd findByInvoiceId(int invoiceId);

    // Check InvoiceId, DormId and RoomId for list
    InvoiceAdd findByInvoiceIdAndDormIdAndRoomId(int invoiceId, int dormId, int roomId);

}
