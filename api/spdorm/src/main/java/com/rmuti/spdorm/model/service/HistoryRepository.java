package com.rmuti.spdorm.model.service;

import java.util.Date;
import java.util.List;

import com.rmuti.spdorm.model.table.History;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface HistoryRepository extends JpaRepository<History, Integer> {
    History findByHistoryId(int historyId);

    @Query(value = "select * from history a where a.dorm_id = ?1 and a.user_id = ?2 and a.history_status = ?3", nativeQuery = true)
    History findByDormIdAndUserId(int dormId, int userId, String status);

    @Query(value = "select a.*,b.user_username,b.user_firstname,b.user_lastname from history a left join user_profile b on a.user_id = b.user_id where a.dorm_id = ?1 and a.history_status = ?2", nativeQuery = true)
    List<Object[]> listByDormId(int dormId,String status);

    @Transactional
    @Modifying
    @Query(value = "update history a set a.room_id = ?2, a.time_in = ?3 , a.history_status = ?4 where a.history_id = ?1", nativeQuery = true)
    void updateHistory(int historyId,int roomId, Date timeIn, String status);

    @Transactional
    @Modifying
    @Query(value = "update history a set a.time_out = ?2, a.history_status = ?3 where a.history_id = ?1",nativeQuery = true)
    void cancel(int historyId,Date timeOut, String status);


}
