package com.rmuti.spdorm.model.table;

import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;

@ToString
@Data
@Entity
@Table(name = "history")

public class History {
    //รหัสรายการ
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int historyId;

    //รหัสบัญชีผู้ใช้ (user_id)
    @Column(name = "user_id")
    private int userId;

    //รหัสหอพัก (dorm_id)
    @Column(name = "dorm_id")
    private int dormId;

    //รหัสห้องพัก (room_id)
    @Column(name = "room_id")
    private int roomId;

    //วันที่ที่เข้าพัก (time_in)
    @Column(name = "time_in")
    private Date dateTimeIn;

    //วันที่ออกจากหอพัก (time_out)
    @Column(name = "time_out")
    private Date dateTimeOut;

    //สถานะการพักอาศัย (active = กำลังอยู่อาศัย, inactive = ไม่ได้อยู่อาศัย)
    @Column(name = "history_status")
    private String historyStatus;

}
