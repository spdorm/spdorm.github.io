package com.rmuti.spdorm.model.table;


import lombok.Data;
import lombok.ToString;

import javax.persistence.*;

@ToString
@Data
@Entity
@Table(name = "fix_image")

public class FixImage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int fixImageId;

    @Column(name = "fix_id")
    private int fixId;

    @Column(name = "image_name")
    private String imageName;
}
