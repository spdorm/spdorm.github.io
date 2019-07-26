package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "room_profile")

public class RoomProfile {

    //รหัสห้องพัก
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int roomId;

    //รหัสหอพัก
    @Column(name = "dorm_id")
    private int dormId;

    //รหัสผู้ใช้
    @Column(name = "user_id")
    private int userId;

    //รหัสผู้ใช้ (ลูกค้า)
    @Column(name = "customer_id")
    private int customerId;

    //เลขห้อง
    @Column(name = "room_no")
    private String roomNo;

    //ห้องอยู่ชั้นไหน
    @Column(name = "room_floor")
    private String roomFloor;

    //ราคาห้อง
    @Column(name = "room_price")
    private String roomPrice;

    //ประเภทห้องพัก (แอร์/พัดลม/อื่นๆ)
    @Column(name = "room_type")
    private String roomType;

    //สัญญาเช่า (ไฟล์รูปภาพ)
    @Column(name = "room_document")
    private String roomDocument;

    //สถานะการเข้าพัก (ว่าง/ไม่ว่าง) --จัดการได้เฉพาะเจ้าของหอ
    @Column(name = "room_status")
    private String roomStatus;

    //วันที่เข้าพัก
    @Column(name = "create_date")
    private Date dateTime = new Date();

}