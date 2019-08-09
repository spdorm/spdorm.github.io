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
import java.util.List;

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

//    @PostMapping("/list")
//    public Object list(@RequestParam int machineId){
//        APIResponse res = new APIResponse();
//        res.setStatus(0);
//        res.setData(machineDataRepository.findByMachineId(machineId));
//        return res;
//    }

    @PostMapping("/listAll")
    public Object list(@RequestParam int dormId){
        APIResponse res = new APIResponse();
        List machineData_db = machineDataRepository.listByDormId(dormId);
        if(!machineData_db.isEmpty()){
            res.setStatus(0);
            res.setData(machineData_db);
            res.setMessage("พบข้อมูล");
        }else{
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูล");
        }
        return res;
    }
}
