package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "income_add")

public class IncomeAdd {

    //รหัสรายได้
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int incomeId;

    //รหัสหอพัก
    @Column(name = "dorm_id")
    private int dormId;

    //รหัสผู้ใช้ (เจ้าของหอ)
    @Column(name = "user_id")
    private int userId;

    //วัน-เดือน-ปี
    @Column(name = "create_date")
    private Date dateTime = new Date();


    //รายได้จากค่าเช่า
    @Column(name = "income_rent")
    private String incomeRent;

    //รายจ่าย
    @Column(name = "expend")
    private String expend;

    //กำไร
    @Column(name = "profit")
    private String profit;

}
