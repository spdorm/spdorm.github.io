package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.MachineDataRepository;
import com.rmuti.spdorm.model.table.MachineData;
import lombok.Data;
import lombok.ToString;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.persistence.Table;

@RestController
@RequestMapping("/machineData")
public class MachineDataController {
    @Autowired
    private MachineDataRepository machineDataRepository;

    @PostMapping("/add")
    public Object add(MachineData machineData){
        APIResponse res = new APIResponse();
        machineDataRepository.save(machineData);
        res.setStatus(0);
        res.setMessage("เพิ่มรายรับเครื่องหยอดเหรียญแล้ว");
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int machineId){
        APIResponse res = new APIResponse();
        res.setStatus(0);
        res.setData(machineDataRepository.findByMachineId(machineId));
        return res;
    }
}
