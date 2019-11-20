package com.rmuti.spdorm.model.service;

import java.util.List;

import javax.transaction.Transactional;

import com.rmuti.spdorm.model.table.DormProfile;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface DormProfileRepository extends JpaRepository<DormProfile, Integer> {

    DormProfile findByDormId(int dormId);

    // Check DormAddress for Add
    DormProfile findByDormAddress(String dormAddress);

    // Check DormId, UserId And DormName for list
    //DormProfile findByDormIdAndUserId(int dormId, int userId);

//    @Query(value = "update dorm_profile a set a.dorm_floor = ?3 where a.dormId = ?1 and a.dorm_floor = ?2",nativeQuery = true)
//    int updateFloor(int dormId, int userId, String dormFloor);

//    @Query(value = "select * from dorm_profile a where a.dormId = :stetus and a.name = :name",nativeQuery = true)
//    DormProfile findInfo(@Param("stetus") int stetus , @Param("name") String name);

    @Query(value = "select * from dorm_profile a where a.user_id = ?1 order by a.dorm_id asc",nativeQuery = true)
    List<Object[]> findInfo(int userId);

    // Frank created 05-06-2562
    // For: List all dorm.
    @Query(value = "select * from dorm_profile a where a.dorm_status = 'active' order by a.dorm_id asc",nativeQuery = true)
    List<Object[]> listall();

    @Query(value = "select a.dorm_image from dorm_profile a where a.dorm_Id = ?1",nativeQuery = true)
    String findImageByDormId(int dormId);

    @Transactional
    @Modifying
    @Query(value = "update dorm_profile a set a.dorm_name = ?2, a.dorm_address = ?3, a.dorm_telephone = ?4, a.dorm_email = ?5, a.dorm_floor = ?6, a.dorm_price = ?7, a.dorm_promotion = ?8, a.dorm_detail = ?9, a.dorm_status = ?10 where a.dorm_id = ?1",nativeQuery = true)
    void updateDormProfile(int dormId,String dormName,String dormAddress,String dormTelephone,String dormEmail,String dormFloor,String dormPrice,String dormPromotion,String dormDetail,String dormStatus);
    //int dormId,String dormName,String dormAddress,String dormTelephone,String dormEmail,String dormPrice,String dormPromotion,String dormDetail

    @Transactional
    @Modifying
    @Query(value = "update dorm_profile a set a.dorm_image = ?2 where a.dorm_id = ?1",nativeQuery = true)
    void updateDormImage(int dormId,String dormImage);

}
