package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.RoomProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface RoomProfileRepository extends JpaRepository<RoomProfile, Integer> {

    @Query(value = "select count(a.room_status) from room_profile a where a.dorm_id = ?1 and a.room_status = 'ว่าง'",nativeQuery = true)
    int countByDormId(int dormId);

    @Query(value = "select a.room_id from room_profile a where a.dorm_id = ?1 and a.user_id = ?2",nativeQuery = true)
    int findByDormIdAndUserId(int dormId,int userId);

    // Check RoomId for Add
    RoomProfile findByRoomId(int roomId);

    RoomProfile findByCustomerId(int customerId);

//    @Query(value = "select * from room_profile a where a.dorm_id = ?1 and a.user_id = ?2",nativeQuery = true)
//    RoomProfile findFloorByDormIdAndUserId(int dormId, int userId);

    // Check RoomId,DormId,UserId and RoomNo for list
    @Query(value = "select * from room_profile a where a.dorm_id = ?1 and a.room_floor = ?2",nativeQuery = true)
    List<Object[]> listByDormIdAndFloor(int dormId, int roomFloor);

    RoomProfile findRoomByDormIdAndRoomId(int dormId, int roomId);

    RoomProfile findRoomByDormIdAndRoomNo(int dormId, String roomNo);

    @Query(value = "select a.room_no,b.user_username from room_profile a,user_profile b where a.dorm_id = ?1 and a.user_id = ?2 and a.room_no = ?3 and b.user_username = ?4",nativeQuery = true)
    List<Object[]> findRoomByDormIdAndUserIdAndRoomNo(int dormId, int userId, String roomNo, String userUsername);

    @Modifying
    @Transactional
    @Query(value = "update room_profile a set a.room_status = ?1, a.room_type = ?2, a.room_floor = ?3, a.room_no = ?4, a.room_price = ?5, a.room_document = ?6 where a.room_id = ?7 and a.room_no = ?4",nativeQuery = true)
    void updateRoom(String status,String type,String floor,String no,String price,String doc,int roomId);

    @Modifying
    @Transactional
    @Query(value = "update room_profile a set a.customer_id = ?2, a.room_status = ?3 where a.room_id = ?1",nativeQuery = true)
    void updateCustomerToRoom(int roomId,int customerId,String status);

    @Modifying
    @Transactional
    @Query(value = "update room_profile a set a.room_document = ?2 where a.room_id = ?1",nativeQuery = true)
    void updateImageToRoom(int roomId,String nameImage);
}
