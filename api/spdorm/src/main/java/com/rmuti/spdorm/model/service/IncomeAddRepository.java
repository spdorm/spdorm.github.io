package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.IncomeAdd;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface IncomeAddRepository extends JpaRepository<IncomeAdd, Integer> {

    // Check IncomeId for Add
    IncomeAdd findByIncomeId(int incomeId);

    // Check IncomeId and DormId for list
    IncomeAdd findByIncomeIdAndDormId(int incomeId, int dormId);

    @Query(value = "select * from income_add a where a.dorm_id = ?1",nativeQuery = true)
    List<IncomeAdd> listByDormId(int dormId);
}
