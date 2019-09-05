package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;
import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "machine_profile")

public class MachineProfile {

        //รหัสเครื่องหยอดเหรียญ
        @Id
        @GeneratedValue(strategy = GenerationType.AUTO)
        private int machineId;

        //รหัสหอพัก
        @Column(name = "dorm_id")
        private int dormId;

        //ประเภทเครื่องหยอดเหรียญ
        @Column(name = "machine_type")
        private String machineType;

        //วัน-เดือน-ปี
        @Column(name = "create_date")
        private Date dateTime = new Date();

}
