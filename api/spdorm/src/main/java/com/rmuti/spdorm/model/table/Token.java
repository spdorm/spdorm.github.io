package com.rmuti.spdorm.model.table;

import lombok.Data;
import lombok.ToString;

import javax.persistence.*;

@ToString
@Data
@Entity
@Table(name = "Token")

public class Token {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int userId;

    @Column(name = "user_username")
    private String userUsername;

    @Column(name = "token")
    private String token;

    @Column(name = "status")
    private String status;

}
