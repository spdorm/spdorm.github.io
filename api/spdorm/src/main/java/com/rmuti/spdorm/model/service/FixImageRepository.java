package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.FixImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FixImageRepository extends JpaRepository<FixImage, Integer> {

    List<FixImage> findAllByFixId(int fixId);
}
