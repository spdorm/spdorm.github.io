package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "invoice_add")

public class InvoiceAdd {

    //รหัสใบแจ้งชำระ
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int invoiceId;

    //รหัสหอพัก
    @Column(name = "dorm_id")
    private int dormId;

    //รหัสห้องพัก
    @Column(name = "room_id")
    private int roomId;

    //วัน-เดือน-ปี
    @Column(name = "create_date")
    private Date dateTime = new Date();

    //เดือน
    @Column(name = "invoice_month")
    private String invoiceMonth;

    //ปี
    @Column(name = "invoice_year")
    private String invoiceYear;

    //ค่าเช่าห้องพัก
    @Column(name = "room_price")
    private String roomPrice;

    //ค่าน้ำ
    @Column(name = "price_water")
    private String priceWater;

    //ค่าไฟ
    @Column(name = "price_electricity")
    private String priceElectricity;

    //ค่าซ่อมบำรุง
    @Column(name = "price_fix")
    private String priceFix;

    //ค่าอื่น ๆ
    @Column(name = "price_other")
    private String priceOther;

    //รวมเป็นเงินทั้งหมด
    @Column(name = "price_total")
    private String priceTotal;

    //หมายเหตุ
    @Column(name = "price_note")
    private String priceNote;

    //สถานะการชำระเงิน (ยังไม่จ่าย/จ่ายแล้ว) --จัดการได้เฉพาะเจ้าของหอ
    @Column(name = "invoice_status")
    private String invoiceStatus;

}
