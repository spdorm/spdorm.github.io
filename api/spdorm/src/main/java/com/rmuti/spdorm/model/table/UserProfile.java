package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;
import javax.persistence.*;
@ToString
@Data
@Entity
@Table(name = "user_profile")

public class UserProfile {

    //รหัสผู้ใช้
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userId;

    //ชื่อผู้ใช้
    @Column(name = "user_username")
    private String userUsername;

    //รหัสผ่าน
    @Column(name = "user_password")
    private String userPassword;

    //ชื่อ
    @Column(name = "user_firstname")
    private String userFirstname;

    //นามสกุล
    @Column(name = "user_lastname")
    private String userLastname;

    //ที่อยู่
    @Column(name = "user_address")
    private String userAddress;

    //เบอร์โทรศัพท์
    @Column(name = "user_telephone")
    private String userTelephone;

    //อีเมล
    @Column(name = "user_email")
    private String userEmail;

    //สถานะผู้ใช้(ใช้งานอยู่/ไม่ใช้งานแล้ว)
    @Column(name = "user_status")
    private String userStatus;

    //ประเภทผู้ใช้(เจ้าของหอ/ลูกค้า)
    @Column(name = "user_type")
    private String userType;

}