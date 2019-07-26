package com.rmuti.spdorm.model.service;

import com.rmuti.spdorm.model.table.MachineProfile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface MachineProfileRepository extends JpaRepository<MachineProfile, Integer> {

    MachineProfile findByMachineId(int machineId);

    // Check MachineType for Add
    MachineProfile findByMachineType(String machineType);

    // Check DormId and MachineId for list
    @Query(value = "select * from machine_profile a where a.dorm_id = ?1",nativeQuery = true)
    List<Object[]> findByDormId(int dormId);

    @Modifying
    @Transactional
    @Query(value = "update machine_profile a set a.machine_value=?2 where a.machine_id = ?1",nativeQuery = true)
    void updateValue(int machineId,int machineValue);



}
