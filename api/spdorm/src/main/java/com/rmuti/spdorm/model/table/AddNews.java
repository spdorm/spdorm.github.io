package com.rmuti.spdorm.model.table;
import lombok.Data;
import lombok.ToString;
import javax.persistence.*;
import java.util.Date;
@ToString
@Data
@Entity
@Table(name = "add_news")

public class AddNews {

    //รหัสข่าวสาร
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int newsId;

    //รหัสผู้ใช้ (เจ้าของหอ)
    @Column(name = "user_id")
    private int userId;

    //รหัสหอพัก
    @Column(name = "dorm_id")
    private int dormId;

    //หัวข้อข่าว
    @Column(name = "news_topic")
    private String newsTopic;

    //รายละเอียดข่าว
    @Column(name = "news_detail")
    private String newsDetail;

    //สถานะข่าว (แสดง/ซ่อน)
    @Column(name = "news_status")
    private String newsStatus;

    //วันที่เพิ่มข่าวสาร
    @Column(name = "create_date")
    private Date dateTime = new Date();

}
