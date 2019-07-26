package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
@ToString
@Data
@Entity
@Table(name = "dorm_profile")

public class DormProfile {

    //รหัสหอพัก
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int dormId;

    //รหัสผู้ใช้ (เจ้าของหอพัก)
    @Column(name = "user_id")
    private int userId;

    //ชื่อหอพัก
    @Column(name = "dorm_name")
    private String dormName;

    //ที่อยู่
    @Column(name = "dorm_address")
    private String dormAddress;

    //เบอร์โทรศัพท์
    @Column(name = "dorm_telephone")
    private String dormTelephone;

    //อีเมล
    @Column(name = "dorm_email")
    private String dormEmail;

    //รูปภาพ
    @Column(name = "dorm_image")
    private String dormImage;

    //จำนวนชั้น
    @Column(name = "dorm_floor")
    private String dormFloor;

    //จำนวนห้อง
    @Column(name = "dorm_room")
    private String dormRoom;

    //สถานะของหอพัก (ยังเปิดอยู่/ปิดตัวแล้ว) --จัดการได้เฉพาะแอดมิน
    @Column(name = "dorm_status")
    private String dormStatus;

    //ราคาเช่าพัก
    @Column(name = "dorm_price")
    private String dormPrice;

    //โปรโมชันหอพัก
    @Column(name = "dorm_promotion")
    private String dormPromotion;

    //รายละเอียดหอพัก
    @Column(name = "dorm_detail")
    private String dormDetail;

}
