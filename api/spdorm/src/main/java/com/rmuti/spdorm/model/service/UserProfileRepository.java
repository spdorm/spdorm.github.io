package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface UserProfileRepository extends JpaRepository<UserProfile, Integer> {

    // Check Username and Password in database (Login)
    UserProfile findByUserUsernameAndUserPassword(String userUsername, String userPassword);

    // Check Username for Register
    UserProfile findByUserUsername(String userUsername);

    // Check Username and UserId for list
    UserProfile findByUserId(int userId);

    @Query(value = "select * from user_profile a where a.user_type = ?1", nativeQuery = true)
    List<UserProfile> findByType(String userType);

    @Query(value = "SELECT a.user_id,a.user_firstname, a.user_lastname FROM user_profile a INNER JOIN history b ON a.user_id = b.user_id WHERE a.user_type = 'customer' AND b.dorm_id = ?1 AND b.history_status != 'ยกเลิก'", nativeQuery = true)
    List<Object[]> findByDormId(int dormId);

    @Modifying
    @Transactional
    @Query(value = "update user_profile a set a.user_firstname = ?2, a.user_lastname = ?3, a.user_address = ?4, a.user_telephone = ?5, a.user_email = ?6 where a.user_Id = ?1", nativeQuery = true)
    void updateProfile(int userId, String userFirstname, String userLastname, String userAddress, String userTelephone, String userEmail);
}