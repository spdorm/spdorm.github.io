package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface UserProfileRepository extends JpaRepository<UserProfile, Integer> {

    // Check Username and Password in database (Login)
    UserProfile findByUserUsernameAndUserPassword(String userUsername, String userPassword);

    // Check Username for Register
    UserProfile findByUserUsername(String userUsername);

    // Check Username and UserId for list
    UserProfile findByUserId(int userId);

    @Modifying
    @Transactional
    @Query(value = "update user_profile a set a.user_firstname = ?2, a.user_lastname = ?3, a.user_address = ?4, a.user_telephone = ?5, a.user_email = ?6 where a.user_Id = ?1", nativeQuery = true)
    void updateProfile(int userId,String userFirstname,String userLastname,String userAddress,String userTelephone,String userEmail);
}