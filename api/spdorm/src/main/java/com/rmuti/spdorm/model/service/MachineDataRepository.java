package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.MachineData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;


public interface MachineDataRepository extends JpaRepository<MachineData,Integer> {
    MachineData findByMachineId(int machineId);

    @Modifying
    @Transactional
    @Query(value = "delete from machine_data a where a.machine_Id = ?1",nativeQuery = true)
    void deleteByMachineId(int machineId);

    @Query(value = "select * from machine_data a,machine_profile b where a.machine_Id = b.machine_Id and b.dorm_id = ?1",nativeQuery = true)
    List<MachineData> listByDormId(int dormId);
}
