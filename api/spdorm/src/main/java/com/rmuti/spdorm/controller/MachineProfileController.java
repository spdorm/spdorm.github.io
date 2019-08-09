package com.rmuti.spdorm.controller;

import com.rmuti.spdorm.model.bean.APIResponse;
import com.rmuti.spdorm.model.service.MachineDataRepository;
import com.rmuti.spdorm.model.service.MachineProfileRepository;
import com.rmuti.spdorm.model.table.MachineData;
import com.rmuti.spdorm.model.table.MachineProfile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/machine")

public class MachineProfileController {

    @Autowired
    private MachineProfileRepository machineProfileRepository;

    @Autowired
    private MachineDataRepository machineDataRepository;

    @PostMapping("/add")
    public Object add(MachineProfile machineProfile) {
        APIResponse res = new APIResponse();
        MachineProfile machineProfileDb = machineProfileRepository.findByMachineType(machineProfile.getMachineType());
        if (machineProfileDb == null) {
            res.setStatus(0);
            res.setMessage("บันทึกข้อมูลเรียบร้อยแล้ว");
            res.setData(machineProfile.getMachineId());
            machineProfileRepository.save(machineProfile);
        } else {
            res.setStatus(1);
            res.setMessage("มีข้อมูลอยู่แล้ว");
        }
        return res;
    }

    @PostMapping("/list")
    public Object list(@RequestParam int dormId) {
        APIResponse res = new APIResponse();
        List machineProfile_db = machineProfileRepository.findByDormId(dormId);
        if(machineProfile_db.isEmpty()){
            res.setStatus(1);
            res.setMessage("ไม่พบข้อมูลเครื่องหยอดเหรียญ");
        }else{
            res.setStatus(0);
            res.setMessage("พบข้อมูลเครื่องหยอดเหรียญ");
            res.setData(machineProfileRepository.findByDormId(dormId));
        }
        return res;
    }


    @PostMapping("/delete")
    public Object delete(MachineProfile machineProfile) {
        APIResponse res = new APIResponse();
        MachineProfile machineProfile1_db = machineProfileRepository.findByMachineId(machineProfile.getMachineId());
        if (machineProfile1_db != null) {
            res.setStatus(0);
            machineProfileRepository.delete(machineProfile);
            MachineData machineData_db = machineDataRepository.findByMachineId(machineProfile.getMachineId());
            if(machineData_db != null){
                machineDataRepository.deleteByMachineId(machineProfile.getMachineId());
            }
            res.setMessage("ลบสำเร็จ");
        } else {
            res.setStatus(1);
            res.setMessage("ลบไม่สำเร็จ");
        }
        return res;
    }

}
