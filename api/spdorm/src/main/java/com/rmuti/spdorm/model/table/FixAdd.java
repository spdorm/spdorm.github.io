package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "fix_add")

public class FixAdd {

    //รหัสแจ้งซ่อม
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int fixId;

    //รหัสหอพัก
    @Column(name = "dorm_id")
    private int dormId;

    //รหัสห้องพัก
    @Column(name = "room_id")
    private int roomId;

    //รหัสผู้ใช้
    @Column(name = "user_id")
    private int userId;

    //เลขห้อง
    @Column(name = "room_no")
    private String roomNo;

    //หัวข้อการแจ้งซ่อม
    @Column(name = "fix_topic")
    private String fixTopic;

    //รายละเอียดการแจ้งซ่อม
    @Column(name = "fix_detail")
    private String fixDetail;

    @Column(name = "fix_price")
    private int fixPrice;

    //สถานะการแจ้งซ่อม (ซ่อมแล้ว/ยังไม่ซ่อม) --จัดการได้เฉพาะเจ้าของหอ
    @Column(name = "fix_status")
    private String fixStatus;

    @Column(name = "fix_note")
    private String fixNote;

    //วันที่เพิ่มการแจ้งซ่อม
    @Column(name = "create_date")
    private Date dateTime = new Date();

    //วันที่ซ่อมสำเร็จ
    @Column(name = "end_date")
    private Date endDateTime = new Date();

}
