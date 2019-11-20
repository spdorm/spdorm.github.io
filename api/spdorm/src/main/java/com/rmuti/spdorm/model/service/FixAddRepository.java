package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.FixAdd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface FixAddRepository extends JpaRepository<FixAdd, Integer> {

    //Check FixId for Add
    FixAdd findByFixId(int fixId);

    FixAdd findByFixIdOrderByFixIdDesc(int fixId);

    FixAdd findByDormId(int dormId);

    // Check FixId, DormId RoomId and RoomNo for list
    @Query(value = "select * from fix_add a where a.dorm_id = ?1 order by a.fix_id DESC", nativeQuery = true)
    List<FixAdd> listByDormId(int dormId);

    @Query(value = "select * from fix_add a where a.dorm_id = ?1 and a.room_id = ?2 order by a.fix_id DESC", nativeQuery = true)
    List<FixAdd> listByDormIdAndRoomId(int dormId, int roomId);

    @Modifying
    @Transactional
    @Query(value = "update fix_add a set a.fix_status = ?2, a.end_date = ?3 where a.fix_id = ?1", nativeQuery = true)
    void updateStatus(int fixId, String status, String endDate);

    @Modifying
    @Transactional
    @Query(value = "update fix_add a set a.fix_note = ?2, a.fix_price = ?3 where a.fix_id = ?1", nativeQuery = true)
    void updateFixNoteAndFixPrice(int fixId, String fixNote, int fixPrice);

}
