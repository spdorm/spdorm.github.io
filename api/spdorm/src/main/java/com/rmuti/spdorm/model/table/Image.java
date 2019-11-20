package com.rmuti.spdorm.model.table;

import lombok.Data;
import lombok.ToString;

import javax.persistence.*;

@ToString
@Data
@Entity
@Table(name = "Image")

public class Image {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int imageId;

    @Column(name = "dorm_id")
    private int dormId;

    @Column(name = "image_name")
    private String imageName;

}
