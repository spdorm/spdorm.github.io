package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface ImageRepository extends JpaRepository<Image,Integer> {
    Image findByDormId(int dormId);
    List<Image> findAllByDormId(int dormId);

    @Transactional
    @Modifying
    @Query(value = "update image a set a.image_name = ?2 where a.image_id = ?1",nativeQuery = true)
    void updateDormImageDetail(int imageId,String dormImage);

    @Transactional
    @Modifying
    @Query(value = "DELETE FROM image WHERE dorm_id = ?1",nativeQuery = true)
    void deleteByDormId(int dormId);
}
