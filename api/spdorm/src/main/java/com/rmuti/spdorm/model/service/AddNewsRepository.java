package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.AddNews;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface AddNewsRepository extends JpaRepository<AddNews, Integer> {

        //Check newsTopic for Add
        AddNews findByNewsTopic(String newsTopic);

        // Check DormId, UserId And NewsId for list
        @Query(value = "select * from add_news a where a.dorm_id = ?1 order by a.news_id DESC",nativeQuery = true)
        List<AddNews> findByDormId(int dormId);
}

