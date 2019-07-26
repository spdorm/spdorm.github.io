package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.MachineData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.web.bind.annotation.RestController;

import javax.transaction.Transactional;


public interface MachineDataRepository extends JpaRepository<MachineData,Integer> {
    MachineData findByMachineId(int machineId);

    @Modifying
    @Transactional
    @Query(value = "delete from machine_data a where a.machine_Id = ?1",nativeQuery = true)
    void deleteByMachineId(int machineId);
}
