package com.rmuti.spdorm.model.table;

import lombok.Data;
import lombok.ToString;
import javax.persistence.*;
import java.util.Date;

@ToString
@Data
@Entity
@Table(name = "Payment")

public class Payment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int paymentId;

    @Column(name = "dorm_id")
    private int dormId;

    @Column(name ="room_id")
    private int roomId;

    @Column(name = "user_id")
    private int userId;

    @Column(name = "payment_amount")
    private String paymentAmount;

    @Column(name = "payment_fine")
    private String paymentFine;

    @Column(name = "payment_balance")
    private String paymentBalance;

    @Column(name = "payment_note")
    private String paymentNote;

    @Column(name = "payment_status")
    private String paymentStatus;

    @Column(name = "create_date")
    private Date dateTime = new Date();

}
