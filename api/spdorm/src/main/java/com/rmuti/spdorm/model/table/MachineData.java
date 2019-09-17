package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;

import javax.persistence.*;
import java.util.Date;

@ToString
@Entity
@Data
@Table(name = "machine_data")

public class MachineData {

    //รหัสข้อมูล
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    //รหัสเครื่องหยอดเหรียญ
    @Column(name = "machine_Id")
    private int machineId;

    //ข้อมูล
    @Column(name = "data")
    private int data;

    //วันเดือนปี
    @Column(name = "create_date")
    private Date dateTime = new Date();

}
